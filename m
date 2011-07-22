Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1GVXCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 19:02:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab1GVXCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 19:02:11 -0400
Date: Fri, 22 Jul 2011 16:01:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 07/10] um: Set __HAVE_ARCH_GATE_AREA for x86_64
Message-Id: <20110722160127.ec061ab6.akpm@linux-foundation.org>
In-Reply-To: <1311239914-8301-7-git-send-email-richard@nod.at>
References: <1311239914-8301-1-git-send-email-richard@nod.at>
	<1311239914-8301-7-git-send-email-richard@nod.at>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 11:18:31 +0200
Richard Weinberger <richard@nod.at> wrote:

> Implement arch_vma_name() and make get_gate_vma(),
> in_gate_area() and in_gate_area_no_mm() a nop.
> 
> We need arch_vma_name() to support vDSO.

Well this is awkward.

>  arch/um/sys-x86_64/asm/elf.h |    1 +
>  arch/um/sys-x86_64/mem.c     |   22 ++++++++++++++++++++++
>  2 files changed, 23 insertions(+), 0 deletions(-)

Your um-clean-up-vm-flagsh.patch deleted arch/um/sys-x86_64/mem.c.

There's not really any appropriate .c file in arch/um/sys-x86_64 for
these functions so I changed the patch to reinstate mem.c.

Then I changed my maind and dropped it ;) Hopefully none of the other
patches depended on this one.

Then I looked at um-implement-a-x86_64-vdso.patch, got nervous and
undropped um-set-__have_arch_gate_area-for-x86_64.patch.

