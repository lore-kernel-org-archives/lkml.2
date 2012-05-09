Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab2EIOTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:19:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34140 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757095Ab2EIOTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:19:47 -0400
Message-ID: <1336573182.30189.42.camel@joe2Laptop>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Igor Mammedov <imammedo@redhat.com>,
        Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        pjt@google.com, tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 09 May 2012 07:19:42 -0700
In-Reply-To: <1336571947.2527.47.camel@twins>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
	 <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
	 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
	 <1336566096.2527.30.camel@twins> <1336566644.2527.33.camel@twins>
	 <1336570043.2527.38.camel@twins> <20120509133607.GA26124@gmail.com>
	 <1336571049.2527.43.camel@twins> <1336571947.2527.47.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 15:59 +0200, Peter Zijlstra wrote:
> The current implementation limits both (field_width and precision) to
> s16, which will limit us to printing 32Kb bitmaps. If need arises we
> could increase printf_spec size I guess.

Not sure that's a problem really.
A single printk is limited to 1024 bytes.

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -941,6 +947,26 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  			return netdev_feature_string(buf, end, ptr, spec);
>  		}
>  		break;
> +	case 'b':
> +		{
> +			int bits, len;

trivia: a tab indent could be avoided by using
	case b: {


