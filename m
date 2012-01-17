Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2AQIjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:39:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55813 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab2AQIjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:39:18 -0500
Date: Tue, 17 Jan 2012 09:38:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>, justinmattock@gmail.com,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
Message-ID: <20120117083843.GC13181@elte.hu>
References: <20120116224028.GA5072@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116224028.GA5072@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Greg KH <gregkh@suse.de> wrote:

> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index f35ce43..6aefb14 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -151,7 +151,7 @@ static inline void enable_p5_mce(void) {}
>  
>  void mce_setup(struct mce *m);
>  void mce_log(struct mce *m);
> -DECLARE_PER_CPU(struct device, mce_device);
> +extern struct device *mce_device[CONFIG_NR_CPUS];

Minor nit, i don't think we have any other such [CONFIG_NR_CPUS] 
pattern in the kernel.

This should be something like:

  DECLARE_PER_CPU(struct device *, mce_device);

Or the pointer should be attached to the CPU info structure.

Thanks,

	Ingo
