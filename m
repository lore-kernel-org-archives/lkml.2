Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab1AQMcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 07:32:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab1AQMcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 07:32:08 -0500
Date: Mon, 17 Jan 2011 07:31:56 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: systemtap@sourceware.org
Cc: lwn@lwn.net, linux-kernel@vger.kernel.org
Subject: systemtap release 1.4
Message-ID: <20110117123156.GA17030@redhat.com>
Reply-To: systemtap@sourceware.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The systemtap team announces release 1.4.

  prototype script remote-execution via ssh, duplicate diagnostic
  suppression, much improved backtracing diagnostics, access to
  "hidden" kernel tracepoints, wildcards in process("/bin/*") probes,
  improved debuginfo-less <sys/sdt.h> userspace markers, kernel
  versions 2.6.9 through 2.6.37

=3D Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-1.4.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=3D615
  git tag release-1.4 (commit c36cb86acfa2)

  There have been over 400 commits since the last release.
  There have been over 80 bugs/features fixed since the last release.

=3D How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=3Dsystemtap.git;a=3Dtree
  Further information at http://sourceware.org/systemtap/wiki/

=3D Systemtap frontend (stap) changes

- An experimental option "--remote USER@HOST" option will run pass 5
  on a given ssh host, after building locally (or with --use-server)
  for that target.  We anticipate extending this facility to multiple
  concurrent remote hosts.

- Backtraces attempted against processes or modules that lack known
  unwind data (not using the -d option or other implicit ways) now
  produce diagnostics about how to rerun stap next time (with extra -d
  PATH options) to make those backtraces work.

- Duplicate warnings at translate and run-time are suppressed by
  default (at low verbosity levels).  Run-time warnings may now be
  suppressed with "stap -w" or "staprun -w".

- The "stap -t" option now displays hit count/timing information per
  probe-point rather than a summary for each probe.  It also now shows
  the derivation chain for each probe-point.

- The integrated compile-server client has been extended for certificate
  management, and the previous shell scripts will be deprecated.  It
  also now automates the remote compilation of uprobes.ko.

=3D Systemtap script language changes

- More kernel tracepoints are accessible to the kernel.trace("...") mechani=
sm,
  if kernel source trees or debuginfo are available.  These formerly "hidde=
n"
  tracepoints are those that are declared somewhere other than the usual
  include/linux/trace/ headers, such as xfs and kvm.

- debuginfo-based process("...").function/.statement/.mark probes support
  wildcards in the process-name part, to refer to any executable files that
  match the glob pattern and the rest of the probe point.  If the executable
  files are shebang shell scripts, the interpreter binary is probed.

=3D Systemtap external dependents changes

- The <sys/sdt.h> header file was rewritten to make it closer to the
  zero-cost ideal for a dormant probe.  Integers parameters of various
  sizes are more accurately described by the debuginfo-free metadata.
  Special cases exist for C, C++, and assembly users.

=3D Systemtap tapset changes

- Embedded-C tapset functions meant for unprivileged users can
  use the new /* myproc-unprivileged */ function.

- A number of variables in the standard tapset will be deprecated in=20
  the next version of systemtap, to correct spelling and naming
  inconsistencies.  (Use --compatible=3D1.4 to retain access under the
  current names.)

- Many string/buffer-related operations in the tapset were made more
  obviously robust.  Many portability- and documentation-related cleanups
  were made throughout.

- A large number of preexisting tapset functions are now listed in the
  tapset reference manual and associated man pages (function::*.3stap).

- New functions:
  tz_ctime: formats times for the local time zone (as of startup)
  inode_name: Returns the first path basename associated with given inode.
  task_dentry_path: Returns the full path name for a task's dentry.
  tokenize: Rewritten for concurrency.
  user_{u,}int{8,16,32,64}: New standardized userspace integer accessors.

=3D New script examples

- io/inodewatch.stp: Monitoring Reads and Writes to a File
- io/inodewatch2.stp: Monitoring Attribute Changes to a File
- profiling/latencytap.stp: Show reasons and durations for processes sleepi=
ng.

=3D Contributors for this release

  Adrien Kunysz, Dave Brolley, David Smith, Don Domingo, *Erick
  Tryzelaar, Frank Ch. Eigler, *Grant Edwards, Jeff Moyer, Jim
  Keniston, Josh Stone, *Kapileshwar Singh (KP), Lukas Berk, Mark
  Wielaard, Przemys=C5=82aw Pawe=C5=82czyk, Rayson Ho, Roland McGrath, Stan=
 Cox,
  *Timo Juhani Lindfors, Tony Jones, Wenji Huang, William Cohen

  Special thanks to new contributors, marked with '*' above.

=3D Examples of tested kernel versions

  2.6.9-89 (i686)
  2.6.18 (i686,x86_64)
  2.6.32.12 (ppc64)
  2.6.35 (x86_64)
  2.6.37 (i686,x86_64)

=3D Known issues with this release

- When using the systemtap client and server udp port 5353 must be
  open in your firewall in order for the client to find servers using
  avahi-browse.

- The stap-server may not be sufficiently robust to operate on an open
  untrusted network.

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards.

- Using the new "stap -DSTP_ALIBI" option, nearly all script-based
  systemtap-generated code is compiled out of the resulting module,
  for use as a test of the kernel probing infrastructure.

=3D Bugs fixed for this release

5076   detect both inlined and non-inlined function instances
5642   Allow passing of module options on stap command line
6456   process("/bin/*") uprobes wildcards
6883   Load helper-modules(ex. uprobes.ko) by non-privileged users
6960   script for latencytop-like functionality for older (rhel5) kernels
7054   para-callgraph .meta example sometimes hangs
7097   Staprun: Don't open stp_cpu* when -L is specified
9871   use @cast() instead of embedded-c whereever possible
9911   Systemtap is broken with linux-next 2.6.29-rc6-next-20090226
9928   Configuring latest snapshot on RHEL4.x fails with 'error: __thread s=
upport required'
9937   verify user-space build-ids
10350  support list-installation-prerequisites mode
10651  very rare BUG_ON kernel/timer.c:619 due to runtime/time.c
10657  semi-unprivileged tapset embedded-C functions
10665  backtrace() is too slow
10745  Give access to "hidden" tracepoints
10821  unwind_frame has an oversized frame
10830  new pp() variant for source-level probe point name
10922  server.exp produces lots of failures with default install
10943  Support generic @entry saving in .return probes
10975  cpuid() context tapset function unused and duplicate
11095  Support "provider" for mark() probes
11197  stap-server security prophylactics
11203  stap-server should not use /etc/rc.d/init.d/functions
11338  use @defined in tapsets
11343  backward compatibility flags/conditionals
11369  package and/or document stap_merge
11376  process(pid).statement(addr).absolute bugs + fix
11388  syscall.mmap* probes versus 2.6.33+ kernels
11442  Running tests installed by systemtap-testsuite rpm as root alters /e=
tc/systemtap
11444  Check that no pt_regs*-processing functions are /* unprivileged */
11506  Support Crash/kdump with systemtap memory flight recorder mode
11554  Document SYSTEMTAP_DEBUGINFO_PATH better
11564  Show a warning/help when the kernel version is different between pac=
kages
11667  sdt v2 cleanups
11691  The dtrace script should heed PEP 8
11720  on RHEL5 ppc, running the script from skipped.exp causes an internal=
 gcc error
11735  similarly named executables/libraries get probed/detected wrongly
11736  new -t option to have per-derived-probe timings
11739  alibi flag
11756  warnings for deprecated declarations
11772  listing_mode_vars are empty with debuginfoless SDT
11794  returnstr(fmt) needs to be replaced with return_str(fmt, $return)
11798  early sanity check for testsuite to assert debuginfo presence
11800  clarify stap -l "PROBE1,PROBE2,PROBE3" usage
11811  warn on missing -d PATH
11823  document user-space probes and other recent features in beginner's g=
uide
11825  The piece we want is part of a computed value!
11861  __bio_ino tapset fn can encounter ERROR due to struct bio->bi_vcnt =
=3D=3D 0
11870  Kernel panic when loading usb_storage.ko while running a SystemTap s=
cript
11880  for c++ objects, support probing by mangled name too
11905  stap-server script executes random files in the $STAT_PATH directory
11906  stap-server script should generate more info on server startup and s=
tatus
11910  -vvv should print $location resolution errors
11911  -L never shows aggregates (etc)
11916  sdt.h version 3 improvements
11922  unnecessary second name->ip resolution in avahi-provided hosts
11940  Compile error when using global variables on 2.6.36
11949  duplicate-eliminate tapset files
11951  Eliminate use of NIPQUAD and NIPQUAD_FMT in tapset/ip.stp
11962  ioblock.stp uses BIO_RW which is not available in 2.6.36 kernels
11963  staprun uses non-standard sscanf extension "%as"
11982  debian build failure - elfutils libebl missing
12024  automatic printing of aggregates as decimal values
12035  staprun fails to build on ia64
12081  procfs probes don't cope well with de-duping
12082  task_gid and task_egid fail on call to get_task_cred()
12121  Apparent non-determinism in DWARF symbol resolution
12124  emit diagnostics on unwind errors
12137  SDT fails -pedantic with too-long strings
12141  Segmentation fault in apps probed by libstdc++ i686
12164  stap script causing ptrace to error with "Device or resource busy"
12168  staprun: filter duplicate errors/warnings
12169  make tokenize smp-safe
12172  make unprivileged mode default under certain conditions
12176  string literal at end of file crashes parser
12182  startup crash on 24-core x86-64
12195  pass current user-space timezone
12214  stap.1 SAFETY AND SECURITY section contains an unfinished sentence
12274  Compile Server does not Return uprobes.ko to the Client
12309  timer / delayed_task crashes
12315  inotify tests fail on rawhide kernels
12330  compile error when using tty.stp on RHEL6/ppc64
12335  langref.pdf is all monospaced from page 13 (section 3.1) onwards
12338  The 'softirq.entry' and 'softirq.exit' probes in tapset/irq.stp need=
 to be updated
12399  sdt.h semaphores colliding between .so and .exe files=20
CVE-2010-4170  insecure loading of modules
CVE-2010-4171  ability to remove unused modules by unprivileged user

=3D Test results on various systems

- After running "sudo make installcheck" from the test suite, on a
  suitably equipped machine (kernel debugging data and other stuff
  installed), you should see 1600-2000 passes and a small handful of
  failures.  On a machine without kernel utrace support, you should
  see 800-1000 passes.

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFNNDa8VZbdDOm/ZT0RAniqAKCB/+OBqduPQkHomPVoDXZrg5+3FwCdFJaN
GJDC0fYvIxNoESXz6IXdiQM=
=blyw
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
