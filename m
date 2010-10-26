Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab0JZKCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:02:08 -0400
Received: from www.tglx.de ([62.245.132.106]:49112 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323Ab0JZKCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:02:06 -0400
Date: Tue, 26 Oct 2010 12:00:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Huang Ying <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
In-Reply-To: <20101026083806.GA14103@basil.fritz.box>
Message-ID: <alpine.LFD.2.00.1010261046390.6129@localhost6.localdomain6>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com> <1287992610-14996-10-git-send-email-ying.huang@intel.com> <20101025084553.GA27119@elte.hu> <alpine.LFD.2.00.1010252058370.11036@localhost.localdomain> <alpine.LFD.2.00.1010260629560.3955@localhost6.localdomain6>
 <20101026083806.GA14103@basil.fritz.box>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Andi Kleen wrote:
> > So please explain why your error reporting is so different from the
> > above that it justifies a separate facility. And you better come up
> > with a real good explanation other than we looked at EDAC and it did
> > not fit our needs.
> 
> Well it didn't fit the needs at all.  Is that not enough, Mr Inquisitor?

No, it's not enough without a reasonable explanation.

> Really if you want to nack and maintain and design things you need
> to do a bit more than just arguing from two lines of
> high level description.

If you want to shove a new facility into the kernel you need to do a
bit more than sending that stuff to LKML without explaining why you
can't use existing facilities and why it's impossible to extend those
existing facilities.

So the questions arise on the high level because you failed to provide
a reasonable explanation in the first place.

> EDAC enumerates hardware and exports some hardware
> registers and decodes a few errors in a format into
> the kernel log that is hard to impossible to post-process.

You are well aware that EDAC folks are working on consolidating the
interfaces and providing better error reporting, but it's out of your
interest so you just ignore that effort instead of working together?

> APEI does nothing of that, so it doesn't fit into EDAC.

Thanks for this overly detailed explanation.

APEI is about error detection and error reporting, nothing else. So
it fits into EDAC, which is an existing Error Detection and Correction
reporting facility by definition.

If you see EDAC has shortcomings, the proper answer to that is to go
there and work with those folks to make EDAC a fully integrated
facility. It's not like there's some disagreement with them.

But you did not even try to talk to them about this and went straight
ahead and implemented your own EDAC facility.

> The main interface in APEI right now is to manage fatal
> errors after reboot. ...

That's completely irrelevant.

It does not matter at all when and wherefrom error data come and
whether they were generated before or after reboot. That is the
hardware/firmware dependend side of things. Nobody is saying that this
isn't necessary.

But it matters very much how we report those errors. And it's not a
completely unreasonable request to avoid separate interfaces for the
very same problem, especially separate user space ABIs. 

If an existing facility has shortcomings, then the usual way is to
extend it for the sake of all existing users of that facility. We try
to consolidate stuff all over the place and avoid stuff which is
artificially separate, and that applies to that area as well.

Of course that might be more work and might change the design a bit,
but in the end it's a benefit for everyone.

Thanks,

	tglx
