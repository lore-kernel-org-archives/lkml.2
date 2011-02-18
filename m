Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1BRHay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 02:30:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53788 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab1BRHar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 02:30:47 -0500
Date: Fri, 18 Feb 2011 08:30:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86: Minimize initial e820 messages
Message-ID: <20110218073032.GD11404@elte.hu>
References: <20110217185131.960038922@gulag1.americas.sgi.com>
 <20110217185132.267615941@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217185132.267615941@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> --- linux.orig/arch/x86/kernel/e820.c
> +++ linux/arch/x86/kernel/e820.c
> @@ -38,6 +38,8 @@
>   */
>  struct e820map e820;
>  struct e820map e820_saved;
> +struct e820map e820_prev __initdata;
> +int e820_prev_saved __initdata;

Please add comments to the code that describe what these global variables do.

Also, they should be 'static' as they are only used in e820.c, right?

	Ingo
