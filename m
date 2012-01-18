Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2ARHVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 02:21:25 -0500
Received: from mail-qw0-f66.google.com ([209.85.216.66]:46075 "EHLO
	mail-qw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2ARHVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 02:21:22 -0500
X-Greylist: delayed 973 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jan 2012 02:21:22 EST
Message-ID: <4F166F21.3050501@kernel.org>
Date: Wed, 18 Jan 2012 02:05:05 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI & Power Management patches for Linux 3.3-merge
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these ACPI & Power Management patches.

This includes initial support for the recently published ACPI 5.0 spec.
In particular, support for the "hardware-reduced" bit that eliminates
the dependency on legacy hardware.
APEI has patches resulting from testing on real hardware.
Plus other random fixes.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to 79ba0db69c5887f1ad4ed51d58894e7e889084b0:

  Merge branches 'einj', 'intel_idle', 'misc', 'srat' and 'turbostat-ivb' into release (2012-01-18 01:15:54 -0500)

----------------------------------------------------------------

Bjorn Helgaas (1):
      ACPI, APEI, Print resource errors in conventional format

Bob Moore (16):
      ACPICA: Update for GCC 4
      ACPICA: Add error msg for unsupported I/O requests (not 8/16/32 bit length)
      ACPICA: Add error msg for Index/Bank field registers out-of-range
      ACPICA: Do not abort table load on invalid space ID
      ACPI 5.0: Basic support for FADT version 5
      ACPI 5.0: Implement hardware-reduced option
      ACPI 5.0: Add new/changed tables to headers
      ACPI 5.0: Implement Connection() and AccessAs() changes
      ACPI 5.0: Support for GeneralPurposeIo and GenericSerialBus operation region
      ACPI 5.0: New interface, acpi_get_event_resources
      ACPI 5.0: New interface, acpi_buffer_to_resource
      ACPI 5.0: Add new predefined names
      ACPICA: Update to version 20111123
      ACPICA: Update for larger ACPI 5 FADT size
      ACPICA: Update all copyrights to 2012
      ACPICA: Update to version 20120111

David Howells (1):
      intel_idle: Fix a cast to pointer from integer of different size warning in intel_idle

Huang Ying (9):
      ACPI, Add 64bit read/write support to atomicio on i386
      ACPI, APEI, GHES: Add PCIe AER recovery support
      ACPI, APEI, Remove table not found message
      ACPI, APEI, GHES, Distinguish interleaved error report in kernel log
      ACPI, APEI, Printk queued error record before panic
      ACPI, Add RAM mapping support to ACPI atomic IO support
      ACPI, APEI, EINJ, Fix resource conflict on some machine
      ACPI, Record ACPI NVS regions
      ACPI, APEI, Resolve false conflict between ACPI NVS and APEI

Kurt Garloff (3):
      ACPI: Store SRAT table revision
      ACPI, x86: Use SRAT table rev to use 8bit or 32bit PXM fields (x86/x86-64)
      ACPI, ia64: Use SRAT table rev to use 8bit or 16/32bit PXM fields (ia64)

Len Brown (5):
      tools turbostat: recognize and run properly on IVB
      Merge branch 'acpica-validate-address-regression' into next
      Merge branch 'apei' into release
      Merge branch 'atomicio-remove' into release
      Merge branches 'einj', 'intel_idle', 'misc', 'srat' and 'turbostat-ivb' into release

Lin Ming (7):
      ACPICA: Put back the call to acpi_os_validate_address
      ACPICA: Fix to allow region arguments to reference other scopes
      ACPI 5.0: New interfaces to allow driver access to AML mutex objects
      ACPI 5.0: Support for all new resource descriptors
      ACPICA: Clean up Makefile
      ACPICA: Add support for region address conflict checking
      ACPI: processor: fix acpi_get_cpuid for UP processor

Masanari Iida (1):
      ACPI: kernel-parameters.txt : Add intel_idle.max_cstate

Myron Stowe (3):
      ACPI: Fix possible alignment issues with GAS 'address' references
      ACPI: Export interfaces for ioremapping/iounmapping ACPI registers
      ACPI APEI: Convert atomicio routines

Shaohua Li (1):
      intel_idle: fix API misuse

Thomas Renninger (5):
      ACPI processor: Fix error path, also remove sysdev link
      intel idle: Make idle driver more robust
      ACPI processor: Remove unneeded cpuidle_unregister_driver call
      ACPI processor: Remove unneeded variable passed by acpi_processor_hotadd_init V2
      intel_idle: Split up and provide per CPU initialization func

Tony Luck (1):
      acpi/apei/einj: Add extensions to EINJ from rev 5.0 of acpi spec

Xiao, Hui (1):
      ACPI, APEI, EINJ, Refine the fix of resource conflict

Yanmin Zhang (1):
      intel_idle: remove redundant local_irq_disable() call

Zhang Rui (1):
      ACPI 5.0: Allow _AEI method in walk resources

 Documentation/acpi/apei/einj.txt      |   55 +++-
 Documentation/kernel-parameters.txt   |    5 +
 arch/ia64/kernel/acpi.c               |   10 +-
 arch/x86/kernel/e820.c                |    4 +-
 arch/x86/mm/srat.c                    |    4 +
 drivers/acpi/Makefile                 |    3 +-
 drivers/acpi/acpica/Makefile          |  158 ++++++++--
 drivers/acpi/acpica/accommon.h        |    2 +-
 drivers/acpi/acpica/acconfig.h        |    9 +-
 drivers/acpi/acpica/acdebug.h         |    2 +-
 drivers/acpi/acpica/acdispat.h        |    2 +-
 drivers/acpi/acpica/acevents.h        |    3 +-
 drivers/acpi/acpica/acglobal.h        |   17 +-
 drivers/acpi/acpica/achware.h         |    2 +-
 drivers/acpi/acpica/acinterp.h        |    4 +-
 drivers/acpi/acpica/aclocal.h         |   26 ++-
 drivers/acpi/acpica/acmacros.h        |    2 +-
 drivers/acpi/acpica/acnamesp.h        |    2 +-
 drivers/acpi/acpica/acobject.h        |    8 +-
 drivers/acpi/acpica/acopcode.h        |    6 +-
 drivers/acpi/acpica/acparser.h        |    2 +-
 drivers/acpi/acpica/acpredef.h        |   41 +++-
 drivers/acpi/acpica/acresrc.h         |  115 +++++---
 drivers/acpi/acpica/acstruct.h        |    2 +-
 drivers/acpi/acpica/actables.h        |    2 +-
 drivers/acpi/acpica/acutils.h         |   21 ++-
 drivers/acpi/acpica/amlcode.h         |   29 ++-
 drivers/acpi/acpica/amlresrc.h        |  138 ++++++++-
 drivers/acpi/acpica/dsargs.c          |   18 +-
 drivers/acpi/acpica/dscontrol.c       |    2 +-
 drivers/acpi/acpica/dsfield.c         |   83 ++++-
 drivers/acpi/acpica/dsinit.c          |    2 +-
 drivers/acpi/acpica/dsmethod.c        |    2 +-
 drivers/acpi/acpica/dsmthdat.c        |    2 +-
 drivers/acpi/acpica/dsobject.c        |    2 +-
 drivers/acpi/acpica/dsopcode.c        |    2 +-
 drivers/acpi/acpica/dsutils.c         |    2 +-
 drivers/acpi/acpica/dswexec.c         |    2 +-
 drivers/acpi/acpica/dswload.c         |    2 +-
 drivers/acpi/acpica/dswload2.c        |    2 +-
 drivers/acpi/acpica/dswscope.c        |    2 +-
 drivers/acpi/acpica/dswstate.c        |    2 +-
 drivers/acpi/acpica/evevent.c         |   14 +-
 drivers/acpi/acpica/evglock.c         |    8 +-
 drivers/acpi/acpica/evgpe.c           |    2 +-
 drivers/acpi/acpica/evgpeblk.c        |    2 +-
 drivers/acpi/acpica/evgpeinit.c       |    2 +-
 drivers/acpi/acpica/evgpeutil.c       |    2 +-
 drivers/acpi/acpica/evmisc.c          |    2 +-
 drivers/acpi/acpica/evregion.c        |   31 ++-
 drivers/acpi/acpica/evrgnini.c        |    2 +-
 drivers/acpi/acpica/evsci.c           |    2 +-
 drivers/acpi/acpica/evxface.c         |    2 +-
 drivers/acpi/acpica/evxfevnt.c        |    2 +-
 drivers/acpi/acpica/evxfgpe.c         |    2 +-
 drivers/acpi/acpica/evxfregn.c        |    2 +-
 drivers/acpi/acpica/exconfig.c        |    8 +-
 drivers/acpi/acpica/exconvrt.c        |    2 +-
 drivers/acpi/acpica/excreate.c        |   31 ++-
 drivers/acpi/acpica/exdebug.c         |    2 +-
 drivers/acpi/acpica/exdump.c          |    9 +-
 drivers/acpi/acpica/exfield.c         |   30 ++-
 drivers/acpi/acpica/exfldio.c         |   38 ++-
 drivers/acpi/acpica/exmisc.c          |    2 +-
 drivers/acpi/acpica/exmutex.c         |    2 +-
 drivers/acpi/acpica/exnames.c         |    2 +-
 drivers/acpi/acpica/exoparg1.c        |    2 +-
 drivers/acpi/acpica/exoparg2.c        |    2 +-
 drivers/acpi/acpica/exoparg3.c        |    2 +-
 drivers/acpi/acpica/exoparg6.c        |    2 +-
 drivers/acpi/acpica/exprep.c          |   27 ++-
 drivers/acpi/acpica/exregion.c        |    2 +-
 drivers/acpi/acpica/exresnte.c        |    2 +-
 drivers/acpi/acpica/exresolv.c        |    2 +-
 drivers/acpi/acpica/exresop.c         |    2 +-
 drivers/acpi/acpica/exstore.c         |    2 +-
 drivers/acpi/acpica/exstoren.c        |    2 +-
 drivers/acpi/acpica/exstorob.c        |    2 +-
 drivers/acpi/acpica/exsystem.c        |    2 +-
 drivers/acpi/acpica/exutils.c         |   27 ++-
 drivers/acpi/acpica/hwacpi.c          |    2 +-
 drivers/acpi/acpica/hwgpe.c           |    2 +-
 drivers/acpi/acpica/hwpci.c           |    2 +-
 drivers/acpi/acpica/hwregs.c          |    2 +-
 drivers/acpi/acpica/hwsleep.c         |    2 +-
 drivers/acpi/acpica/hwtimer.c         |    2 +-
 drivers/acpi/acpica/hwvalid.c         |    4 +-
 drivers/acpi/acpica/hwxface.c         |    2 +-
 drivers/acpi/acpica/nsaccess.c        |    2 +-
 drivers/acpi/acpica/nsalloc.c         |    2 +-
 drivers/acpi/acpica/nsdump.c          |    2 +-
 drivers/acpi/acpica/nsdumpdv.c        |    2 +-
 drivers/acpi/acpica/nseval.c          |    2 +-
 drivers/acpi/acpica/nsinit.c          |    2 +-
 drivers/acpi/acpica/nsload.c          |    2 +-
 drivers/acpi/acpica/nsnames.c         |    2 +-
 drivers/acpi/acpica/nsobject.c        |    2 +-
 drivers/acpi/acpica/nsparse.c         |    2 +-
 drivers/acpi/acpica/nspredef.c        |   31 ++-
 drivers/acpi/acpica/nsrepair.c        |    3 +-
 drivers/acpi/acpica/nsrepair2.c       |    7 +-
 drivers/acpi/acpica/nssearch.c        |    2 +-
 drivers/acpi/acpica/nsutils.c         |    2 +-
 drivers/acpi/acpica/nswalk.c          |    2 +-
 drivers/acpi/acpica/nsxfeval.c        |    2 +-
 drivers/acpi/acpica/nsxfname.c        |    2 +-
 drivers/acpi/acpica/nsxfobj.c         |    2 +-
 drivers/acpi/acpica/psargs.c          |  143 ++++++++-
 drivers/acpi/acpica/psloop.c          |    2 +-
 drivers/acpi/acpica/psopcode.c        |   15 +-
 drivers/acpi/acpica/psparse.c         |    2 +-
 drivers/acpi/acpica/psscope.c         |    2 +-
 drivers/acpi/acpica/pstree.c          |    8 +-
 drivers/acpi/acpica/psutils.c         |    2 +-
 drivers/acpi/acpica/pswalk.c          |    2 +-
 drivers/acpi/acpica/psxface.c         |    2 +-
 drivers/acpi/acpica/rsaddr.c          |    2 +-
 drivers/acpi/acpica/rscalc.c          |   89 +++++-
 drivers/acpi/acpica/rscreate.c        |   69 ++++-
 drivers/acpi/acpica/rsdump.c          |  196 +++++++++++-
 drivers/acpi/acpica/rsinfo.c          |   58 +++-
 drivers/acpi/acpica/rsio.c            |    2 +-
 drivers/acpi/acpica/rsirq.c           |   33 ++-
 drivers/acpi/acpica/rslist.c          |   77 ++++-
 drivers/acpi/acpica/rsmemory.c        |    2 +-
 drivers/acpi/acpica/rsmisc.c          |  269 ++++++++++++++++-
 drivers/acpi/acpica/rsserial.c        |  441 ++++++++++++++++++++++++++
 drivers/acpi/acpica/rsutils.c         |   56 ++++-
 drivers/acpi/acpica/rsxface.c         |   52 +++-
 drivers/acpi/acpica/tbfadt.c          |   41 ++-
 drivers/acpi/acpica/tbfind.c          |    2 +-
 drivers/acpi/acpica/tbinstal.c        |    2 +-
 drivers/acpi/acpica/tbutils.c         |    9 +-
 drivers/acpi/acpica/tbxface.c         |    2 +-
 drivers/acpi/acpica/tbxfroot.c        |    2 +-
 drivers/acpi/acpica/utaddress.c       |  294 ++++++++++++++++++
 drivers/acpi/acpica/utalloc.c         |    2 +-
 drivers/acpi/acpica/utcopy.c          |    2 +-
 drivers/acpi/acpica/utdebug.c         |    2 +-
 drivers/acpi/acpica/utdecode.c        |    6 +-
 drivers/acpi/acpica/utdelete.c        |   15 +-
 drivers/acpi/acpica/uteval.c          |    2 +-
 drivers/acpi/acpica/utglobal.c        |    8 +-
 drivers/acpi/acpica/utids.c           |    2 +-
 drivers/acpi/acpica/utinit.c          |    3 +-
 drivers/acpi/acpica/utlock.c          |    2 +-
 drivers/acpi/acpica/utmath.c          |    2 +-
 drivers/acpi/acpica/utmisc.c          |    2 +-
 drivers/acpi/acpica/utmutex.c         |   11 +-
 drivers/acpi/acpica/utobject.c        |    2 +-
 drivers/acpi/acpica/utosi.c           |    2 +-
 drivers/acpi/acpica/utresrc.c         |  278 +++++++++++++++--
 drivers/acpi/acpica/utstate.c         |    2 +-
 drivers/acpi/acpica/utxface.c         |   40 +++-
 drivers/acpi/acpica/utxferror.c       |    2 +-
 drivers/acpi/acpica/utxfmutex.c       |  187 +++++++++++
 drivers/acpi/apei/apei-base.c         |  150 +++++++++-
 drivers/acpi/apei/apei-internal.h     |    6 +
 drivers/acpi/apei/einj.c              |  290 +++++++++++++++---
 drivers/acpi/apei/erst.c              |    5 +-
 drivers/acpi/apei/ghes.c              |  102 +++++--
 drivers/acpi/apei/hest.c              |    5 +-
 drivers/acpi/atomicio.c               |   77 ++++-
 drivers/acpi/numa.c                   |    6 +
 drivers/acpi/nvs.c                    |   53 +++-
 drivers/acpi/osl.c                    |  242 +++------------
 drivers/acpi/processor_core.c         |   26 ++-
 drivers/acpi/processor_driver.c       |   20 +-
 drivers/idle/intel_idle.c             |   96 +++---
 include/acpi/acnames.h                |    1 +
 include/acpi/acpi_numa.h              |    1 +
 include/acpi/acpiosxf.h               |    7 -
 include/acpi/acpixf.h                 |   32 ++-
 include/acpi/acrestyp.h               |  207 ++++++++++++-
 include/acpi/actbl.h                  |   23 +-
 include/acpi/actbl1.h                 |   57 ++++-
 include/acpi/actbl3.h                 |  552 +++++++++++++++++++++++++++++++++
 include/acpi/actypes.h                |   12 +-
 include/linux/acpi.h                  |   20 +-
 include/linux/acpi_io.h               |    3 +
 include/linux/cpuidle.h               |    7 +
 tools/power/x86/turbostat/turbostat.c |    2 +
 182 files changed, 4824 insertions(+), 795 deletions(-)
 create mode 100644 drivers/acpi/acpica/rsserial.c
 create mode 100644 drivers/acpi/acpica/utaddress.c
 create mode 100644 drivers/acpi/acpica/utxfmutex.c
 create mode 100644 include/acpi/actbl3.h
