Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0JZEx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 00:53:56 -0400
Received: from www.tglx.de ([62.245.132.106]:35818 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab0JZExz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 00:53:55 -0400
Date: Tue, 26 Oct 2010 06:53:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Len Brown <lenb@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
In-Reply-To: <alpine.LFD.2.00.1010252058370.11036@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1010260629560.3955@localhost6.localdomain6>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com> <1287992610-14996-10-git-send-email-ying.huang@intel.com> <20101025084553.GA27119@elte.hu> <alpine.LFD.2.00.1010252058370.11036@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cLen,

On Mon, 25 Oct 2010, Len Brown wrote:

> >  NAKed-by: Ingo Molnar <mingo@elte.hu>
> 
> Everybody knows that Linux has a lot to learn about RAS.
> 
> I think to catch up, we need to play to Linux's strengths
> of continuous improvement.  If we halt patches in this area
> then we could wait forever for the "perfect design".

it's not about perfect design. It's about creating new user space
ABIs. The patches introduce another error reporting user space ABI
with an ad hoc "fits the needs" design.

This is my major point of objection. 

I agree that Linux needs improvement on the RAS side, but does this
lack of features justify a new user space ABI which is totally
disconnected to existing RAS facilities ?

No, it does not. It's not our problem that Intel wasted time on
creating another character device driver to report errors to user
space. The time spent to do so would have been sufficient to do a
proper integration into the existing infrastructure.

I would not care at all if these patches would just introduce some
weird in kernel interfaces as we can clean that up at will. But
introducing a new user space ABI is setting the disconnect of RAS
related facilities into stone.

>From Kconfig:

  EDAC is designed to report errors in the core system.
  These are low-level errors that are reported in the CPU or
  supporting chipset or other subsystems:
  memory errors, cache errors, PCI errors, thermal throttling, etc..
  If unsure, select 'Y'.

So please explain why your error reporting is so different from the
above that it justifies a separate facility. And you better come up
with a real good explanation other than we looked at EDAC and it did
not fit our needs.

Thanks,

	tglx
