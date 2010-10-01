Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab0JAFpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:45:47 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:58866 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0JAFpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:45:44 -0400
Date: Fri, 01 Oct 2010 01:45:22 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI patches for Linux 2.6.36-rc6
Message-id: <alpine.LFD.2.00.1010010142470.7033@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-873446607-1285911924=:7033"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-873446607-1285911924=:7033
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

A suspend regression fixed by Rafael.
A long standing PCIe suspend/wakeup bug fixed.
Incremental progress on Windows bug-compatibility
Incremental progress on APEI, as it is now being tested on multiple platforms.
A couple of build warning fixes and fluffy ones to get out of the way.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.36/acpi-release-20100702-2.6.36-rc6.diff.gz

 arch/x86/kernel/acpi/cstate.c    |    2 +-
 drivers/acpi/Kconfig             |    2 +-
 drivers/acpi/acpi_pad.c          |   34 ++++++++++++++++++----------------
 drivers/acpi/acpica/aclocal.h    |    1 +
 drivers/acpi/acpica/exutils.c    |    2 +-
 drivers/acpi/acpica/rsutils.c    |    2 +-
 drivers/acpi/apei/Kconfig        |    2 +-
 drivers/acpi/apei/apei-base.c    |   21 ++++++++++++++++-----
 drivers/acpi/apei/einj.c         |    4 +++-
 drivers/acpi/apei/erst-dbg.c     |   18 +++++++++++-------
 drivers/acpi/apei/erst.c         |   29 ++++++++++++++++++++++++-----
 drivers/acpi/apei/ghes.c         |    2 +-
 drivers/acpi/apei/hest.c         |   11 +++++++----
 drivers/acpi/atomicio.c          |    2 +-
 drivers/acpi/battery.c           |    1 -
 drivers/acpi/blacklist.c         |   18 ++++++++++++++++++
 drivers/acpi/bus.c               |   18 +++++-------------
 drivers/acpi/fan.c               |    2 ++
 drivers/acpi/processor_core.c    |    6 ------
 drivers/acpi/processor_perflib.c |    4 ++--
 drivers/acpi/sleep.c             |   22 ++++++++++++++++++++++
 drivers/acpi/sysfs.c             |   20 ++++++++++++++------
 drivers/acpi/video_detect.c      |    4 ++--
 include/acpi/acpixf.h            |    2 +-
 24 files changed, 153 insertions(+), 76 deletions(-)

through these commits:

Andrea Gelmini (1):
      ACPI: Kconfig: fix typo.

Colin Ian King (1):
      ACPI: enable repeated PCIEXP wakeup by clearing PCIEXP_WAKE_STS on resume

Huang Ying (3):
      ACPI, APEI, Fix APEI related table size checking
      ACPI, APEI, Fix error path for memory allocation
      ACPI, APEI, Fix ERST MOVE_DATA instruction implementation

Jin Dongming (2):
      ACPI, APEI, Fix acpi_pre_map() return value
      ACPI, APEI, HEST Fix the unsuitable usage of platform_data

Len Brown (5):
      ACPI: delete ZEPTO idle=nomwait DMI quirk
      ACPI: expand Vista blacklist to include SP1 and SP2
      ACPI: EC: add Vista incompatibility DMI entry for Toshiba Satellite L355
      ACPI: acpi_pad: simplify code to avoid false gcc build warning
      ACPI: invoke DSDT corruption workaround on all Toshiba Satellite

Lucas De Marchi (1):
      ACPI: Fix typos

Luis Henriques (1):
      ACPI: fan: Fix more unbalanced code block

Matthew Garrett (1):
      ACPI: Don't report current_now if battery reports in mWh

Namhyung Kim (1):
      ACPI: add missing __percpu markup in arch/x86/kernel/acpi/cstate.c

Rafael J. Wysocki (1):
      PM / ACPI: Blacklist systems known to require acpi_sleep=nonvs

Zhang Rui (3):
      ACPI: fix build warnings resulting from merge window conflict
      ACPI video: fix a poor warning message
      ACPI: Disable Windows Vista compatibility for Toshiba P305D

with this log:

commit fdb8c58a1671beb51949412e053926acd5500b5f
Merge: 23f124c b137b99 64a3230 337279c 100cf87 5399864 573b638 0bbba38
Author: Len Brown <len.brown@intel.com>
Date:   Wed Sep 29 15:18:28 2010 -0400

    Merge branches 'apei', 'battery-mwh-fix', 'bugzilla-10807', 'bugzilla-14736', 'bugzilla-14679', 'bugzilla-16396', 'launchpad-613381' and 'misc' into release

commit 100cf87788c0e9104f6fb1b0ff5f72f73fbbbea3
Author: Len Brown <len.brown@intel.com>
Date:   Tue Sep 28 22:57:02 2010 -0400

    ACPI: invoke DSDT corruption workaround on all Toshiba Satellite
    
    Our list of Toshiba Satellite models that require this workaround
    is growing -- so invoke the workaround for the entire product line.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=14679
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0bbba38a61283a55f2061ab3e0910c572d19f462
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Sep 29 19:53:55 2010 +0800

    ACPI, APEI, Fix ERST MOVE_DATA instruction implementation
    
    The src_base and dst_base fields in apei_exec_context are physical
    address, so they should be ioremaped before being used in ERST
    MOVE_DATA instruction.
    
    Reported-by: Javier Martinez Canillas <martinez.javier@gmail.com>
    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0c827eebfcd5caad24a50bc514ef15476b086e47
Author: Luis Henriques <luis.henrix@gmail.com>
Date:   Wed Jul 7 19:30:15 2010 +0100

    ACPI: fan: Fix more unbalanced code block
    
    commit 934231de706d2579fae14f5857fcd8de991009ff fixes an unbalanced
    CONFIG_ACPI_PROCFS code block during module initialisation.  This
    patch fixes similar issue but for the module exit.
    
    Signed-off-by: Luis Henriques <luis.henrix@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c9ad8e062e4c733b36fc10ebc201bedde1a4da80
Author: Len Brown <len.brown@intel.com>
Date:   Tue Sep 28 16:50:50 2010 -0400

    ACPI: acpi_pad: simplify code to avoid false gcc build warning
    
    acpi_pad.c:432: warning: ¡num_cpus¢ may be used uninitialized in this function
    
    gcc 4.4.4 was unable to notice that num_cpus is always set.
    Re-arrange the code to un-confuse gcc, and also make
    it easier for humans to read....
    
    Signed-off-by: Len Brown <len.browns@intel.com>

commit 23f124ca3dda98496b7ccf897cfd66264a212b6c
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Sep 29 19:53:54 2010 +0800

    ACPI, APEI, Fix error path for memory allocation
    
    In ERST debug/test support patch, a dynamic allocated buffer is
    used. The may-failed memory allocation should be tried firstly before
    free the previous buffer.
    
    APEI resource management memory allocation related error path is fixed
    too.
    
    v2:
    
    - Fix error messages for APEI resources management
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1dd6b20e368765223c31569d364219785b24700b
Author: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Date:   Wed Sep 29 19:53:53 2010 +0800

    ACPI, APEI, HEST Fix the unsuitable usage of platform_data
    
    platform_data in hest_parse_ghes() is used for saving the address of entry
    information of erst_tab. When the device is failed to be added, platform_data
    will be freed by platform_device_put(). But the value saved in platform_data
    should not be freed here. If it is done, it will make system panic.
    
    So I think platform_data should save the address of allocated memory
    which saves entry information of erst_tab.
    
    This patch fixed it and I confirmed it on x86_64 next-tree.
    
    v2:
        Transport the pointer of hest_hdr to platform_data using
        platform_device_add_data()
    
    Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bad97c37db9c1ee36de8ac58f9f73931d15a2e94
Author: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Date:   Wed Sep 29 19:53:52 2010 +0800

    ACPI, APEI, Fix acpi_pre_map() return value
    
    After we ioremap() a new region, we call __acpi_try_ioremap() to
    see whether another thread has already mapped the same region.
    This check clobbers "vaddr",  so compute the return value of
    acpi_pre_map() using the ioremap() result "map->vaddr" instead.
    
    v2:
        Modified the unsuitable description of patch.
    
    v3:
        Removed unlikely() check and made description simpler.
    
    Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3a78f965328482eee542217de79036c2a8791de8
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Sep 29 19:53:51 2010 +0800

    ACPI, APEI, Fix APEI related table size checking
    
    On Huang Ying's machine:
    
    erst_tab->header_length == sizeof(struct acpi_table_einj)
    
    but Yinghai reported that on his machine,
    
    erst_tab->header_length == sizeof(struct acpi_table_einj) -
    sizeof(struct acpi_table_header)
    
    To make erst table size checking code works on all systems, both
    testing are treated as PASS.
    
    Same situation applies to einj_tab->header_length, so corresponding
    table size checking is changed in similar way too.
    
    v2:
    
    - Treat both table size as valid
    
    Originally-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 337279ce3aa85d81d34c0f837d1c204df105103b
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Sep 28 22:48:55 2010 -0400

    ACPI: Disable Windows Vista compatibility for Toshiba P305D
    
    Disable the Windows Vista (SP1) compatibility for Toshiba P305D.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14736
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 25cb1bfdd8256cd1c614947e1696e42176ac22ec
Author: Andrea Gelmini <andrea.gelmini@gelma.net>
Date:   Wed Aug 18 15:22:10 2010 +0200

    ACPI: Kconfig: fix typo.
    
    "power of" -> "power off"
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bd126b23a2f30c3c7d268db2b96866923eb732a5
Author: Namhyung Kim <namhyung@gmail.com>
Date:   Sun Aug 8 02:17:29 2010 +0900

    ACPI: add missing __percpu markup in arch/x86/kernel/acpi/cstate.c
    
    cpu_cstate_entry is a percpu pointer
    but was missing __percpu markup.
    
    Signed-off-by: Namhyung Kim <namhyung@gmail.com>
    Acked-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 58f87ed0d45141a90167f34c0959d607160a26df
Author: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date:   Tue Sep 7 12:49:45 2010 -0400

    ACPI: Fix typos
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e9f74c489c9d4209946c04f29e7a724cb5537206
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Sep 3 10:08:50 2010 +0800

    ACPI video: fix a poor warning message
    
    Fix a vague warning message.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=16599
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ec652b351f48ed4cd6796181fbb41759ff88cc0a
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Aug 30 14:08:02 2010 +0800

    ACPI: fix build warnings resulting from merge window conflict
    
    drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type
    include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, struct kernel_param *)' but argument is of type 'int (*)(const char *, const struct kernel_param *)'
    
    Introduced by commit 1c8fce27e275fd7c6b75bc6455745f02d3903ee6 ("ACPI:
    introduce drivers/acpi/sysfs.c") interacting with commit
    9bbb9e5a33109b2832e2e63dcc7a132924ab374b ("param: use ops in struct
    kernel_param, rather than get and set fns directly").
    
    Use module_param_cb instead of the obsoleted module_param_call to fix a build warning.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7a1d602f5fc35d14907b7da98d5627acb69589d1
Author: Len Brown <len.brown@intel.com>
Date:   Tue Sep 28 17:51:51 2010 -0400

    ACPI: EC: add Vista incompatibility DMI entry for Toshiba Satellite L355
    
    https://bugzilla.kernel.org/show_bug.cgi?id=12641
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bbb7030fbb6469c46974c4736a5f90d12102f299
Author: Len Brown <len.brown@intel.com>
Date:   Tue Sep 28 17:48:49 2010 -0400

    ACPI: expand Vista blacklist to include SP1 and SP2
    
    When we claim incompatibility with Vista,
    include both Vista SP1 and SP2.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=12641
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 64a32307b710c100beb101e9c78f8022f0e8ba61
Author: Len Brown <len.brown@intel.com>
Date:   Tue Sep 28 17:20:20 2010 -0400

    ACPI: delete ZEPTO idle=nomwait DMI quirk
    
    per comments in the bug report, this entry
    seems to hurt at much as it helps.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=10807
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 573b638158029898caf9470c8214b7ddd29751e3
Author: Colin Ian King <colin.king@canonical.com>
Date:   Mon Aug 2 15:14:43 2010 +0000

    ACPI: enable repeated PCIEXP wakeup by clearing PCIEXP_WAKE_STS on resume
    
    Section 4.7.3.1.1 (PM1 Status Registers) of version 4.0 of
    the ACPI spec concerning PCIEXP_WAKE_STS points out in
    in the final note field in table 4-11 that if this bit is
    set to 1 and the system is put into a sleeping state then
    the system will not automatically wake.
    
    This bit gets set by hardware to indicate that the system
    woke up due to a PCI Express wakeup event, so clear it during
    acpi_hw_clear_acpi_status() calls to enable subsequent
    resumes to work.
    
    BugLink: http://bugs.launchpad.net/bugs/613381
    
    Signed-off-by: Colin Ian King <colin.king@canonical.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 539986482b0db07b7164ab086d167ab99b4d3061
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Sep 24 16:46:14 2010 -0400

    PM / ACPI: Blacklist systems known to require acpi_sleep=nonvs
    
    Commit 2a6b69765ad794389f2fc3e14a0afa1a995221c2 (ACPI: Store NVS
    state even when entering suspend to RAM) changed the ACPI suspend
    to RAM code so that the NVS memory area is always unconditionally
    saved during suspend and restored during resume, since some systems
    evidently need that for the suspend-resume to work on them.  However,
    it turned out that this change broke suspend-resume on a few systems,
    so commit 72ad5d77fb981963edae15eee8196c80238f5ed0 (ACPI / Sleep:
    Allow the NVS saving to be skipped during suspend to RAM) introduced
    the acpi_sleep=nonvs command line switch to allow their users to
    work around this issue.  To keep track of the systems that require
    this workaround and to make the life of their users slightly easier
    blacklist them in acpisleep_dmi_table[].
    
    https://bugzilla.kernel.org/show_bug.cgi?id=16396
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b137b9942a07843c64a934cfdb7d43155e507e13
Author: Matthew Garrett <mjg@redhat.com>
Date:   Mon Aug 23 20:25:32 2010 +0000

    ACPI: Don't report current_now if battery reports in mWh
    
    ACPI batteries can report in units of either current or energy. Right
    now we expose the current_now file even if the battery is reporting
    energy units, resulting in a file that should contain mA instead
    containing mW. Don't expose this value unless the battery is reporting
    current.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Cc: Arjan van de Ven <arjan@linux.intel.com>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
--8323328-873446607-1285911924=:7033--
