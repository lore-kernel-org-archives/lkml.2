Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0HXVkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:40:05 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:48926 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab0HXVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:40:02 -0400
Date: Tue, 24 Aug 2010 23:39:31 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Daniel Kiper <dkiper@net-space.pl>,
        mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, apic: Fix apic=debug boot crash
Message-ID: <20100824213931.GA1192@router-fw-old.local.net-space.pl>
References: <20100819224616.GB9967@router-fw-old.local.net-space.pl> <tip-05e407603e527f9d808dd3866d3a17c2ce4dfcc5@git.kernel.org> <AANLkTim9kjBp68LqieU3MDLbkRDiWLNQjtUvjEbc9Hca@mail.gmail.com> <20100823081212.GA13297@router-fw-old.local.net-space.pl> <9cca0990-1b78-40e7-a71d-f550b4f504aa@email.android.com> <4C72B6F7.8010706@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C72B6F7.8010706@kernel.org>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/23/2010 07:54 AM, H. Peter Anvin wrote:
> It's already applied.

Thx.

On Mon, Aug 23, 2010 at 10:59:19AM -0700, Yinghai Lu wrote:
[...]
> >>>> x86, apic: Fix apic=debug boot crash
> >>>>
> >>>> Fix a boot crash when apic=debug is used and the APIC is
> >>>> not properly initialized.
> >>>>
> >>>> This issue appears during Xen Dom0 kernel boot but the
> >>>> fix is generic and the crash could occur on real hardware
> >>>> as well.
> >>>
> >>> Do you have any report on real hardware?
> >>> that could not happen on real hardware.
> >>
> >> Till now no, however I think it is good idea
> >> to apply this patch now. It is not worth to wait
> >> for another null pointer dereference.
>
> no, we should add BUG_ON() etc debug info there to see why that null cfg could happen.
> because according to code, we should have null there.

I think that BUG_ON() is too strong here because
it is "debug" function and it should work also
with let's say "invalid" data (in Xen case it is
normal because APIC state is managed directly
by hypervisor).

Additionally, with this patch it is easy to
differentiate between cfg != NULL and
cfg == NULL. Please look below:

cfg != NULL:
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.

cfg == NULL:
IRQ to pin mappings:
.................................... done.

If I missed something or if you have any
questions please drop me a line.

Daniel
