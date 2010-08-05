Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab0HEOkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:40:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:41640 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933403Ab0HEOka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:40:30 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 9/9] kgdb,docs: Update the kgdb docs to include kms
Date: Thu,  5 Aug 2010 09:39:58 -0500
Message-Id: <1281019198-6777-10-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019198-6777-9-git-send-email-jason.wessel@windriver.com>
References: <1281019198-6777-1-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-2-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-3-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-4-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-5-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-6-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-7-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-8-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-9-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:40:11.0389 (UTC) FILETIME=[1BB272D0:01CB34AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the kgdb docs to include information about kernel mode setting support.

[Randy Dunlap <rdunlap@xenotime.net>: grammatical corrections]

CC: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/DocBook/kgdb.tmpl     |  108 ++++++++++++++++++++++++++++++++---
 Documentation/kernel-parameters.txt |    9 ++-
 2 files changed, 106 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index 55f12ac..7150027 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -199,10 +199,33 @@
    may be configured as a kernel built-in or a kernel loadable module.
    You can only make use of <constant>kgdbwait</constant> and early
    debugging if you build kgdboc into the kernel as a built-in.
+   <para>Optionally you can elect to activate kms (Kernel Mode
+   Setting) integration.  When you use kms with kgdboc and you have a
+   video driver that has atomic mode setting hooks, it is possible to
+   enter the debugger on the graphics console.  When the kernel
+   execution is resumed, the previous graphics mode will be restored.
+   This integration can serve as a useful tool to aid in diagnosing
+   crashes or doing analysis of memory with kdb while allowing the
+   full graphics console applications to run.
+   </para>
    </para>
    <sect2 id="kgdbocArgs">
    <title>kgdboc arguments</title>
-   <para>Usage: <constant>kgdboc=[kbd][[,]serial_device][,baud]</constant></para>
+   <para>Usage: <constant>kgdboc=[kms][[,]kbd][[,]serial_device][,baud]</constant></para>
+   <para>The order listed above must be observed if you use any of the
+   optional configurations together.
+   </para>
+   <para>Abbreviations:
+   <itemizedlist>
+   <listitem><para>kms = Kernel Mode Setting</para></listitem>
+   <listitem><para>kbd = Keyboard</para></listitem>
+   </itemizedlist>
+   </para>
+   <para>You can configure kgdboc to use the keyboard, and or a serial
+   device depending on if you are using kdb and or kgdb, in one of the
+   following scenarios.  The order listed above must be observed if
+   you use any of the optional configurations together.  Using kms +
+   only gdb is generally not a useful combination.</para>
    <sect3 id="kgdbocArgs1">
    <title>Using loadable module or built-in</title>
    <para>
@@ -212,7 +235,7 @@
    <listitem>
    <para>As a kernel loadable module:</para>
    <para>Use the command: <constant>modprobe kgdboc kgdboc=&lt;tty-device&gt;,[baud]</constant></para>
-   <para>Here are two examples of how you might formate the kgdboc
+   <para>Here are two examples of how you might format the kgdboc
    string. The first is for an x86 target using the first serial port.
    The second example is for the ARM Versatile AB using the second
    serial port.
@@ -240,6 +263,9 @@
    </sect3>
    <sect3 id="kgdbocArgs3">
    <title>More examples</title>
+   <para>You can configure kgdboc to use the keyboard, and or a serial
+   device depending on if you are using kdb and or kgdb, in one of the
+   following scenarios.</para>
    <para>You can configure kgdboc to use the keyboard, and or a serial device
    depending on if you are using kdb and or kgdb, in one of the
    following scenarios.
@@ -255,6 +281,12 @@
    <listitem><para>kdb with a keyboard</para>
    <para><constant>kgdboc=kbd</constant></para>
    </listitem>
+   <listitem><para>kdb with kernel mode setting</para>
+   <para><constant>kgdboc=kms,kbd</constant></para>
+   </listitem>
+   <listitem><para>kdb with kernel mode setting and kgdb over a serial port</para>
+   <para><constant>kgdboc=kbd,kbd,ttyS0,115200</constant></para>
+   </listitem>
    </orderedlist>
    </para>
    </sect3>
@@ -637,6 +669,8 @@ Task Addr       Pid   Parent [*] cpu State Thread     Command
       <listitem><para>The logic to perform safe memory reads and writes to memory while using the debugger</para></listitem>
       <listitem><para>A full implementation for software breakpoints unless overridden by the arch</para></listitem>
       <listitem><para>The API to invoke either the kdb or kgdb frontend to the debug core.</para></listitem>
+      <listitem><para>The structures and callback API for atomic kernel mode setting.</para>
+      <para>NOTE: kgdboc is where the kms callbacks are invoked.</para></listitem>
       </itemizedlist>
       </para>
       </listitem>
@@ -747,6 +781,8 @@ Task Addr       Pid   Parent [*] cpu State Thread     Command
   </sect1>
   <sect1 id="kgdbocDesign">
   <title>kgdboc internals</title>
+  <sect2>
+  <title>kgdboc and uarts</title>
   <para>
   The kgdboc driver is actually a very thin driver that relies on the
   underlying low level to the hardware driver having "polling hooks"
@@ -754,11 +790,8 @@ Task Addr       Pid   Parent [*] cpu State Thread     Command
   implementation of kgdboc it the serial_core was changed to expose a
   low level UART hook for doing polled mode reading and writing of a
   single character while in an atomic context.  When kgdb makes an I/O
-  request to the debugger, kgdboc invokes a call back in the serial
-  core which in turn uses the call back in the UART driver.  It is
-  certainly possible to extend kgdboc to work with non-UART based
-  consoles in the future.
-  </para>
+  request to the debugger, kgdboc invokes a callback in the serial
+  core which in turn uses the callback in the UART driver.</para>
   <para>
   When using kgdboc with a UART, the UART driver must implement two callbacks in the <constant>struct uart_ops</constant>. Example from drivers/8250.c:<programlisting>
 #ifdef CONFIG_CONSOLE_POLL
@@ -772,9 +805,68 @@ Task Addr       Pid   Parent [*] cpu State Thread     Command
   that they can be called from an atomic context and have to restore
   the state of the UART chip on return such that the system can return
   to normal when the debugger detaches.  You need to be very careful
-  with any kind of lock you consider, because failing here is most
+  with any kind of lock you consider, because failing here is most likely
   going to mean pressing the reset button.
   </para>
+  </sect2>
+  <sect2 id="kgdbocKbd">
+  <title>kgdboc and keyboards</title>
+  <para>The kgdboc driver contains logic to configure communications
+  with an attached keyboard.  The keyboard infrastructure is only
+  compiled into the kernel when CONFIG_KDB_KEYBOARD=y is set in the
+  kernel configuration.</para>
+  <para>The core polled keyboard driver driver for PS/2 type keyboards
+  is in drivers/char/kdb_keyboard.c.  This driver is hooked into the
+  debug core when kgdboc populates the callback in the array
+  called <constant>kdb_poll_funcs[]</constant>.  The
+  kdb_get_kbd_char() is the top-level function which polls hardware
+  for single character input.
+  </para>
+  </sect2>
+  <sect2 id="kgdbocKms">
+  <title>kgdboc and kms</title>
+  <para>The kgdboc driver contains logic to request the graphics
+  display to switch to a text context when you are using
+  "kgdboc=kms,kbd", provided that you have a video driver which has a
+  frame buffer console and atomic kernel mode setting support.</para>
+  <para>
+  Every time the kernel
+  debugger is entered it calls kgdboc_pre_exp_handler() which in turn
+  calls con_debug_enter() in the virtual console layer.  On resuming kernel
+  execution, the kernel debugger calls kgdboc_post_exp_handler() which
+  in turn calls con_debug_leave().</para>
+  <para>Any video driver that wants to be compatible with the kernel
+  debugger and the atomic kms callbacks must implement the
+  mode_set_base_atomic, fb_debug_enter and fb_debug_leave operations.
+  For the fb_debug_enter and fb_debug_leave the option exists to use
+  the generic drm fb helper functions or implement something custom for
+  the hardware.  The following example shows the initialization of the
+  .mode_set_base_atomic operation in
+  drivers/gpu/drm/i915/intel_display.c:
+  <informalexample>
+  <programlisting>
+static const struct drm_crtc_helper_funcs intel_helper_funcs = {
+[...]
+        .mode_set_base_atomic = intel_pipe_set_base_atomic,
+[...]
+};
+  </programlisting>
+  </informalexample>
+  </para>
+  <para>Here is an example of how the i915 driver initializes the fb_debug_enter and fb_debug_leave functions to use the generic drm helpers in
+  drivers/gpu/drm/i915/intel_fb.c:
+  <informalexample>
+  <programlisting>
+static struct fb_ops intelfb_ops = {
+[...]
+       .fb_debug_enter = drm_fb_helper_debug_enter,
+       .fb_debug_leave = drm_fb_helper_debug_leave,
+[...]
+};
+  </programlisting>
+  </informalexample>
+  </para>
+  </sect2>
   </sect1>
   </chapter>
   <chapter id="credits">
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2b2407d..0e4f39f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1143,9 +1143,12 @@ and is between 256 and 4096 characters. It is defined in the file
 	kgdboc=		[KGDB,HW] kgdb over consoles.
 			Requires a tty driver that supports console polling,
 			or a supported polling keyboard driver (non-usb).
-			Serial only format: <serial_device>[,baud]
-			keyboard only format: kbd
-			keyboard and serial format: kbd,<serial_device>[,baud]
+			 Serial only format: <serial_device>[,baud]
+			 keyboard only format: kbd
+			 keyboard and serial format: kbd,<serial_device>[,baud]
+			Optional Kernel mode setting:
+			 kms, kbd format: kms,kbd
+			 kms, kbd and serial format: kms,kbd,<ser_dev>[,baud]
 
 	kgdbwait	[KGDB] Stop kernel execution and enter the
 			kernel debugger at the earliest opportunity.
-- 
1.6.4.rc1

