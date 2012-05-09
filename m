Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab2EINgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:36:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43027 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515Ab2EINgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:36:12 -0400
Date: Wed, 9 May 2012 15:36:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
Message-ID: <20120509133607.GA26124@gmail.com>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
 <4FAA452A.1070909@gmail.com>
 <4FAA588B.5010404@redhat.com>
 <1336564330.2527.23.camel@twins>
 <4FAA5BFB.40309@redhat.com>
 <1336566096.2527.30.camel@twins>
 <1336566644.2527.33.camel@twins>
 <1336570043.2527.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336570043.2527.38.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> @@ -857,15 +860,19 @@ int kptr_restrict __read_mostly;
>   *       correctness of the format string and va_list arguments.
>   * - 'K' For a kernel pointer that should be hidden from unprivileged users
>   * - 'NF' For a netdev_features_t
> + * - 'b' For a bitmap, consumes 2 args, second is int

hm, won't the second arg confuse gcc's printf format checker?

> +	case 'b':
> +		{
> +			int bits, len;
> +
> +			switch (fmt[1]) {
> +			case 'c':
> +				bits = nr_cpumask_bits;
> +				break;
> +			case 'n':
> +				bits = MAX_NUMNODES;
> +				break;
> +			default:
> +				bits = va_arg(args, int);
> +				break;
> +			}
> +		       
> +			len = bitmap_scnlistprintf(buf, end - buf, ptr, bits);

also, if the second argument is not provided, could va_arg() 
return noise or even NULL?

Thanks,

	Ingo
