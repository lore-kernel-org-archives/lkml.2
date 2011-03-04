Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836Ab1CDPv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:51:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62079 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759668Ab1CDPvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:51:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OVr4eLLG0Mf9G9hHxcK8/xary4iadIFZ4dQI8/FtJTLWkVGn/0WIHDfSaIIGHxxmBp
         nTDYRPDiuViUS5KaYxSJ7tqBafFIRJldGLrQxaWt6AZyNxqX6ofAo71Qmc7aRYPbSPfx
         A/ANZ7lDRod6ZKqOUHlzwIEjt87Inoc+i+iPA=
Date: Fri, 4 Mar 2011 16:51:18 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: [GIT PULL tip:x86/mm] x86-64 NUMA changes
Message-ID: <20110304155106.GU20499@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Please pull from the following git branch to receive x86-64 NUMA
changes.  It contains four commits.  As discussed before, NUMA affine
page table allocation is reverted.  Two to fix node0 online assumption
and one making initmem_init() prettier.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

As usual, if HEAD doesn't appear, please pull from master.

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

tip:x86/mm contains d04c579f9 (x86: Work around old gas bug) making
this pull non-fastforward; however, pulling won't generate any
conflict.

Thank you.

David Rientjes (1):
      x86-64, NUMA: Clean up initmem_init()

Tejun Heo (2):
      x86-64, NUMA: Revert NUMA affine page table allocation
      x86-64, NUMA: Don't assume phys node 0 is always online in numa_emulation()

Yinghai Lu (1):
      x86-64, NUMA: Fix numa_emulation code with node0 without RAM

 arch/x86/include/asm/page_types.h |    2 -
 arch/x86/kernel/setup.c           |    8 +++
 arch/x86/mm/init_64.c             |   54 ---------------------
 arch/x86/mm/numa_64.c             |   96 +++++++++++++++++++++----------------
 arch/x86/mm/numa_emulation.c      |   20 ++++++--
 5 files changed, 79 insertions(+), 101 deletions(-)

-- 
tejun
