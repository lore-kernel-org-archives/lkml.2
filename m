Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab1ESO4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab1ESO4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:56:11 -0400
Date: Thu, 19 May 2011 10:56:05 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: CPUFREQ git pull for 2.6.40 [1/2]
Message-ID: <20110519145605.GA5076@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ next

 Documentation/cpu-freq/governors.txt         |   11 +++
 arch/arm/mach-s5pv210/cpufreq.c              |    3 +-
 arch/arm/mach-s5pv310/cpufreq.c              |    3 +-
 arch/arm/plat-s3c24xx/cpu-freq.c             |    2 +-
 arch/powerpc/platforms/powermac/cpufreq_32.c |    2 +-
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c    |    2 -
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c    |    3 +-
 drivers/cpufreq/cpufreq.c                    |    2 +-
 drivers/cpufreq/cpufreq_conservative.c       |  123 ++------------------------
 drivers/cpufreq/cpufreq_ondemand.c           |  122 +++-----------------------
 include/linux/cpufreq.h                      |   11 +--
 11 files changed, 36 insertions(+), 248 deletions(-)

commit bdce2595a2f539c6fdedd8f2bd281326b627bba3
Author: Chumbalkar, Nagananda <Nagananda.Chumbalkar@hp.com>
Date:   Wed Mar 16 21:37:41 2011 +0000

    [CPUFREQ] pcc-cpufreq: remove duplicate statements
    
    Remove a couple of assigment statements that appear twice.
    
    Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 7ca64e2d2859e96a325c28678b5fdb5e17a5764b
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Mar 10 21:13:05 2011 +0100

    [CPUFREQ] Remove the pm_message_t argument from driver suspend
    
    None of the existing cpufreq drivers uses the second argument of
    its .suspend() callback (which isn't useful anyway), so remove it.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 326c86deaed54ad1b364fcafe5073f563671eb58
Author: Thomas Renninger <trenn@suse.de>
Date:   Thu Mar 3 21:31:27 2011 +0100

    [CPUFREQ] Remove unneeded locks
    
    There cannot be any concurrent access to these through
    different cpu sysfs files anymore, because these tunables
    are now all global (not per cpu).
    
    I still have some doubts whether some of these locks
    were needed at all. Anyway, let's get rid of them.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Dave Jones <davej@redhat.com>
    CC: cpufreq@vger.kernel.org

commit e8951251b89440644a39f2512b4f265973926b41
Author: Thomas Renninger <trenn@suse.de>
Date:   Thu Mar 3 21:31:26 2011 +0100

    [CPUFREQ] Remove old, deprecated per cpu ondemand/conservative sysfs files
    
    Marked deprecated for quite a whilte now...
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Dave Jones <davej@redhat.com>
    CC: cpufreq@vger.kernel.org

commit ef598549b28014ec2ea7574d4e793728e0e33d02
Author: Thomas Renninger <trenn@suse.de>
Date:   Thu Mar 3 21:31:25 2011 +0100

    [CPUFREQ] Remove deprecated sysfs file sampling_rate_max
    
    Marked deprecated for quite a while now...
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Dave Jones <davej@redhat.com>
    CC: cpufreq@vger.kernel.org

commit 9e91869544fc831d640cae1ffd0313b38657b593
Author: Thomas Renninger <trenn@suse.de>
Date:   Thu Mar 3 21:31:24 2011 +0100

    [CPUFREQ] powernow-k8: The table index is not worth displaying
    
    and it also is misleading due to another message above
    which makes the index look like it is the CPU.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=24562
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Dave Jones <davej@redhat.com>
    CC: cpufreq@vger.kernel.org

commit 5cb2c3bd0c5e0f3ced63f250ec2ad59d7c5c626a
Author: Vincent Guittot <vincent.guittot@linaro.org>
Date:   Mon Feb 7 17:14:25 2011 +0100

    [CPUFREQ] calculate delay after dbs_check_cpu
    
    calculate ondemand delay after dbs_check_cpu call because it can
    modify rate_mult value
    
    use freq_lo_jiffies value for the sub sample period of powersave_bias mode
    
    Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 5b95364f6101d67a073a5ec18d726e94e02ca605
Author: Vishwanath BS <vishwanath.bs@ti.com>
Date:   Tue Jan 25 20:12:41 2011 +0530

    [CPUFREQ] Add documentation for sampling_down_factor
    
    Update cpufreq governor documentation for sampling_down_factor tunable
    parameter.
    
    Signed-off-by: Vishwanath BS <vishwanath.bs@ti.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 2feb690c20d52e22c7874a1e090245e6a4344ce6
Author: Joe Perches <joe@perches.com>
Date:   Sun Nov 14 19:04:23 2010 -0800

    [CPUFREQ] drivers/cpufreq: Remove unnecessary semicolons
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Dave Jones <davej@redhat.com>
