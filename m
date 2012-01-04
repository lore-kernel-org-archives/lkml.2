Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab2ADISi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 03:18:38 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:36118 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab2ADISg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 03:18:36 -0500
Subject: [Pull: unicore32] Please pull unicore32 bugfix  patches
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Wed, 04 Jan 2012 16:20:40 +0800
Message-ID: <1325665240.1862.37.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,
  Could you please pull unicore32 bugfix patches from my repo:
        git://github.com/gxt/linux.git unicore32

  There are 10 patches in unicore32 branch with their logs listed below.

Thanks & Regards,
Guan Xuetao

---
commit fa2f5764b65c41d12b48553886ca5ca9cc6d730d
Author: Guan Xuetao <gxt@mprc.pku.edu.cn>
Date:   Wed Dec 28 09:24:29 2011 +0800

    rtc-puv3: solve section mismatch in rtc-puv3.c
    
    The patch renames puv3_rtcdrv to puv3_rtc_driver, so that modpost
will know
    that this is simply a list of pointers to driver functions, in which
case
    the section mismatch is OK. (Thanks Michal Marek)
    
    Cc: Axel Lin <axel.lin@gmail.com>
    Cc: Michal Marek <mmarek@suse.cz>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: Alessandro Zummo <a.zummo@towertech.it>
    Cc: rtc-linux@googlegroups.com
    Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
    
    --
    Section mismatch warning information:
    
    WARNING: drivers/rtc/built-in.o(.data+0x90): Section mismatch in
    reference from the variable puv3_rtcdrv to the
    function .devinit.text:puv3_rtc_probe()
    The variable puv3_rtcdrv references
    the function __devinit puv3_rtc_probe()
    If the reference is valid then annotate the
    variable with __init* or __refdata (see linux/init.h) or name the
    variable:
    *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
    *_console
    
    WARNING: drivers/rtc/built-in.o(.data+0x94): Section mismatch in
    reference from the variable puv3_rtcdrv to the
    function .devexit.text:puv3_rtc_remove()
    The variable puv3_rtcdrv references
    the function __devexit puv3_rtc_remove()
    If the reference is valid then annotate the
    variable with __exit* (see linux/init.h) or name the variable:
    *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
    *_console
    
    WARNING: drivers/built-in.o(.data+0x6c04): Section mismatch in
reference
    from the variable puv3_rtcdrv to the
    function .devinit.text:puv3_rtc_probe()
    The variable puv3_rtcdrv references
    the function __devinit puv3_rtc_probe()
    If the reference is valid then annotate the
    variable with __init* or __refdata (see linux/init.h) or name the
    variable:
    *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
    *_console
    
    WARNING: drivers/built-in.o(.data+0x6c08): Section mismatch in
reference
    from the variable puv3_rtcdrv to the
    function .devexit.text:puv3_rtc_remove()
    The variable puv3_rtcdrv references
    the function __devexit puv3_rtc_remove()
    If the reference is valid then annotate the
    variable with __exit* (see linux/init.h) or name the variable:
    *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
    *_console
    
    WARNING: vmlinux.o(.data+0x1126c): Section mismatch in reference
from
    the variable puv3_rtcdrv to the
function .devinit.text:puv3_rtc_probe()
    The variable puv3_rtcdrv references
    the function __devinit puv3_rtc_probe()
    If the reference is valid then annotate the
    variable with __init* or __refdata (see linux/init.h) or name the
    variable:
    *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
    *_console
    
    WARNING: vmlinux.o(.data+0x11270): Section mismatch in reference
from
    the variable puv3_rtcdrv to the
function .devexit.text:puv3_rtc_remove()
    The variable puv3_rtcdrv references
    the function __devexit puv3_rtc_remove()
    If the reference is valid then annotate the
    variable with __exit* (see linux/init.h) or name the variable:
    *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
    *_console

 drivers/rtc/rtc-puv3.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

commit 54ba218843edb283f0ed1f70ac7788a8607e8ddd
Author: Guan Xuetao <gxt@mprc.pku.edu.cn>
Date:   Mon Dec 26 17:03:50 2011 +0800

    rtc-puv3: using module_platform_driver()
    
    This patch converts the driver to use the module_platform_driver()
    macro which makes the code smaller and a bit simpler.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

 drivers/rtc/rtc-puv3.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

commit 9d4875c6f87a7be401b8c3ce1d61b6a0e0463f01
Author: Guan Xuetao <gxt@mprc.pku.edu.cn>
Date:   Mon Dec 26 16:59:34 2011 +0800

    i2c-puv3: using module_platform_driver()
    
    This patch converts the driver to use the module_platform_driver()
    macro which makes the code smaller and a bit simpler.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

 drivers/i2c/busses/i2c-puv3.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

commit 617466e886ed0a0b224ba0d432efcd3854d90b17
Author: Guan Xuetao <gxt@mprc.pku.edu.cn>
Date:   Fri Dec 23 09:15:39 2011 +0800

    rtc-puv3: irq: remove IRQF_DISABLED
    
    This flag is deprecated, so is removed now.
    
    Signed-off-by: Yong Zhang <yong.zhang@gmail.com>
    Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

 drivers/rtc/rtc-puv3.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

commit 9aa75be7c42d5a77e31246628209d53b3ef8ca70
Author: Yong Zhang <yong.zhang0@gmail.com>
Date:   Wed Sep 7 16:10:19 2011 +0800

    unicore32: Remove IRQF_DISABLED
    
    This flag is a NOOP and can be removed now.
    
    Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

 arch/unicore32/kernel/puv3-nb0916.c |    4 ++--
 arch/unicore32/kernel/time.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

commit 4dc05cdb15a6e02c2f40acebc1c11a52cb49ddea
Author: Matt Fleming <matt.fleming@intel.com>
Date:   Thu Aug 11 14:57:06 2011 +0100

    unicore32: Use set_current_blocked()
    
    As described in e6fa16ab ("signal: sigprocmask() should do
    retarget_shared_pending()") the modification of current->blocked is
    incorrect as we need to check whether the signal we're about to
block
    is pending in the shared queue.
    
    Cc: Oleg Nesterov <oleg@redhat.com>
    Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
    Signed-off-by: Matt Fleming <matt.fleming@intel.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

 arch/unicore32/kernel/signal.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

commit 2e1c93f18b1461927cf68550ae5dd4459e0c12e9
Author: Guan Xuetao <gxt@mprc.pku.edu.cn>
Date:   Thu Aug 18 15:38:05 2011 +0800

    unicore32: add ioremap_nocache definition
    
    Bugfix for following error messages:
    lib/iomap.c: In function 'pci_iomap':
    lib/iomap.c:274: error: implicit declaration of function
'ioremap_nocache'
    lib/iomap.c:274: warning: return makes pointer from integer without
a cast
    
    Also see commit <f1ecc69838a2d7c8a3e1909f637d4083c071777d>
      it will hide the ioremap_nocache function for systems with an MMU
    
    Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: Jonas Bonn <jonas@southpole.se>

 arch/unicore32/include/asm/io.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

commit ae4f1682c06f7b23c1061ed5b221eec73e9bd8be
Author: Guan Xuetao <gxt@mprc.pku.edu.cn>
Date:   Thu Aug 18 15:43:10 2011 +0800

    unicore32: delete specified xlate_dev_mem_ptr
    
    For the commit <f1ecc69838a2d7c8a3e1909f637d4083c071777d> has
changed
    xlate_dev_mem_ptr definition in asm-generic/io.h for the systems
with
    an MMU, so delete it from unicore32 specified io.h.
    
    Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: Jonas Bonn <jonas@southpole.se>

 arch/unicore32/include/asm/io.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

commit d9edfca3ffe1b6c95a04f167bf3a0164a2748e3a
Author: Yu Yue <yuyue@mprc.pku.edu.cn>
Date:   Fri Aug 26 18:03:42 2011 +0800

    of: add include asm/setup.h in drivers/of/fdt.c
    
    In the file drivers/of/fdt.c, it uses the COMMAND_LINE_SIZE which is
stated
    in asm/setup.h, so asm/setup.h should be included in
drivers/of/fdt.c.
    
    Signed-off-by: Yu Yue <yuyue@mprc.pku.edu.cn>
    Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
    
    Cc: Grant Likerly <grant.likely@secretlab.ca>
    Cc: devicetree-discuss@lists.ozlabs.org
    Cc: Arnd Bergmann <arnd@arndb.de>

 drivers/of/fdt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

commit 19accaaca455081a464c23a8936c213ca48fca4c
Author: Kees Cook <keescook@chromium.org>
Date:   Mon Dec 12 15:04:29 2011 -0800

    unicore32: standardize /proc/iomem "Kernel code" name
    
    All other ports use "Kernel code" to identify the Kernel text
segment
    in /proc/iomem. Change the unicore32 resources to do the same.
    
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Acked-by: Arnd Bergmann <arnd@arndb.de>

 arch/unicore32/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

