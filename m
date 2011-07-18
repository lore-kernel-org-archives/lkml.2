Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab1GREFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 00:05:14 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47709 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1GREFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 00:05:09 -0400
Message-ID: <4E23B0EB.2050301@in.ibm.com>
Date: Mon, 18 Jul 2011 09:34:59 +0530
From: Suzuki Poulose <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Benjammin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
CC: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kexec <kexec@lists.infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        Vivek Goyal <vgoyal@redhat.com>, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v2] powerpc32: Kexec support for PPC440X chipsets
References: <20110712064356.28567.48722.stgit@suzukikp.in.ibm.com>
In-Reply-To: <20110712064356.28567.48722.stgit@suzukikp.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/11 12:14, Suzuki K. Poulose wrote:
> Changes from V1: Uses a tmp mapping in the other address space to setup
> 		 the 1:1 mapping (suggested by Sebastian Andrzej Siewior).
>
> Note: Should we do the same for kernel entry code for PPC44x ?
>
> This patch adds kexec support for PPC440 based chipsets.This work is based
> on the KEXEC patches for FSL BookE.
>
> The FSL BookE patch and the code flow could be found at the link below:
>
> 	http://patchwork.ozlabs.org/patch/49359/
>
> Steps:
>
> 1) Invalidate all the TLB entries except the one this code is run from
> 2) Create a tmp mapping for our code in the other address space and jump to it
> 3) Invalidate the entry we used
> 4) Create a 1:1 mapping for 0-2GiB in blocks of 256M
> 5) Jump to the new 1:1 mapping and invalidate the tmp mapping
>
> I have tested this patches on Ebony, Sequoia boards and Virtex on QEMU.
> It would be great if somebody could test this on the other boards.

Forgot to mention:

You would need the current snapshot of kexec-tools, available at

git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git

The following commits(in the current tree) are needed for the support of ppc32.


commit 13f6d71bdf9836b90ae4ec21209383f1a3c56b0f
kexec-tools: ppc32: Fixup ThreadPointer for purgatory code

commit 9ec3fac7e8840fb31891ba49a626c5dd33e09e86
kexec-tools: powerpc: Use the #address-cells information to parsememory/reg

commit 806ef8870539a6c74a2a98188d0207a038b16f77
Fix memory errors on ppc


Thanks

Suzuki
