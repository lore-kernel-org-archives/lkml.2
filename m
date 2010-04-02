Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0DBEiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 00:38:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47352 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab0DBEij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 00:38:39 -0400
Date: Fri, 2 Apr 2010 10:08:32 +0530
From: Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
To: ltp-announce@lists.sourceforge.net
Cc: ltp-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       ltp-results@lists.sourceforge.net
Subject: [ANNOUNCEMENT][LTP] LTP for March 2010 has been released
Message-ID: <20100402043832.GA4224@linux.vnet.ibm.com>
Mail-Followup-To: ltp-announce@lists.sourceforge.net,
	ltp-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	ltp-results@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,


Some final last-minute small fixes, but LTP (Linux Test Project )testsuit has
been released for the month of March 2010. This tree is clone of master branch
and tagged version of 0.3.

You can download from :
https://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20100331/ltp-full-20100331.tgz/download

Or you can directly clone git version as:
git clone git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev.git ltp

After merging to GIT tree we have worked mostly on build stability of LTP for
different architecture. And for that very close reviewed patches has been merged
this month's LTP.

You can find complete ChangeLog with $LTPROOT/ChangeLog as well as with this
mail footer for quick reference.

The latest version of the test-suite contains 3000+ tests for the Linux
OS and can be found at:
http://ltp.sourceforge.net/,
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,

========================
MARCH 2010 Highlights:
======================== 
    * Again enabled many files to be installed in $LTPROOT/testcases/bin as it has
been missed due to makefile infra changes by Rishikesh
    * Abnormal behaviour of
open_posix_testsuite/conformance/interfaces/sem_post/8-1.c has been fixed now by
Naresh Kamboju.
    * CPU hotplug testcase fix by Garret
    * Network namespace testcase issue by sachin/Garret
    * Added post recieve mail for GIT by Rishikesh
    * Rewritten filecap testcases based upon new makefile infra changes by
Serge.
    * Possible buffer overflow fixes for sem_getvalue testcases of open_posix
tetssuits by Garret.
    * New device driver testcase for RTC has been added by Silesh from L&T
Infotech.
    * Fixes for many bashism and GNU compilation source by Garret.
    * Memory controller tetscases fix by Yuki Yao.
    * Looked for many testcase returned value and did fixes for those by Rishi

==============================
Note(s) from the Maintainer:
==============================

This month i have also attached a new file called "result" with the source
code where result have been put after compile, build & run on different for older 
kernel as well as newer kernel distros. Please refer this file for your references 
and let us know if you find some differences. The major indication for adding those
files are to know about the known failures and if someone willing to fix those
issue they are always welcome.

I am seeing build failure reporting mail has been reduced and there could be one
or two build problem with the infra exists currently. So seems like 1st phase of
my target is very close. Now we should start thinking of coverage of tetscases
which does not run by default.


NOTE: == If you want to know more about changes read further ==

Here is the short changelog for your reference through which you can know which
file & directory has been touched. Please test for any regression of testcases
on your environment and report the failure to ltp-list@ .

 .gitignore                                         |    3 +
 ChangeLog                                          | 2367 ++++++++++++++++++++
 IDcheck.sh                                         |   35 +-
 TODO                                               |   31 +-
 configure.ac                                       |    1 +
 doc/MaintNotes                                     |  107 +
 m4/ltp-cap.m4                                      |   17 +-
 m4/ltp-prctl.m4                                    |   31 +
 result                                             |   96 +
 runalltests.sh                                     |  271 ++--
 runltp                                             |    4 +-
 runltplite.sh                                      |    2 +-
 runtest/controllers                                |    1 +
 runtest/cpuhotplug                                 |    2 +-
 runtest/io                                         |    2 +-
 scripts/git2changelog.sh                           |   28 +
 testcases/commands/unzip/unzip_tests.sh            |    4 +-
 testcases/kernel/Makefile                          |   11 +-
 testcases/kernel/containers/Makefile               |    2 +
 testcases/kernel/containers/check_for_unshare.c    |   55 +
 testcases/kernel/containers/netns/Makefile         |    2 +-
 testcases/kernel/containers/netns/common.c         |    4 +-
 testcases/kernel/containers/netns/par_chld_ipv6.c  |    6 +-
 testcases/kernel/containers/netns/sysfsview.c      |    2 +-
 .../kernel/containers/netns/two_children_ns.c      |    8 +-
 testcases/kernel/controllers/cgroup_fj/Makefile    |    2 +-
 ...{cgroup_fj_testcases => cgroup_fj_testcases.sh} |    0
 .../controllers/cgroup_fj/run_cgroup_test_fj.sh    |    2 +-
 .../kernel/controllers/freezer/libcgroup_freezer   |   73 +-
 .../kernel/controllers/freezer/run_freezer.sh      |    3 +-
 testcases/kernel/controllers/memcg/README          |   10 +
 .../kernel/controllers/memcg/control/Makefile      |   33 +
 .../kernel/controllers/memcg/control/mem_process.c |  141 ++
 .../memcg/control/memcg_control_test.sh            |  157 ++
 .../memcg/functional/memcg_function_test.sh        |    3 +-
 .../memcg/regression/memcg_regression_test.sh      |    3 +-
 .../controllers/memcg/stress/memcg_stress_test.sh  |    3 +-
 testcases/kernel/device-drivers/rtc/Makefile       |   29 +
 testcases/kernel/device-drivers/rtc/README         |   29 +
 testcases/kernel/device-drivers/rtc/rtc-test.c     |  218 ++
 testcases/kernel/hotplug/cpu_hotplug/Makefile      |   31 +
 .../hotplug/cpu_hotplug/functional/hotplug01.sh    |  233 ++-
 .../hotplug/cpu_hotplug/functional/hotplug02.sh    |   80 +-
 .../hotplug/cpu_hotplug/functional/hotplug03.sh    |  170 +-
 .../hotplug/cpu_hotplug/functional/hotplug04.sh    |   98 +-
 .../cpu_hotplug/functional/hotplug06.sar.sh        |  125 +-
 .../hotplug/cpu_hotplug/functional/hotplug06.sh    |   22 +-
 .../cpu_hotplug/functional/hotplug06.top.sh        |   93 +-
 .../hotplug/cpu_hotplug/functional/hotplug07.sh    |  108 +-
 .../kernel/hotplug/cpu_hotplug/include/hotplug.fns |    4 +-
 .../hotplug/cpu_hotplug/include/testsuite.fns      |    2 +-
 testcases/kernel/hotplug/cpu_hotplug/runtests.sh   |    7 +-
 .../hotplug/cpu_hotplug/tools/do_disk_write_loop   |   16 +-
 .../hotplug/cpu_hotplug/tools/do_kcompile_loop     |   14 +-
 .../kernel/hotplug/cpu_hotplug/tools/do_spin_loop  |    2 +-
 testcases/kernel/io/aio/aio02/runfstests.sh        |   50 +-
 testcases/kernel/io/stress_cd/stress_cd.c          |    2 +-
 testcases/kernel/security/Makefile                 |    3 +
 testcases/kernel/security/cap_bound/cap_bounds_r.c |   44 +-
 .../kernel/security/cap_bound/cap_bounds_rw.c      |   58 +-
 .../security/cap_bound/cap_bset_inh_bounds.c       |   61 +-
 testcases/kernel/security/cap_bound/check_pe.c     |   20 +-
 testcases/kernel/security/cap_bound/dummy.c        |   26 +-
 .../kernel/security/cap_bound/exec_with_inh.c      |   34 +-
 .../kernel/security/cap_bound/exec_without_inh.c   |   35 +-
 testcases/kernel/security/filecaps/Makefile        |    2 +-
 testcases/kernel/security/filecaps/c.c             |   45 +
 .../kernel/security/filecaps/check_simple_capset.c |   11 +-
 .../kernel/security/filecaps/checkforfilecaps.sh   |   40 -
 .../kernel/security/filecaps/checkforlibcap.sh     |   66 -
 testcases/kernel/security/filecaps/filecapstest.sh |   19 +-
 testcases/kernel/security/filecaps/inh_capped.c    |   12 +-
 testcases/kernel/security/filecaps/print_caps.c    |    2 +-
 .../kernel/security/filecaps/verify_caps_exec.c    |   21 +-
 testcases/kernel/syscalls/libevent/Makefile.in     |    3 +-
 testcases/kernel/syscalls/libevent/buffer.c        |    5 +
 testcases/kernel/syscalls/link/link06.c            |   18 +-
 testcases/kernel/syscalls/link/link07.c            |   19 +-
 testcases/network/multicast/mc_cmds/mc_cmds        |    2 +-
 testcases/network/tcp_cmds/echo/Makefile           |    2 +-
 .../conformance/interfaces/sem_getvalue/1-1.c      |   21 +-
 .../conformance/interfaces/sem_getvalue/2-1.c      |   19 +-
 .../conformance/interfaces/sem_getvalue/2-2.c      |   59 +-
 .../conformance/interfaces/sem_getvalue/4-1.c      |   18 +-
 .../conformance/interfaces/sem_getvalue/5-1.c      |   23 +-
 .../conformance/interfaces/sem_post/8-1.c          |    4 +-
 .../conformance/interfaces/sigset/8-1.c            |   14 +-
 testscripts/Makefile                               |    2 +-
 88 files changed, 4376 insertions(+), 1187 deletions(-)
 create mode 100644 doc/MaintNotes
 create mode 100644 m4/ltp-prctl.m4
 create mode 100644 result
 create mode 100755 scripts/git2changelog.sh
 create mode 100644 testcases/kernel/containers/check_for_unshare.c
 rename testcases/kernel/controllers/cgroup_fj/{cgroup_fj_testcases =>
cgroup_fj_testcases.sh} (100%)
 create mode 100644 testcases/kernel/controllers/memcg/control/Makefile
 create mode 100644 testcases/kernel/controllers/memcg/control/mem_process.c
 create mode 100644
testcases/kernel/controllers/memcg/control/memcg_control_test.sh
 create mode 100644 testcases/kernel/device-drivers/rtc/Makefile
 create mode 100644 testcases/kernel/device-drivers/rtc/README
 create mode 100644 testcases/kernel/device-drivers/rtc/rtc-test.c
 create mode 100644 testcases/kernel/hotplug/cpu_hotplug/Makefile
 create mode 100644 testcases/kernel/security/filecaps/c.c
 delete mode 100755 testcases/kernel/security/filecaps/checkforfilecaps.sh
 delete mode 100755 testcases/kernel/security/filecaps/checkforlibcap.sh


Here is the summary of commit which can be reffered for detail changes and also
i would recommend you to subscribe for ltp-commits@ list for knowing what
changes are being done in the git repo.

Garrett Cooper (41):
      Do some minor spring cleaning on the script to improve whitespace, quote a few strings passed to echo, etc.
      Inspite of memcg kernel support being available, memcg_[functional|regression     |stress] test script fails to execute with message
      Note caveat about cpu_hotplug test needing to be run from the source tree directory.
      Grab ChangeLog script from http://github.com/cryos/avogadro/raw/master/scripts/gitlog2changelog.py .
      Add a simpler git ChangeLog script.
      Remove overly complicated git log ChangeLog script.
      Update ChangeLog.
      Remove unnecessary variable set; all MAKE_TARGETS get added to INSTALL_TARGETS.
      Fix order by properly alphabetizing it again.
      Make alphabetical ordering more apparent by adding a comment.
      Make sure this can run wherever -- update the install path in the runtest file for cpu_hotplug...
      Install in testcases/bin/cpu_hotplug to avoid collision with installed filenames.
      Remove bashisms. Clean up.
      All for parameterized $TMP.
      POSIXify.
      Fix indentation.
      1. Add default kernel source dir as /usr/src/linux.     2. Clean up indentation.
      Update TODO with some items that need to be rewritten.
      1. POSIXify     2. Clean up test.     3. Make more path agnostic.
      1. POSIXify.     2. Convert over to tst_resm(1), like hotplug01.sh
      1. POSIXify.     2. Clean up whitespace.     3. Make more relative-path agnostic.
      1. POSIXify.     2. Cleanup space.
      ... Finish off cleanup:
      Clean up some logic.
      Remove ./ suffix in usage message and examples.
      Well obviously that test didn't trigger anything with the precommit hook -_-...
      Hi All,
      Hi All,
      Fix style in runfstests.sh
      Remove unused variable $str based on closer inspection via git commit history.
      Correct setuid() logic for "nobody" uid.
      Fix nobody group check and change default uid/gid for nobody.
      Replace pushd // popd with cd calls.
      Fix install for cgroup_fj_testcases.
      Fix _GNU_SOURCES macro requirement error.
      Replace pushd / popd with proper cd logic as busybox doesn't have pushd / popd.
      Use $TMP (which defaults to /tmp) rather than /tmp as $TMP can be parameterized via runltp, et all.
      Clean up comment to note the actual problem. It was confusing before.
      Hi,
      Update TODO with note about needing to replace pushd and popd logic in a few tests.
      Merge branch 'master' of ssh://yaberauneya@ltp.git.sourceforge.net/gitroot/ltp/ltp-dev




Rishikesh K Rajak (63):
      New testcase added by Naufal.
      Changes since 6thFeb to 28Feb 2010.
      Merge ssh://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
      Fixed the typo in changelog
      Inspite of memcg kernel support being available, memcg_[functional|regression     |stress] test script fails to execute with message
      Merge branches 'master' and 'next' into next
      I have observed that the 'createfile.c' in testcases/network/tcp_cmds/echo directory is not getting compiled and installed during the LTP build. The "echo_createfile.patch" makes the necessary changes in the Makefile.
      I have found abnormal behavior of sem_post/8-1.c test case under posix. This test case passes in some times and failed in many times :-(
      Revertin the commit d40fd32af0d0ad7713b0cf6cd23daf1ee639d479 for now.
      Merge branch 'next' of ssh://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
      (cpu_hotplugin_makefile.patch) to execute cpuhotplugin test.     I have observed that the 'hotplug' directory is not included in "testcases/kernel/Makefile". I have also     created a Makefile in 'hotplug/cpu_hotplug' directory.
      Merge branches 'master' and 'next' into next
      libcgroup_freezer , pushd/popd removal.
      Merge branches 'master' and 'maint' into maint
      Merge branches 'master' and 'next' into next
      Commenting "make all" in run_freezer.sh file as it is stopping to run the freezer testcase
      Quick fix for build failure with 8th Mar master tree.
      Adding check_for_unshare.c file and linking the porper lib.
      Merge branches 'next' and 'master'
      Testing for post-receive-email
      Instead of LIBS, it should be LDLIBS in container/Makefile
      Fix make filed,, reported by Shi Weihua <shiwh@cn.fujitsu.com>     It was my bad :( .
      Merge branches 'master' and 'next' into next
      Merge branches 'master' and 'maint' into maint
      Merge branches 'master' and 'pu' into pu
      To run filecap test, checkforlibcap.sh file is required to be there in /opt/ltp/testcases/bin
      Merge branches 'next' and 'master'
      Merge branches 'master' and 'next' into next
      Merge branches 'master' and 'maint' into maint
      Merge branches 'master' and 'pu' into pu
      Adding a wordy informationi, 2005 here represents as year not version of kernels.
      Merge branches 'pu' and 'maint' into maint
      This commit contains Linux RTC device driver test cases.     Currently RTC read test, Alarm test and Update interrupts     tests are supported.
      Merge branch 'next' of ssh://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev into next
      Attached patch fixes possible buffer oveflow in sem_getvalue tests (the buffer     overflow happens when getpid() returns number that couldn't fit into buffer)     and also cleans coding style.
      Merge branches 'next' and 'master'
      Here's an attempt at fixing up and simplifying the autoconf for detecting libcap and prctl support.  After this, make autotools     etc work fine on my f12 system, and runltp -f cap_bounds passes.     the filecaps tests refuse to run claiming to be unable to find     setcap, which I'll worry about next week.
      As pointed out by Cheng Shun Xia one of open posix conformace tests is testing     return value from sigset(SIGCHLD, SIG_HOLD) and expect this value to be     SIG_HOLD, however this is true only if SIGCHLD is already blocked so we must     ensure that. Patch is attached.
      Remaining patch for new file addition for commit:6e3dd83d9f575d98d76b8b3f642ad6e8793dbdfc
      Revert "I have found abnormal behavior of sem_post/8-1.c test case under posix."
      while running i found some unwanted messages and fixed those. You can Ack if it is correct fix.
      I have tested these on MIPS architecture and  reproduced infinite waiting situation after applying this patch. (with strace no issue     found ex: #strace ./8-1.test)     As you said there may be issues in MIPS-POSIX library. it may take     some time to fix these issues or may not be fixed.     However, I’ll discuss this issue with MIPS folks in different thread.
      Merge branches 'maint' and 'master'
      These warning will appear when HAVE_LIBCAP is not defined.
      Fix the proper return for testcase.
      Merge commit '391e757d43b3ac33a4a435e319ee77b1daa6da76'
      cgroup_fj_release_agent is not getting installed as it does not end with *.sh.
      Merge branches 'maint' and 'master'
      Merge branches 'maint' and 'next' into next
      Merge branches 'maint' and 'pu' into pu
      ./runltp -f fs_readonly fails with:
      Merge branches 'pu' and 'next' into next
      Merge branches 'next' and 'master'
      Updated the documentation and return sensible message if testcase failed.
      Merge branches 'master' and 'next' into next
      Changelog from 2010-03-01 to 2010-03-31
      Merge branches 'next' and 'master'
      Added Maintainer Notes new file
      NETNS tests from containers fails to execute with following message
      Modified nets/Makefile for appending one file which needs in /opt/ltp/tetscases/bin directory while install.
      Merge branches 'next' and 'master'
      Added a new file called result where maintainer need to provide the result on which he has run before releasing the tar ball for month end release.
      Merge branches 'next' and 'master'



-- 
Thanks & Regards
Rishi
LTP Maintainer
IBM, LTC, Bangalore
Please join IRC #ltp @ irc.freenode.net
