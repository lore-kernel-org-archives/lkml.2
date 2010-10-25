Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0JYJ01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:26:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39697 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab0JYJ0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:26:25 -0400
Date: Mon, 25 Oct 2010 11:25:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
Message-ID: <20101025092557.GA11544@elte.hu>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
 <1287997112.2862.322.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287997112.2862.322.camel@yhuang-dev>
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


* Huang Ying <ying.huang@intel.com> wrote:

> > Sigh, please integrate all this into EDAC (drivers/edac/) properly, instead of 
> > turning it into YET ANOTHER hardware vendor special hw-errors thing. We can do 
> > better than this. EDAC is almost there: it has support for Nehalem, AMD, a 
> > couple of older chips.
> 
> I think APEI (ACPI Platform Error Interface) is another driver. Why integrate two 
> drivers?

Sigh. I did not say integrate the drivers - integrate the _error event facilities_. 

You can have drivers/edac/apei/ghes* bits just fine (in fact it would be desirable, 
to keep things modular).

Really, just read the two Kconfig entries:

        bool "EDAC (Error Detection And Correction) reporting"

          EDAC is designed to report errors in the core system.
          These are low-level errors that are reported in the CPU or
          supporting chipset or other subsystems:
          memory errors, cache errors, PCI errors, thermal throttling, etc..

...

        tristate "APEI Generic Hardware Error Source"

          Generic Hardware Error Source provides a way to report
          platform hardware errors (such as that from chipset).

drivers/acpi/apei/ overlaps and duplicates drivers/edac/. We dont want two 
facilities, two ABIs, two sets of behavior. erst-dbg even defines a /dev node with 
two ioctls, and a debugfs file to read/write records ...

I have NAK-ed various attempts to extend /dev/mcelog and asked for it to be done 
properly, and work has begun on that - but the debugfs interface here just tries to 
work around those objections by stealth.

I'd like you and Andi to listen not just to the letter of NAKs but to the spirit as 
well. If you get a NAK in one subsystem you should not just try to route around the 
NAK, go to some other subsystem, figure out a slightly different scheme and try to 
sneak crap upstream ...

If you disagree with the mcelog NAK, if you disagree with EDAC directions then at 
least do it openly and honestly and Cc: the parties that sent you the NAK and work 
with the EDAC guys to migrate to the facility you are advancing ...

Thanks,

	Ingo
