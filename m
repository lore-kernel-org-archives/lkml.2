Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab1EXQg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab1EXQg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:36:28 -0400
Message-ID: <4DDBDE8E.2090200@redhat.com>
Date: Tue, 24 May 2011 12:36:30 -0400
From: Stan Cox <scox@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: systemtap@sourceware.org, linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: systemtap release 1.5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The systemtap team announces release 1.5.

   The "--remote USER@HOST" functionality is now more robust, and can also fan
   out on multiple targets, I18N is now supported via GNU Gettext, the compile
   server and related tools are now re-implemented in C++,
   process("...").library("...") probes are now supported, build-id is checked
   for userspace applications,

= Where to get it

   http://sourceware.org/systemtap/ - our project page
   http://sourceware.org/systemtap/ftp/releases/systemtap-1.5.tar.gz
   http://koji.fedoraproject.org/koji/packageinfo?packageID=615
   git tag release-1.5 (commit a8a01c8a26 )

   There have been over 350 commits since the last release.
   There have been over 35 bugs/features fixed since the last release.

= How to build it

   See the README and NEWS files at
   http://sourceware.org/git/?p=systemtap.git;a=tree
   Further information at http://sourceware.org/systemtap/wiki/

= Systemtap frontend (stap) changes

- The command line option --version has been added.

- A new command line option, --use-server-on-error[=yes|no] is available
   for stap.  It instructs stap to retry compilation of a script using a
   compile server if it fails on the local host.  The default setting
   is 'no'.

- GNU Gettext has now been intergrated with systemtap.  Our translation
   page can be found at http://www.transifex.net/projects/p/systemtap/ .
   "make update-po" will generate the necessary files to use translated
   messages.  Please refer to the po/README file for more info and
   please consider contributing to this I18N effort!

- stapio will now report if a child process has an abnormal exit along with
   the associated status or signal.

- Compiler optimization may sometimes result in systemtap not being able to
   access a user-space probe argument.  Compiling the application with
   -DSTAP_SDT_ARG_CONSTRAINT=nr will force the argument to be an immediate or
   register value which should enable systemtap to access the argument.

- The "--remote USER@HOST" functionality can now be specified multiple times
   to fan out on multiple targets.  If the targets have distinct kernel and
   architecture configurations, stap will automatically build the script
   appropriately for each one.  This option is also no longer considered
   experimental.

- The NSS certificate database generated for use by the compile server is now
   generated with no password. Previously, a random password was generated and
   used to access the database. This change should be transparent to most users.
   However, if you are prompted for a password when using systemtap, then
   running $libexecdir/stap-gen-cert should correct the problem.

- The following deprecated tools have been removed:
       stap-client
       stap-authorize-server-cert
       stap-authorize-signing-cert
       stap-find-or-start-server
       stap-find-servers
   Use the --use-server, --trust-server and --list-servers options of stap
   instead.

= Systemtap script language changes

- process("...").library("...") probes are now supported.  Wildcards
   are supported in the library-name part, to refer to any shared
   library that is required by process-name, which matches the glob
   pattern and the rest of the probe point.

- process.mark now supports $$parms for reading probe parameters.

= Systemtap external dependents changes

- Systemtap checks that the build-id of the module being probed matches the
   build-id saved in the systemtap module.  Invoking systemtap with
   -DSTP_NO_BUILDID_CHECK will bypass this build-id runtime verification.  See
   man ld(1) for info on --build-id.

= Systemtap tapset changes

- Improved ptrace syscall decoding.

- eventcount.stp now allows for event counting in the format of
   'stap eventcount.stp process.end syscall.* ...', and also reports
   corresponding event tid's.

- The new addr() function returns the probe's instruction pointer.

- The timestamp tapset includes jiffies() and HZ() for lightweight approximate
   timekeeping.

= Systemtap example changes

- Eventcounting and tcp_init_cwnd examples have been added.

= Contributors for this release

   Lukas Berk, Dave Brolley, William Cohen, Stan Cox, Frank Ch. Eigler,
   Rayson Ho, *Jan Kratochvil, Adrien Kunysz, *Fabio Olive Leite, Roland McGrath,
   Przemysław Pawełczyk, *Bryn Reeves, *Kim van der Riet, *Nathan Scott,
   David Smith, Josh Stone, Mark Wielaard,

   Special thanks to new contributors, marked with '*' above.

= Examples of tested kernel versions

   2.6.9-89 (i686)
   2.6.18 (i686,x86_64)
   2.6.32.12 (ppc64)
   2.6.35 (x86_64)
   2.6.37 (i686,x86_64)

= Known issues with this release

- Some kernel crashes continue to be reported when a script probes
   broad kernel function wildcards.

- Using the new "stap -DSTP_ALIBI" option, nearly all script-based
   systemtap-generated code is compiled out of the resulting module,
   for use as a test of the kernel probing infrastructure.

= Bugs fixed for this release

3823 internationalize the thing
6880 more syntax for shared library probing
9699 'context.exp' - test fails with 2.6.28-git3 kernel on powerpc
10289 stap probes user space markers don't work with 32-on-64 executables
10461 Enhance support for probing C++ binaries
10878 support $$args/$$parms for process().mark() sdt probes
10917 environment variable expansion in executable search
11445 Check that assert_is_my_proc check is within all uprobes/utrace callback 
entry points
11844 --use-server-on-error option
11862 remove obsolete stap-client script and friends
12099 process("/path/to/shell-script") probes
12115 run scripts remotely
12138 sdt_misc.exp fails most ptr types on i686
12139 SDT V3 fails with structs that are only declared
12209 accept and ignore %l (long) option in *printf family
12211 stapio shouldn't hide the death of its child
12411 Markers using %rbx register incorrectly masked to low byte
12412 stale reference
12413 kprocess.* support PIDs but not TIDs
12419 add "repnz ret" to uprobes whitelist on x86*
12428 Document Compile Server/Client Setup and Admin
12458 Incorrect module bias on prelinked "find"
12470 Fix _wait4_opt_str
12471 Support wait4 *status printing
12498 systemtap.examples/process/noptrace hangs on RHEL4 because arguments are 
wrong
12500 ptrace decoder
12508 event-counting command line option
12514 missing build-id tolerance
12536 sdt v>=2 argument parsing can't parse '4+4(%esp)'
12540 "Could not obtain information on password file" build error
12543 PKGLIBEXECDIR undefined, causing uprobes.ko build to fail
12560 built-in safer mini-ldd
12592 Compile server should support non-standard kernel paths
12612 Generate modules compatible with older staprun
12638 use built-in mini-ldd in translate.cxx
12645 exelib.exp failures (and hung stapio's) on s390x
12729 stap error message needs improvement
12741 rip-relative instruction is not detected as such
12749 iterate_over_libraries should not use popen
12770 loc2c generates an unsupported deref(8,...) on i686
12781 task_finder __stp_utrace_task_finder_target_syscall_entry code a bit fat
12784 CVE-2011-1781, CVE-2011-1769: correct DW_OP_{mod,div} division-by-zero bug
12785 systemd-managed tasks not visible to process probes on fedora 15

= Test results on various systems

- After running "sudo make installcheck" from the test suite, on a
   suitably equipped machine (kernel debugging data and other stuff
   installed), you should see 1600-2000 passes and a small handful of
   failures.  On a machine without kernel utrace support, you should
   see 800-1000 passes.
