Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1LFVxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:53:33 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65384 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab1LFVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:53:32 -0500
MIME-Version: 1.0
Date: Tue, 6 Dec 2011 22:53:31 +0100
Message-ID: <CAGPN=9RuzrOjSt7PkxgdZC7xgUy-y5hsoRJGRoA557uEeXdK3Q@mail.gmail.com>
Subject: i915: "GPU hung" with secondary HDMI display on 3.1.4
From: Patrik Kullman <patrik.kullman@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Using the Ubuntu 3.1.4 kernel, I was using the micro-HDMI output to
connect to an LCD TV as a secondary display with audio.
I used the HDMI 5.1 profile on the sound card and watched a movie.

During the movie, X crashed and restarted to the login screen, I
logged in, and hardware acceleration was lost.

These were the last messages in dmesg:

[11824.495144] CPU0: Package power limit notification (total events = 33293)
[11824.495148] CPU2: Package power limit notification (total events = 33293)
[11824.495153] CPU3: Package power limit notification (total events = 33293)
[11824.495156] CPU1: Package power limit notification (total events = 33293)
[11824.506142] CPU1: Package power limit normal
[11824.506146] CPU3: Package power limit normal
[11824.506153] CPU2: Package power limit normal
[11824.506157] CPU0: Package power limit normal
[12124.499939] CPU3: Package power limit notification (total events = 35713)
[12124.499944] CPU1: Package power limit notification (total events = 35713)
[12124.499949] CPU0: Package power limit notification (total events = 35713)
[12124.499954] CPU2: Package power limit notification (total events = 35713)
[12124.510957] CPU0: Package power limit normal
[12124.510963] CPU1: Package power limit normal
[12124.510968] CPU2: Package power limit normal
[12124.510972] CPU3: Package power limit normal
[12246.453334] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
elapsed... GPU hung
[12246.453346] [drm] capturing error event; look for more information
in /debug/dri/0/i915_error_state
[12246.457795] [drm:i915_wait_request] *ERROR* i915_wait_request
returns -11 (awaiting 5810478 at 5810475, next 5810479)

Xorg.log:

[ 12250.303] (EE) intel(0): Detected a hung GPU, disabling acceleration.
[ 12250.305] (EE) intel(0): When reporting this, please include
i915_error_state from debugfs and the full dmesg.
[ 12250.462]
Backtrace:
[ 12250.463] 0: /usr/bin/X (xorg_backtrace+0x26) [0x460566]
[ 12250.463] 1: /usr/bin/X (0x400000+0x64b7a) [0x464b7a]
[ 12250.463] 2: /lib/x86_64-linux-gnu/libpthread.so.0
(0x7f5ceeece000+0x10060) [0x7f5ceeede060]
[ 12250.463] 3: /usr/bin/X (0x400000+0x3eeb5) [0x43eeb5]
[ 12250.463] 4: /usr/bin/X (ProcAllowEvents+0x154) [0x43f5e4]
[ 12250.463] 5: /usr/bin/X (0x400000+0x2fb89) [0x42fb89]
[ 12250.463] 6: /usr/bin/X (0x400000+0x232fe) [0x4232fe]
[ 12250.463] 7: /lib/x86_64-linux-gnu/libc.so.6
(__libc_start_main+0xed) [0x7f5cede0a30d]
[ 12250.463] 8: /usr/bin/X (0x400000+0x235ed) [0x4235ed]
[ 12250.463] Segmentation fault at address 0x191
[ 12250.463]
Caught signal 11 (Segmentation fault). Server aborting


I can produce a full dmesg and full Xorg.log, but I didn't realize
that the debug information was under /sys/kernel/debug (DRM should
print this instead of just /debug) so that information is lost.

I will try to reproduce this, but does above information give any
indication of what might be wrong?
