Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1BIJCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:02:09 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40656 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab1BIJCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:02:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<m1hbce46fw.fsf@fess.ebiederm.org>
	<AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
Date: Wed, 09 Feb 2011 01:01:53 -0800
In-Reply-To: <AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 8 Feb 2011 12:44:17 -0800")
Message-ID: <m1bp2ly41q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX183mA/vThwvlz4nR+wDtGZgu4lvSD5JFbU=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.2 XM_Multi_Part_URI URI: Long-Multi-Part URIs
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 XM_URI_RBL_RM URI removed in uri.bl.xmission.com
	*      [URIs: gnu.org]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Feb 8, 2011 at 12:28 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> A quick heads up. =C2=A02.6.38-rc4 looks like the worst kernel I've ever=
 tried to
>> test. =C2=A0It boots up properly and looks ok, but I can't get it to even
>> compile the programs I usually test with. 2.6.38-rc3 at least managed
>> that yesterday.
>
> gcc dying with ICE or SIGSEGV? Or what? Seriously lacking information
> here.
>
> Are you using btrfs or cifs (the two filesystems that had
> bigger-than-average changes)?
>
> Any chance to bisect it (even if just partially - a couple of
> bisection runs would already narrow it down quite a bit)?

What I have been able to do today on this one is, narrow it down a
little and provide a reasonable description of one of the problem.

In a fedora 12 world in a subdirectory on ext4 with the applications
pinned into a mount namespace.  I am seeing compiles of gcc-4.4.3 fail.  A
quick survey of the compile failures makes it look like these compiles
failures are deterministic, at least I see the same error messages in multi=
ple
failed builds.

The machine is a dual socket quad core non hyperthread machine with 10G of =
RAM.
The cpus are: Intel(R) Xeon(R) CPU           E5420  @ 2.50GHz

In the case that fails I am simultaneously compiling a 32bit gcc cross
compiler for x86_64 and i386, for the same source but with different
object directories.  The compiles failures happen exactly as before if I
rerun the build commands.  I'm still trying to figure out why the
individual files are failing.  I expect if I do that will give me a much
bigger clue.

What is interesting is that this fails exactly the same way in at least thr=
ee invocations
of the command and I expect all of them.  With failures taking about 30 min=
utes.
I might try a bisect tomorrow.

The unfortunate thing is that this weird compile failure during a
parallel build doesn't tell me much yet about what the root cause is.

I have attached my build scripts in case that helps.  To understand.
At the moment I am still trying to break this down into something smaller
so I can see just what the heck is going on.  And I will keep poking at
it until I get somewhere.

The annoying thing is that looking at the other failures I was seeing
before the compile fell apart.  I think I am might be on top of half a
dozen other regressions as well.  I don't have a clue how I am going to
get through all of those regressions before before 2.6.38 is out.=20

Eric

The failures look like:

$ make -C gcc-stage1-x86_64 all-gcc all-target-libgcc install-gcc install-t=
arget-libgcc DESTDIR=3D/bld/Across/Across-2.0.0/sysroot-x86_64
gcc -qlanglvl=3Dansi -c -DHAVE_CONFIG_H -g -O2 -I. -I/bld/Across/Across-2.0=
.0/gcc-4.4.3/libiberty/../include  -W -Wall
-Wwrite-strings -Wc++-compat -Wstrict-prototypes /bld/Across/Across-2.0.0/g=
cc-4.4.3/libiberty/fibheap.c -o fibheap.o
gcc: unrecognized option '-qlanglvl=3Dansi'
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c: In function =E2=80=
=98fibheap_union=E2=80=99:
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:151: warning: implic=
it declaration of function =E2=80=98free=E2=80=99
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:151: warning: incomp=
atible implicit declaration of built-in function =E2=80=98free=E2=80=99
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:156: warning: incomp=
atible implicit declaration of built-in function =E2=80=98free=E2=80=99
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:172: warning: incomp=
atible implicit declaration of built-in function =E2=80=98free=E2=80=99
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c: In function =E2=80=
=98fibheap_extract_min=E2=80=99:
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:190: warning: incomp=
atible implicit declaration of built-in function =E2=80=98free=E2=80=99
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c: In function =E2=80=
=98fibheap_delete_node=E2=80=99:
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:258: error: =E2=80=
=98LONG_MIN=E2=80=99 undeclared (first use in this function)
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:258: error: (Each un=
declared identifier is reported only once
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:258: error: for each=
 function it appears in.)
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c: In function =E2=80=
=98fibheap_delete=E2=80=99:
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:269: warning: incomp=
atible implicit declaration of built-in function =E2=80=98free=E2=80=99
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c: In function =E2=80=
=98fibheap_consolidate=E2=80=99:
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:360: warning: implic=
it declaration of function =E2=80=98memset=E2=80=99
/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:360: warning: incomp=
atible implicit declaration of built-in function =E2=80=98memset=E2=80=99


$ make -C gcc-stage1-i386 all-gcc all-target-libgcc install-gcc install-tar=
get-libgcc DESTDIR=3D/bld/Across/Across-2.0.0/sysroot-i386
make: Entering directory `/bld/Across/Across-2.0.0/gcc-stage1-i386'
make[1]: Entering directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/libib=
erty'
make[2]: Entering directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/libib=
erty/testsuite'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/libibe=
rty/testsuite'
make[1]: Leaving directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/libibe=
rty'
make[1]: Entering directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/intl'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/intl'
make[1]: Entering directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/build=
-i686-pc-linux-gnu/libiberty'
make[2]: Entering directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/build=
-i686-pc-linux-gnu/libiberty/testsuite'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/build-=
i686-pc-linux-gnu/libiberty/testsuite'
make[1]: Leaving directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/build-=
i686-pc-linux-gnu/libiberty'
make[1]: Entering directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/build=
-i686-pc-linux-gnu/fixincludes'
gcc -g -O2  -o fixincl fixincl.o fixtests.o fixfixes.o server.o procopen.o =
fixlib.o fixopts.o ../libiberty/libiberty.a
fixincl.o: In function `quoted_file_exists':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixincl.c:624: undefined ref=
erence to `_sch_istable'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixincl.c:624: undefined ref=
erence to `_sch_istable'
fixincl.o: In function `egrep_test':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixincl.c:600: undefined ref=
erence to `xregexec'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixincl.c:600: undefined ref=
erence to `xregexec'
fixincl.o: In function `test_for_changes':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixincl.c:1211: undefined re=
ference to `xregexec'
fixincl.o: In function `extract_quoted_files':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixincl.c:711: undefined ref=
erence to `xregexec'
fixincl.o: In function `initialize':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixincl.c:245: undefined ref=
erence to `_sch_istable'
fixincl.o: In function `main':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixincl.c:139: undefined ref=
erence to `_sch_istable'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixincl.c:157: undefined ref=
erence to `_sch_istable'
fixtests.o: In function `machine_name_test':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixtests.c:79: undefined ref=
erence to `xregexec'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixtests.c:104: undefined re=
ference to `xregexec'
fixfixes.o: In function `gnu_type_fix':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:681: undefined re=
ference to `xregexec'
fixfixes.o: In function `emit_gnu_type':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:144: undefined re=
ference to `_sch_toupper'
fixfixes.o: In function `wrap_fix':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:599: undefined re=
ference to `xregexec'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:617: undefined re=
ference to `_sch_istable'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:621: undefined re=
ference to `_sch_toupper'
fixfixes.o: In function `machine_name_fix':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:508: undefined re=
ference to `xregexec'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:539: undefined re=
ference to `xregexec'
fixfixes.o: In function `format_fix':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:282: undefined re=
ference to `xregexec'
fixfixes.o: In function `format_write':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:198: undefined re=
ference to `_sch_istable'
fixfixes.o: In function `char_macro_use_fix':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:332: undefined re=
ference to `xregexec'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:439: undefined re=
ference to `_sch_istable'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:448: undefined re=
ference to `_sch_istable'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:451: undefined re=
ference to `_sch_istable'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:453: undefined re=
ference to `_sch_istable'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixfixes.c:448: undefined re=
ference to `_sch_istable'
server.o:/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/server.c:124: more =
undefined references to `_sch_istable' follow
fixlib.o: In function `compile_re':
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixlib.c:193: undefined refe=
rence to `xregcomp'
/bld/Across/Across-2.0.0/gcc-4.4.3/fixincludes/fixlib.c:198: undefined refe=
rence to `xregerror'
collect2: ld returned 1 exit status
make[1]: *** [full-stamp] Error 1
make[1]: Leaving directory `/bld/Across/Across-2.0.0/gcc-stage1-i386/build-=
i686-pc-linux-gnu/fixincludes'
make: *** [all-build-fixincludes] Error 2
make: Leaving directory `/bld/Across/Across-2.0.0/gcc-stage1-i386'




--=-=-=
Content-Disposition: attachment; filename=Across.spec

Name:           Across
Version:        2.0.0
Release:        %{?release:%{release}}%{!?release:eng}
Summary:        uClibc-based development toolchain

Group:          Development/Tools
License:        GPL
Source0:        uClibc-0.9.30.2.tar.bz2
Source1:        binutils-2.20.tar.bz2
Source2:        gcc-core-4.4.3.tar.bz2
Source3:        gmp-4.3.2.tar.bz2
Source4:        mpfr-2.4.2.tar.bz2
Source5:        kernel-headers-2.6.29.6.tar.bz2
Source10:       build.sh
Source11:       uclibc-i386.config
Source12:       uclibc-x86_64.config
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  quilt

# Disable automatic dependency processing: we don't want to override
# standard system libraries like libresolv.so.0
AutoReqProv:    no

# Disable automatic debuginfo package generation and other post-build
# processing, because it does not handle uClibc binaries
%define __spec_install_post %{nil}
%define debug_package %{nil}

%description
This package provides development tools based on the uClibc library, a
space-efficient replacement for glibc.

%prep
%setup -q -c -T -a 0 -a 1 -a 2 -a 3 -a 4 -a 5
ln -s %{_sourcedir} patches
#echo %{PATCHURL1} | tr ' ' '\n' >series
#quilt push -a
cp %{SOURCE10} %{SOURCE11} %{SOURCE12} .
chmod +x build.sh

%build
%{?a4_configure:exit 0}
( cd gmp-4.3.2; ./configure )
make -C gmp-4.3.2 all
( cd mpfr-2.4.2; ./configure --with-gmp-build=../gmp-4.3.2 )
make -C mpfr-2.4.2 all
./build.sh i386 $(pwd)/sysroot-i386 $(pwd)/uClibc-0.9.30.2 $(pwd)/binutils-2.20 $(pwd)/gcc-4.4.3 $(pwd)/gmp-4.3.2 $(pwd)/mpfr-2.4.2 $(pwd)/kernel-headers-2.6.29.6/include &
./build.sh x86_64 $(pwd)/sysroot-x86_64 $(pwd)/uClibc-0.9.30.2 $(pwd)/binutils-2.20 $(pwd)/gcc-4.4.3 $(pwd)/gmp-4.3.2 $(pwd)/mpfr-2.4.2 $(pwd)/kernel-headers-2.6.29.6/include &
wait

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/share/Across
cp -alv sysroot-i386 $RPM_BUILD_ROOT/usr/share/Across/i386-linux-uclibc
cp -alv sysroot-x86_64 $RPM_BUILD_ROOT/usr/share/Across/x86_64-linux-uclibc

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
/usr/share/Across/*

--=-=-=
Content-Disposition: attachment; filename=build.sh

#!/bin/bash
#
# Build a gcc + uClibc toolchain
#
# References:
# http://gcc.gnu.org/ml/gcc/2007-08/msg00327.html
# http://busybox.net/~vda/HOWTO/i486-linux-uclibc/HOWTO.txt
# http://wiki.osdev.org/GCC_Cross-Compiler

set -ex

arch=$1
sysroot=$2
uclibc=$3
binutils=$4
gcc=$5
gmp=$6
mpfr=$7
kernel_headers=$8

unset CPATH LIBRARY_PATH INSTALL
PATH=/usr/lib/ccache:/bin:/usr/bin
rm -rf ${sysroot}
mkdir ${sysroot}
ln -s . ${sysroot}/usr

# Link target-specific usr directory to usr, otherwise gcc has trouble finding ld
ln -s . ${sysroot}/usr/${arch}-linux-uclibc

# Install kernel headers
mkdir ${sysroot}/usr/include
cp -pLR ${kernel_headers}/{asm,linux,asm-generic} ${sysroot}/usr/include/

# Build binutils
mkdir binutils-${arch}
( cd binutils-${arch}; ${binutils}/configure --prefix=/usr --target=${arch}-linux-uclibc --with-gmp-include=${gmp} --with-gmp-lib=${gmp}/.libs --with-mpfr-include=${mpfr} --with-mpfr-lib=${mpfr}/.libs --with-sysroot=${sysroot} --program-prefix=${arch}-linux-uclibc- )
make -C binutils-${arch} all install DESTDIR=${sysroot}

# Build stage 1 gcc (required to build uClibc)
mkdir gcc-stage1-${arch}
( cd gcc-stage1-${arch}; ${gcc}/configure --prefix=/usr --target=${arch}-linux-uclibc --enable-languages=c --with-gmp-include=${gmp} --with-gmp-lib=${gmp}/.libs --with-mpfr-include=${mpfr} --with-mpfr-lib=${mpfr}/.libs --disable-shared --disable-nls --disable-multilib --disable-threads --disable-libmudflap --disable-libssp --disable-libgomp --disable-decimal-float --disable-tls --without-headers --with-build-time-tools=${sysroot}/usr/bin --with-gnu-ld )
make -C gcc-stage1-${arch} all-gcc all-target-libgcc install-gcc install-target-libgcc DESTDIR=${sysroot}

# Build uClibc
cp -a ${uclibc} uclibc-${arch}
cp uclibc-${arch}.config uclibc-${arch}/.config
make -C uclibc-${arch} oldconfig
make -C uclibc-${arch} extra/scripts/unifdef
PATH=${sysroot}/usr/bin:${PATH} make -C uclibc-${arch} CROSS=${arch}-linux-uclibc- KERNEL_HEADERS=${sysroot}/usr/include PREFIX=${sysroot} RUNTIME_PREFIX=/ DEVEL_PREFIX=/ RUNTIME_PREFIX_LIB_FROM_DEVEL_PREFIX_LIB= V=1 all install
PATH=${sysroot}/usr/bin:${PATH} make -C uclibc-${arch}/utils CROSS=${arch}-linux-uclibc- KERNEL_HEADERS=${sysroot}/usr/include PREFIX=${sysroot} RUNTIME_PREFIX=/ DEVEL_PREFIX=/ RUNTIME_PREFIX_LIB_FROM_DEVEL_PREFIX_LIB= V=1 hostutils utils_install

# Build final gcc targeting uClibc
mkdir gcc-final-${arch}
( cd gcc-final-${arch}; ${gcc}/configure --prefix=/usr --target=${arch}-linux-uclibc --enable-languages=c --with-sysroot=${sysroot} --with-gmp-include=${gmp} --with-gmp-lib=${gmp}/.libs --with-mpfr-include=${mpfr} --with-mpfr-lib=${mpfr}/.libs --disable-nls --disable-multilib --disable-threads --disable-libgomp --disable-decimal-float --with-build-time-tools=${sysroot}/usr/bin --with-gnu-ld )
make -C gcc-final-${arch} all install DESTDIR=${sysroot}

--=-=-=--
