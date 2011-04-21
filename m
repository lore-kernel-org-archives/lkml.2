Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab1DUJgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:36:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59372 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab1DUJgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:36:16 -0400
Date: Thu, 21 Apr 2011 11:35:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Russ Anderson <rja@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] x86, MCE: Do not taint when handling correctable
 errors
Message-ID: <20110421093554.GB4262@elte.hu>
References: <1302857141-17580-1-git-send-email-bp@amd64.org>
 <66D9D2F0CDB5C9428E6166B01EC85EE162EF92B0F3@GVW0676EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66D9D2F0CDB5C9428E6166B01EC85EE162EF92B0F3@GVW0676EXC.americas.hpqcorp.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chumbalkar, Nagananda <Nagananda.Chumbalkar@hp.com> wrote:

> Would it be okay to extend this reasoning and also remove the tainting 
> caused by TM1/TM2 thermal events:
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index 6f8c5e9..9f3b5ae 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -188,7 +188,6 @@ static int therm_throt_process(bool new_event, int event,
> int level)
>                                 level == CORE_LEVEL ? "Core" : "Package",
>                                 state->count);
> 
> -               add_taint(TAINT_MACHINE_CHECK);
>                 return 1;
>         }
>         if (old_event) {
> @@ -393,7 +392,6 @@ static void unexpected_thermal_interrupt(void)
> {
>         printk(KERN_ERR "CPU%d: Unexpected LVT thermal interrupt!\n",
>                         smp_processor_id());
> -       add_taint(TAINT_MACHINE_CHECK);
> }

Mind sending a proper patch, with changelog, signoff, acks, etc?

Thanks,

	Ingo
