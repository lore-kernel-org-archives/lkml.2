Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1D0DE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 23:04:56 -0400
Received: from home.ambisys.com ([61.215.192.134]:35958 "EHLO home.ambisys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1D0DEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 23:04:55 -0400
X-Greylist: delayed 1863 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Apr 2011 23:04:54 EDT
Message-ID: <4DB7808C.9030005@variosecure.net>
Date: Wed, 27 Apr 2011 11:33:48 +0900
From: Tim Burress <tim@variosecure.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.34-2.6.38.4: Intermittently hang on boot in kernel/irq/autoprobe?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: No, SpamSonar (level 0.1)
X-Ambisys-VC: 20731@d7f013f8a41a33a326105ce05f20e8ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been seeing an occasional problem in which the kernel hangs very 
early in the boot process. Just inserting printk()'s it seems that this 
occurs in kernel/irq/autoprobe.c, function probe_irq_on() in the loop 
immediately after the comment

         /*
          * enable any unassigned irqs
          * (we must startup again here because if a longstanding irq
          * happened in the previous stage, it may have masked itself)
          */

This occurs the first time the function is called during boot. I first 
noticed it in 2.6.34 but then it seemed to disappear after upgrading to 
the (then current) 2.6.37.2. But then after a while I started seeing it 
again, perhaps once every 15 reboots. I've since rebuild with 2.6.38.4 
and some of the lock debugging options turned on:

CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y

but the problem remains (and I get no lock debugging output), so I 
thought I would post something.

The kernel is compiled with CONFIG_SMP but the hardware I'm testing on 
has a single, single-core (VIA Nehemiah) CPU. The hardware appears to 
have no NMI support, so that watchdog seems to be disabled on boot, and 
when the system hangs, it hangs forever. What's the best way to track 
this down? Or if there's information/tests that would be helpful, just 
let me know. Puzzling...

Thanks!

Tim

