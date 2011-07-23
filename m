Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1GWMPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 08:15:17 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:38917 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab1GWMPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 08:15:14 -0400
From: Richard Weinberger <richard@nod.at>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 07/10] um: Set __HAVE_ARCH_GATE_AREA for x86_64
Date: Sat, 23 Jul 2011 14:15:08 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
References: <1311239914-8301-1-git-send-email-richard@nod.at> <1311239914-8301-7-git-send-email-richard@nod.at> <20110722160127.ec061ab6.akpm@linux-foundation.org>
In-Reply-To: <20110722160127.ec061ab6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107231415.08718.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 23 Juli 2011, 01:01:27 schrieb Andrew Morton:
> On Thu, 21 Jul 2011 11:18:31 +0200
> 
> Richard Weinberger <richard@nod.at> wrote:
> > Implement arch_vma_name() and make get_gate_vma(),
> > in_gate_area() and in_gate_area_no_mm() a nop.
> > 
> > We need arch_vma_name() to support vDSO.
> 
> Well this is awkward.

Why?
Without it UML's vDSO will have no name.
E.g. when reading /proc/<pid>/maps

> >  arch/um/sys-x86_64/asm/elf.h |    1 +
> >  arch/um/sys-x86_64/mem.c     |   22 ++++++++++++++++++++++
> >  2 files changed, 23 insertions(+), 0 deletions(-)
> 
> Your um-clean-up-vm-flagsh.patch deleted arch/um/sys-x86_64/mem.c.
> 
> There's not really any appropriate .c file in arch/um/sys-x86_64 for
> these functions so I changed the patch to reinstate mem.c.
> 
> Then I changed my maind and dropped it ;) Hopefully none of the other
> patches depended on this one.
> 
> Then I looked at um-implement-a-x86_64-vdso.patch, got nervous and
> undropped um-set-__have_arch_gate_area-for-x86_64.patch.

I see, you've had some fun with this patch. ;-)
Sorry for that, I completely forgot rebasing my patches to mmotm.

Thanks,
//richard
