Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1AaC74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 21:59:56 -0500
Received: from ozlabs.org ([203.10.76.45]:38592 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab1AaC7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:59:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon panic
Date: Mon, 31 Jan 2011 13:29:31 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Mark Lord <kernel@teksavvy.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "X86-ML" <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        "IDE-ML" <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
References: <20110125134748.GA10051@laptop> <4D3F529D.8060406@pobox.com> <4D3F559C.1050809@zytor.com>
In-Reply-To: <4D3F559C.1050809@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101311329.31562.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 09:28:36 am H. Peter Anvin wrote:
> On 01/25/2011 02:45 PM, Jeff Garzik wrote:
> > On 01/25/2011 05:16 PM, Randy Dunlap wrote:
> >> On Tue, 25 Jan 2011 17:10:49 -0500 Mark Lord wrote:
> >>
> >>> On 11-01-25 12:05 PM, Ahmed S. Darwish wrote:
> >>>>
> >>>> My current x86 laptop includes the very common ATA PIIX controller.
> >>>
> >>>
> >>> ata_piix is just about ideal for this sort of thing.
> >>>
> >>> Except, don't use the BIOS to write the logs,
> >>> but rather code/use a very simple set of polling-PIO
> >>> functions to talk directly through the PIIX to the drive.
> >>>
> >>> Really really simple code to do that, and it would likely
> >>> work with anything ata-piix, and most other non-AHCI chipsets too.
> >>>
> >>> Not perfect, but probably good enough for a lot of scenarios.
> >>> The old hd.c driver shows how to read/write a sector at a time,
> >>> and that kind of code is easily converted to simply poll for completion.
> >>
> >> I don't know how/where to find it, but Rusty Russell had a version of this
> >> many, many years ago.
> > 
> > You beat me to the reply :)
> > 
> > http://lwn.net/Articles/9905/
> > 
> > but IIRC there were updates and improvements.
> > 
> 
> "Not perfect" is really not good enough.  You're writing to the disk, so
> it *has* to be perfect.  That means dealing with having shared IDE/AHCI
> device and doing the right thing, and the possibility that the kernel
> has interrupts enabled, yadda yadda.

Not for the limited problem of trying to get some logs out.

My driver read the sectors, checked it was full of the magic signature, then
overwrote them.  It's possible for that to screw up, but unlikely.  The boot
script mailed it off to a central site, reset the sector and rearmed the
oopsdumper.

> In the end you end up with something that looks, again, like kexec/kdump.

That was the proposed solution back then, too.  If I'd realized how long
that would take to arrive, I would have kept pushing...

BTW, anyone know whether distros turn it on?    Ubuntu seems to enable it
in the config, but I've never seen it in action.  My laptop has frozen
a couple of times, but maybe it really froze...

Cheers,
Rusty.
