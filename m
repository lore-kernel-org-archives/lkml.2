Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1BXOvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:51:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65141 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab1BXOve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:51:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dReELziLTCw/C3UdiKaL87DsjKntAVk5NjYw8k0aOywfySEWemS3xI/eYIWelDOkKT
         HFwjlMHuJBlZ0x/l+gRlletIrkRhboURI/D0ma6fgJ1LUHlfDObjuvsIUmyPfKBrz2Bp
         BTy7HcYfKjs8NDYcdDbS7H03LfXkQXJ+9+M/E=
Date: Thu, 24 Feb 2011 15:51:28 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL tip:x86/mm]
Message-ID: <20110224145128.GM7840@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from the following git branch to receive four
commits from Yinghai.  HEAD is d1b19426b0 (x86: Rename e820_table_* to
pgt_buf_*).

The first three separate nobootmem code into mm/nobootmem.c and the
last one renames e820_table_* variables to pgt_buf_*.  All four
patches are cleanups and shouldn't cause any behavior difference.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

As usual, if HEAD doesn't appear, please pull from master.

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

Thanks.

Yinghai Lu (4):
      bootmem: Separate out CONFIG_NO_BOOTMEM code into nobootmem.c
      bootmem: Move contig_page_data definition to bootmem.c/nobootmem.c
      bootmem: Move __alloc_memory_core_early() to nobootmem.c
      x86: Rename e820_table_* to pgt_buf_*

 arch/x86/include/asm/init.h |    6 +-
 arch/x86/mm/init.c          |   20 +-
 arch/x86/mm/init_32.c       |    8 +-
 arch/x86/mm/init_64.c       |    4 +-
 arch/x86/xen/mmu.c          |    2 +-
 include/linux/mm.h          |    2 -
 mm/Makefile                 |    8 +-
 mm/bootmem.c                |  180 +-----------------
 mm/nobootmem.c              |  435 +++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |   37 ----
 10 files changed, 472 insertions(+), 230 deletions(-)
 create mode 100644 mm/nobootmem.c

-- 
tejun
