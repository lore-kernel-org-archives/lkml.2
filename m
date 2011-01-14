Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1ANW7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:59:52 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:41713 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1ANW7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:59:51 -0500
Date: Sat, 15 Jan 2011 00:59:49 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: linux-parisc@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: compile failure on hppa64: pte_mkwrite
Message-ID: <alpine.SOC.1.00.1101150057210.8462@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tried todays 2.6.37+git on hppa64 and it fail to compile:

  CC      arch/parisc/kernel/asm-offsets.s
In file included from /home/mroos/linux-2.6/arch/parisc/include/asm/pgtable.h:13,
                 from arch/parisc/kernel/asm-offsets.c:37:
include/linux/mm.h: In function 'maybe_mkwrite':
include/linux/mm.h:482: error: implicit declaration of function 'pte_mkwrite'
include/linux/mm.h:482: error: incompatible types when assigning to type 'pte_t' from type 'int'
In file included from arch/parisc/kernel/asm-offsets.c:37:
/home/mroos/linux-2.6/arch/parisc/include/asm/pgtable.h: At top level:
/home/mroos/linux-2.6/arch/parisc/include/asm/pgtable.h:338: error: conflicting types for 'pte_mkwrite'
include/linux/mm.h:482: note: previous implicit declaration of 'pte_mkwrite' was here
make[1]: *** [arch/parisc/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

It seems pte_mkwrite is referenced in mm.h but not defined anywhere in 
include directory.

-- 
Meelis Roos (mroos@linux.ee)
