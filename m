Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839Ab2EQCHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 22:07:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18447 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760521Ab2EQCHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 22:07:14 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=N2_jc0BMHi0A:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=1PbJQ8p7JJ6C1qxhQigA:9 a=PUjeQqilurYA:10 a=Gq9PjJF5URkA:10 a=iVWu4Csv49L6gzgZLPUA:9 a=joMpV_QEsb3ZUBY8YsoA:7 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337220428.6724.87.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Steven Rostedt <rostedt@goodmis.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        fweisbec@gmail.com, jeremy@goop.org, riel@redhat.com, luto@mit.edu,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com, linux-arch@vger.kernel.org
Date: Wed, 16 May 2012 22:07:08 -0400
In-Reply-To: <4FB449C1.2020603@intel.com>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	    <1337072138-8323-7-git-send-email-alex.shi@intel.com>
	    <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
	    <4FB2590C.1050303@intel.com> <1337092577.27694.45.camel@twins>
	   <1337093840.27694.56.camel@twins> <4FB34D49.1060809@intel.com>
	  <1337155239.27694.131.camel@twins> <4FB3ACD2.5010900@intel.com>
	 <1337202569.4281.13.camel@twins> <4FB449C1.2020603@intel.com>
Content-Type: multipart/mixed; boundary="=-8qGVCY1VH4LhVrgi42O5"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8qGVCY1VH4LhVrgi42O5
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

On Thu, 2012-05-17 at 08:43 +0800, Alex Shi wrote:

> > I've seem to have misplaced my cross-compiler set, so I've only compiled
> > x86-64 for now.
> 
> 
> Oh, I also need a cross-compiler for other archs. Thanks reminder!

Here:

http://kernel.org/pub/tools/crosstool/

Oh, and if you want to automate this. I attached a ktest.pl config that
does it for you. I'll be pushing this config and others into a examples
directory come the next merge window.

Ktest is located in the Linux tree under tools/testing/ktest/

You can run a bunch of cross compiles by doing:

ktest.pl crosstests.conf

-- Steve





--=-8qGVCY1VH4LhVrgi42O5
Content-Disposition: attachment; filename="crosstests.conf"
Content-Type: text/plain; name="crosstests.conf"; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

#
# Example config for cross compiling
#
# In this config, it is expected that the tool chains from:
#
#   http://kernel.org/pub/tools/crosstool/files/bin/x86_64/
#
# running on a x86_64 system have been downloaded and installed into:
#
#   /usr/local/
#
# such that the compiler binaries are something like:
#
#   /usr/local/gcc-4.5.2-nolibc/mips-linux/bin/mips-linux-gcc
#
# Some of the archs will use gcc-4.5.1 instead of gcc-4.5.2
# this config uses variables to differentiate them.
# 
# Comments will be described for some areas, but the opitons are
# all documented in the samples.conf file.

# ${PWD} is defined by ktest.pl to be the directory that the user
# was in when they executed ktest.pl. It may be better to hardcode the
# path name here. THIS_DIR is the variable used through out the config file
# in case you want to change it.

THIS_DIR := ${PWD}

# Update the BUILD_DIR option to the location of your git repo you want to test.
BUILD_DIR = ${THIS_DIR}/linux.git

# The build will go into this directory. It will be created when you run the test.
OUTPUT_DIR = ${THIS_DIR}/cross-compile

# The build will be compiled with -j8
BUILD_OPTIONS = -j8

# The test will not stop when it hits a failure.
DIE_ON_FAILURE = 0

# If you want to have ktest.pl store the failure somewhere, uncomment this option
# and change the directory where ktest should store the failures.
#STORE_FAILURES = ${THIS_DIR}/failures

# The log file is stored in the OUTPUT_DIR called cross.log
# If you enable this, you need to create the OUTPUT_DIR. It wont be created for you.
#LOG_FILE = ${OUTPUT_DIR}/cross.log

# The log file will be cleared each time you run ktest.
CLEAR_LOG = 1

# As some archs do not build with the defconfig, they have been marked
# to be ignored. If you want to test them anyway, change DO_FAILED to one.
# If a test that has been marked as DO_FAILED passes, then you should change
# that test to be DO_DEFAULT

DO_FAILED := 0
DO_DEFAULT := 1

# By setting both DO_FAILED and DO_DEFAULT to zero, you can pick a single
# arch that you want to test. (uncomment RUN and chose your arch)
#RUN := m32r

# At the bottom of the config file exists a bisect test. You can update that
# test and set DO_FAILED and DO_DEFAULT to zero, and uncomment this variable
# to run the bisect on the arch.
#RUN := bisect

# By default all tests will be running gcc 4.5.2. Some tests are using 4.5.1
# and they select that in the test.
# Note: GCC_VER is declared as on option and not a variable ('=' istead of ':=')
# This is important. A variable is used only in the config file and if it is set
# it stays that way for the rest of the config file until it is change again.
# Here we want GCC_VER to remain persistent throughout the tests, as it is used in
# the MAKE_CMD. By using '=' instead of ':=' we achieve our goal.

GCC_VER = 4.5.2
MAKE_CMD = PATH=/usr/local/gcc-${GCC_VER}-nolibc/${CROSS}/bin:$PATH CROSS_COMPILE=${CROSS}- make ARCH=${ARCH}

# all tests are only doing builds.
TEST_TYPE = build

# If you want to add configs on top of the defconfig, you can add those configs into
# the add-config file and uncomment this option. This is useful if you want to test
# all cross compiles with PREEMPT set, or TRACING on, etc.
#ADD_CONFIG = ${THIS_DIR}/add-config

# All tests are using defconfig
BUILD_TYPE = defconfig

# The test names will have the arch and cross compiler used. This will be shown in
# the results.
TEST_NAME = ${ARCH} ${CROSS}

# alpha
TEST_START IF ${RUN} == alpha || ${DO_DEFAULT}
CROSS = alpha-linux
ARCH = alpha

# arm
TEST_START IF ${RUN} == arm || ${DO_DEFAULT}
CROSS = arm-unknown-linux-gnueabi
ARCH = arm

# black fin
TEST_START IF ${RUN} == bfin || ${DO_DEFAULT}
CROSS = bfin-uclinux
ARCH = blackfin
BUILD_OPTIONS = -j8 vmlinux

# cris - FAILS?
TEST_START IF ${RUN} == cris || ${RUN} == cris64 || ${DO_FAILED}
CROSS = cris-linux
ARCH = cris

# cris32 - not right arch?
TEST_START IF ${RUN} == cris || ${RUN} == cris32 || ${DO_FAILED}
CROSS = crisv32-linux
ARCH = cris

# ia64
TEST_START IF ${RUN} == ia64 || ${DO_DEFAULT}
CROSS = ia64-linux
ARCH = ia64

# frv
TEST_START IF ${RUN} == frv || ${DO_FAILED}
CROSS = frv-linux
ARCH = frv
GCC_VER = 4.5.1

# h8300 - failed make defconfig??
TEST_START IF ${RUN} == h8300 || ${DO_FAILED}
CROSS = h8300-elf
ARCH = h8300
GCC_VER = 4.5.1

# m68k fails with error?
TEST_START IF ${RUN} == m68k || ${DO_DEFAULT}
CROSS = m68k-linux
ARCH = m68k

# mips64
TEST_START IF ${RUN} == mips || ${RUN} == mips64 || ${DO_DEFAULT}
CROSS = mips64-linux
ARCH = mips

# mips32
TEST_START IF ${RUN} == mips || ${RUN} == mips32 || ${DO_DEFAULT}
CROSS = mips-linux
ARCH = mips

# m32r
TEST_START IF ${RUN} == m32r || ${DO_FAILED}
CROSS = m32r-linux
ARCH = m32r
GCC_VER = 4.5.1
BUILD_OPTIONS = -j8 vmlinux

# parisc64 failed?
TEST_START IF ${RUN} == hppa || ${RUN} == hppa64 || ${DO_FAILED}
CROSS = hppa64-linux
ARCH = parisc

# parisc
TEST_START IF ${RUN} == hppa || ${RUN} == hppa32 || ${DO_FAILED}
CROSS = hppa-linux
ARCH = parisc

# ppc
TEST_START IF ${RUN} == ppc || ${RUN} == ppc32 || ${DO_DEFAULT}
CROSS = powerpc-linux
ARCH = powerpc

# ppc64
TEST_START IF ${RUN} == ppc || ${RUN} == ppc64 || ${DO_DEFAULT}
CROSS = powerpc64-linux
ARCH = powerpc

# s390
TEST_START IF ${RUN} == s390 || ${DO_DEFAULT}
CROSS = s390x-linux
ARCH = s390

# sh
TEST_START IF ${RUN} == sh || ${DO_DEFAULT}
CROSS = sh4-linux
ARCH = sh

# sparc64
TEST_START IF ${RUN} == sparc || ${RUN} == sparc64 || ${DO_DEFAULT}
CROSS = sparc64-linux
ARCH = sparc64

# sparc
TEST_START IF ${RUN} == sparc || ${RUN} == sparc32 || ${DO_DEFAULT}
CROSS = sparc-linux
ARCH = sparc

# xtensa failed
TEST_START IF ${RUN} == xtensa || ${DO_FAILED}
CROSS = xtensa-linux
ARCH = xtensa

# UML
TEST_START IF ${RUN} == uml || ${DO_DEFAULT}
MAKE_CMD = make ARCH=um SUBARCH=x86_64
ARCH = uml
CROSS =

TEST_START IF ${RUN} == x86 || ${RUN} == i386 || ${DO_DEFAULT}
MAKE_CMD = make ARCH=i386
ARCH = i386
CROSS = 

TEST_START IF ${RUN} == x86 || ${RUN} == x86_64 || ${DO_DEFAULT}
MAKE_CMD = make ARCH=x86_64
ARCH = x86_64
CROSS = 

#################################

# This is a bisect if needed. You need to give it a MIN_CONFIG that
# will be the config file it uses. Basically, just copy the created defconfig
# for the arch someplace and point MIN_CONFIG to it.
TEST_START IF ${RUN} == bisect
MIN_CONFIG = ${THIS_DIR}/min-config
CROSS = s390x-linux
ARCH = s390
TEST_TYPE = bisect
BISECT_TYPE = build
BISECT_GOOD = v3.1
BISECT_BAD = v3.2
CHECKOUT = v3.2

#################################

# These defaults are needed to keep ktest.pl from complaining. They are
# ignored because the test does not go pass the build. No install or
# booting of the target images.

DEFAULTS
MACHINE = crosstest
SSH_USER = root
BUILD_TARGET = cross
TARGET_IMAGE = image
POWER_CYCLE = cycle
CONSOLE = console
LOCALVERSION = version
GRUB_MENU = grub

REBOOT_ON_ERROR = 0
POWEROFF_ON_ERROR = 0
POWEROFF_ON_SUCCESS = 0
REBOOT_ON_SUCCESS = 0


--=-8qGVCY1VH4LhVrgi42O5--

