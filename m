Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab0JZHWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 03:22:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab0JZHWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 03:22:40 -0400
Date: Tue, 26 Oct 2010 09:22:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>, Huang Ying <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
Message-ID: <20101026072210.GE13036@elte.hu>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
 <alpine.LFD.2.00.1010252058370.11036@localhost.localdomain>
 <alpine.LFD.2.00.1010260629560.3955@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010260629560.3955@localhost6.localdomain6>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> >From Kconfig:
> 
>   EDAC is designed to report errors in the core system.
>   These are low-level errors that are reported in the CPU or
>   supporting chipset or other subsystems:
>   memory errors, cache errors, PCI errors, thermal throttling, etc..
>   If unsure, select 'Y'.
> 
> So please explain why your error reporting is so different from the above that it 
> justifies a separate facility. And you better come up with a real good explanation 
> other than we looked at EDAC and it did not fit our needs.

Btw., it's not just about EDAC - the firmware can store Linux events persistently 
(beyond allowing the firmware to insert its own RAS events), that is obviously 
_hugely_ useful for kernel debugging in general. We could inject debugging events 
there and recover them after a crash, etc.

As long as it's all integrated into the standard event logging facilities it could 
be very useful (and i dont generally complain about things that are insignificant).

As /dev/erst-dbg it's not useful at all - in fact it might close the door to sane 
future usage of this hw facility if some crappy user-space learns to rely on the 
/dev/erst-dbg ABI.

Thanks,

	Ingo
