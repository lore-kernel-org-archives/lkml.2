Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab2JIRna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:43:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33586 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab2JIRn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:43:28 -0400
Date: Tue, 9 Oct 2012 10:43:08 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@intel.com>
Message-ID: <tip-7747e2f4fb5fb840994613dd1474c17cddb7836b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        rostedt@goodmis.org, irina.tirdea@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        rostedt@goodmis.org, irina.tirdea@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1349678613-7045-4-git-send-email-irina.tirdea@gmail.com>
References: <1349678613-7045-4-git-send-email-irina.tirdea@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Documentation:
  add documentation on compiling for Android
Git-Commit-ID: 7747e2f4fb5fb840994613dd1474c17cddb7836b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:43:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7747e2f4fb5fb840994613dd1474c17cddb7836b
Gitweb:     http://git.kernel.org/tip/7747e2f4fb5fb840994613dd1474c17cddb7836b
Author:     Irina Tirdea <irina.tirdea@intel.com>
AuthorDate: Mon, 8 Oct 2012 09:43:28 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Oct 2012 17:44:39 -0300

Documentation: add documentation on compiling for Android

Add documentation for cross-compiling on Android including:

() instructions on how to set the Android NDK environment
() how to cross-compile perf for Android
() how to install on an Android device/emulator, set the runtime
environment and run it

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1349678613-7045-4-git-send-email-irina.tirdea@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/android.txt |   75 ++++++++++++++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/android.txt b/tools/perf/Documentation/android.txt
new file mode 100644
index 0000000..a39dbbb
--- /dev/null
+++ b/tools/perf/Documentation/android.txt
@@ -0,0 +1,75 @@
+How to compile perf for Android
+=========================================
+
+I. Set the Android NDK environment
+------------------------------------------------
+
+(a). Use the Android NDK
+------------------------------------------------
+1. You need to download and install the Android Native Development Kit (NDK).
+Set the NDK variable to point to the path where you installed the NDK:
+  export NDK=/path/to/android-ndk
+
+2. Set cross-compiling environment variables for NDK toolchain and sysroot.
+For arm:
+  export NDK_TOOLCHAIN=${NDK}/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86/bin/arm-linux-androideabi-
+  export NDK_SYSROOT=${NDK}/platforms/android-9/arch-arm
+For x86:
+  export NDK_TOOLCHAIN=${NDK}/toolchains/x86-4.6/prebuilt/linux-x86/bin/i686-linux-android-
+  export NDK_SYSROOT=${NDK}/platforms/android-9/arch-x86
+
+This method is not working for Android NDK versions up to Revision 8b.
+perf uses some bionic enhancements that are not included in these NDK versions.
+You can use method (b) described below instead.
+
+(b). Use the Android source tree
+-----------------------------------------------
+1. Download the master branch of the Android source tree.
+Set the environment for the target you want using:
+  source build/envsetup.sh
+  lunch
+
+2. Build your own NDK sysroot to contain latest bionic changes and set the
+NDK sysroot environment variable.
+  cd ${ANDROID_BUILD_TOP}/ndk
+For arm:
+  ./build/tools/build-ndk-sysroot.sh --abi=arm
+  export NDK_SYSROOT=${ANDROID_BUILD_TOP}/ndk/build/platforms/android-3/arch-arm
+For x86:
+  ./build/tools/build-ndk-sysroot.sh --abi=x86
+  export NDK_SYSROOT=${ANDROID_BUILD_TOP}/ndk/build/platforms/android-3/arch-x86
+
+3. Set the NDK toolchain environment variable.
+For arm:
+  export NDK_TOOLCHAIN=${ANDROID_TOOLCHAIN}/arm-linux-androideabi-
+For x86:
+  export NDK_TOOLCHAIN=${ANDROID_TOOLCHAIN}/i686-linux-android-
+
+II. Compile perf for Android
+------------------------------------------------
+You need to run make with the NDK toolchain and sysroot defined above:
+  make CROSS_COMPILE=${NDK_TOOLCHAIN} CFLAGS="--sysroot=${NDK_SYSROOT}"
+
+III. Install perf
+-----------------------------------------------
+You need to connect to your Android device/emulator using adb.
+Install perf using:
+  adb push perf /data/perf
+
+If you also want to use perf-archive you need busybox tools for Android.
+For installing perf-archive, you first need to replace #!/bin/bash with #!/system/bin/sh:
+  sed 's/#!\/bin\/bash/#!\/system\/bin\/sh/g' perf-archive >> /tmp/perf-archive
+  chmod +x /tmp/perf-archive
+  adb push /tmp/perf-archive /data/perf-archive
+
+IV. Environment settings for running perf
+------------------------------------------------
+Some perf features need environment variables to run properly.
+You need to set these before running perf on the target:
+  adb shell
+  # PERF_PAGER=cat
+
+IV. Run perf
+------------------------------------------------
+Run perf on your device/emulator to which you previously connected using adb:
+  # ./data/perf
