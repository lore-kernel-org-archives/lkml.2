Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1DAJWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 05:22:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38173 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab1DAJWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 05:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FsPapngg+QFck7BU4v0cNFlcDTajJEveAICAykYa2LQuFwBnyIp0BX06zYist7mEuz
         mx5crnJ8GYk/HBLzuts/QeWEZ2psfIfOLRWNG2hKLvL04bCvJh0Iay98300P+V+4zT0e
         o5/sOMtlXkYsUiCNCW6zfVDWWId0iPdMr1Dnw=
Date: Fri, 1 Apr 2011 11:22:18 +0200
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu
Cc: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, cl@linux.com
Subject: [GIT PULL tip:x86/mm] this_cpu_has() changes and phys_to_nid()
 removal
Message-ID: <20110401092218.GJ3385@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Please pull from the following git branch to receive five patches.
Three of them are Christoph's this_cpu_has() patches.  One removes the
custom x86-64 phys_to_nid() implementation and the last one cleans up
arch/x86/Kconfig a bit.  HEAD is 3b16651f80 (x86: Clean up memory
model related configs in arch/x86/Kconfig).

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

As usual, if HEAD doesn't appear, please pull from master.

 ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

Thanks.

Christoph Lameter (3):
      x86: A fast way to check capabilities of the current cpu
      x86: Use this_cpu_has for thermal_interrupt current cpu
      acpi throttling: Use this_cpu_has and simplify code current cpu

Tejun Heo (2):
      x86-64, NUMA: Remove custom phys_to_nid() implementation
      x86: Clean up memory model related configs in arch/x86/Kconfig

 arch/x86/Kconfig                         |   30 +++----
 arch/x86/include/asm/cpufeature.h        |   13 ++-
 arch/x86/include/asm/mmzone_64.h         |   23 ------
 arch/x86/include/asm/percpu.h            |   27 +++++++
 arch/x86/kernel/apic/apic.c              |    2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    7 +-
 arch/x86/kernel/process.c                |    4 +-
 arch/x86/kernel/smpboot.c                |    4 +-
 arch/x86/mm/numa_64.c                    |  123 +-----------------------------
 drivers/acpi/processor_throttling.c      |   32 +++-----
 10 files changed, 68 insertions(+), 197 deletions(-)

 --
 tejun
 
