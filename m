Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1GNPlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:41:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:35707 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab1GNPk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:40:59 -0400
Date: Thu, 14 Jul 2011 17:40:42 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: Benjammin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        kexec <kexec@lists.infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v2] powerpc32: Kexec support for PPC440X chipsets
Message-ID: <20110714154042.GA14975@linutronix.de>
References: <20110712064356.28567.48722.stgit@suzukikp.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110712064356.28567.48722.stgit@suzukikp.in.ibm.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suzuki K. Poulose | 2011-07-12 12:14:16 [+0530]:

>Changes from V1: Uses a tmp mapping in the other address space to setup
>		 the 1:1 mapping (suggested by Sebastian Andrzej Siewior).
>
>Note: Should we do the same for kernel entry code for PPC44x ?

You have one the kernel mapping. Then you make your temporary mapping
which might be just the one valid TLB entry (after you invalidated the
others). After that you setup multiple mappings to cover 0..2GiB address
space. Since the kernel runs at 0xC.... and you need 0x0.. for the same
memory you end up at some point with two mappings for the same memory.
The reference manual says one should not have two active mappings for
piece of memory. That is why the "other address space" is should be
used.
So I think using this "other address space" for the entry code isn't a
bad idea.

However, I'm fine with this patch.

Sebastian
