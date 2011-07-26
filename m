Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab1GZQRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:17:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab1GZQRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:17:30 -0400
Message-ID: <4E2EE8C5.1070605@redhat.com>
Date: Tue, 26 Jul 2011 12:18:13 -0400
From: Stan Cox <scox@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: systemtap@sourceware.org
CC: linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: systemtap release 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The systemtap team announces release 1.6

   The systemtap compile-server now takes advantage of the module cache and is
   downward compatible with older client versions, ARM support has been
   improved so many tapsets and functions now work properly, the '-R' option
   has been added to allow module renaming, probes now default to the CMD
   process if -c CMD is given, process invocation errors now give better
   feedback, -L now gives context variables for 'process.syscall', backtrace
   support has been improved and is slightly faster, the transport layer now
   insures that all control messages are delivered.

= Where to get it

   http://sourceware.org/systemtap/ - our project page
   http://sourceware.org/systemtap/ftp/releases/systemtap-1.6.tar.gz
   http://koji.fedoraproject.org/koji/packageinfo?packageID=615
   git tag release-1.6 (commit X )

   There have been over 186 commits since the last release.
   There have been over 32 bugs/features fixed since the last release.

= How to build it

   See the README and NEWS files at
   http://sourceware.org/git/?p=systemtap.git;a=tree
   Further information at http://sourceware.org/systemtap/wiki/

= Systemtap frontend (stap) changes

- The systemtap compile-server no longer uses the -k option when calling the
   stap translator. As a result, the server will now take advantage of the
   module cache when compiling the same script more than once, possibly
   resulting in improved server performance depending on the situation.

- The systemtap compile-server and client now each check the version of the
   other, allowing both to adapt when communicating with a down-level
   counterpart. As a result, all client and server versions can communicate
   with each other. A client will prefer a newer server when selecting
   a server automatically.

- SystemTap has improved support for the ARM architecture.  The
   kread() and kwrite() operations for ARM were corrected allowing many
   of the tapsets probes and function to work properly on the ARM
   architecture.

- Systemtap error messages now provide feedback when staprun or any
   other process fails to launch, for example when the user doesn't
   have the proper permissions to launch staprun.

- Systemtap will now map - to _ in module names.  Previously, stap -L
   'module("i2c-core").function("*")' would return nothing, but it now
   returns a list as if stap -L 'module("i2c_core").function("*") had
   been specified.

- staprun -R can be used to rename the module to a unique name before
   inserting it. Systemtap itself will also call staprun with '-R' by
   default.  This allows the same module to be inserted more than once,
   without conflicting duplicate names.

- stap -L 'process("PATH").syscall' will now list context variables

= Systemtap script language changes

- Process names now default to the process specified by -c CMD.  This
   allows a usage like:
   'process("PROC").function("*")... process("PROC").mark("*")...' -c 'PROC'
   to instead be specified as
   'process().function("*")... process().mark("*")...' -c 'PROC'

= Systemtap external dependents changes

- Depends on elfutils 0.142+.

= Contributors for this release

   Lukas Berk, Dave Brolley, Frank Ch. Eigler, William Cohen, Stan Cox,
   *Alfred Landrum, *Chris Meek, *Daniel Migault, *Marc Milgram, Petr Muller,
   David Smith, *Yoshihide Sonoda, Josh Stone, *Atsushi Tsuji, Mark Wielaard,

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

= Bugs fixed for this release

1288	mechanism to track safe/unsafe kernel address ranges
5163	tweak uprobes.ko build process
6954	++ operations not triggering automatic global printing
10189	STP_START gets lost in a warning flood
10812	Improve buildid verification.
10857	dwarf unwinder doesn't handle call frame instructions taking expressions
11504	Wrong location for inferred type conflict in error message
11525	pr10854.exp locks up expect run
12008	map module("foo-bar") to module("foo_bar")
12033	'stap -l' variant with error reporting
12101	stap-server should use proper cert passwords
12427	implied process("...") target for stap -c CMD invocation
12580	Pass LC_* values to stap-server servers
12729	stap error message needs improvement
12743	stap -L process("path").syscall probes should list context variables
12770	loc2c generates an unsupported deref(8,...) on i686
12781	task_finder __stp_utrace_task_finder_target_syscall_entry code a bit fat
12784	correct DW_OP_{mod,div} division-by-zero bug
12785	systemd-managed tasks not visible to process probes on fedora 15
12787	__tcp_skb_dport should return value in host order.
12829	"Too many interrupts received." under sudo
12834	itrace not handling utrace engines properly
12876	cmdline_str breaks early on empty string argv[]
12877	task_finder doesn't get non-standard exec's right
12884	--tempdir option to specify the name of the temporary directory
12888	stap-serverd should not be required to use -k
12890	staprun on-the-fly module renaming
12899	dtrace script should handle: -o /dev/null, CC=gcc -option
12917	Implement compile-server/client versioning
12927	stack.c gets unknown field 'warning_symbol'
12955	unprivileged mode elaboration in man pages etc.
12960	_stp_ctl_send tries to msleep when out of memory
12998	improve error message on automatic --use-server mode
13001	!HAVE_NSS build failures
13026   staprun security bugs
