Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab0CYM3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:29:13 -0400
Received: from lucidpixels.com ([75.144.35.66]:38687 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab0CYM3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:29:06 -0400
Date: Thu, 25 Mar 2010 08:29:03 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       xorg@lists.freedesktop.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME failed:
 Inappropriate ioctl for device / PreInit returned NULL
Message-ID: <alpine.DEB.2.00.1003250800200.13307@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Distribution: Debian Testing (32-bit)
Kernel: 2.6.33
Xorg: 7.5+3

Short:
When I move the mouse cursor for 1-5 minutes, khubd and Xorg go to D-state.

Long:
I have a 2.6.33 host with a USB keyboard and mouse.  When I use X for a while, 
the mouse cursor stops working.  I can continue to use X with the keyboard 
only; but the mouse is dead.  However, when this occurs, you cannot switch 
to the console, if you try to then everything seems to lockup on the console,
meaning you cannot get to the terminal and Xorg stops refreshing.  The end 
results is Xorg/khubd locks up in D-state and I have to reboot to get my 
desktop back if I want to use the host locally.  The problem seems to happen 
when moving the mouse on the screen after about 1-5 minutes.

Processes:
$ ps auxww | grep ' D '
root       295  0.0  0.0      0     0 ?        D    Mar23   0:00 [khubd]
root      2069  0.0  2.1  50060 43700 tty7     Ds+  Mar23   0:24 /usr/bin/X :0 vt7 -nolisten tcp -auth /var/lib/xdm/authdir/authfiles/A:0-1bFbuu

Kernel configuration:
http://home.comcast.net/~jpiszcz/20100325/config-2.6.33-desktop.txt

>From the Xorg.log:

(**) Option "xkb_options" "terminate:ctrl_alt_bksp"
(II) config/udev: Adding input device "Logitech USB Optical Mouse" (/dev/input/event4)
(**) "Logitech USB Optical Mouse": always reports core events
(**) "Logitech USB Optical Mouse": Device: "/dev/input/event4"
(II) "Logitech USB Optical Mouse": Found 3 mouse buttons
(II) "Logitech USB Optical Mouse": Found scroll wheel(s)
(II) "Logitech USB Optical Mouse": Found relative axes
(II) "Logitech USB Optical Mouse": Found x and y relative axes
(II) "Logitech USB Optical Mouse": Configuring as mouse
(**) "Logitech USB Optical Mouse": YAxisMapping: buttons 4 and 5
(**) "Logitech USB Optical Mouse": EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
(II) XINPUT: Adding extended input device ""Logitech USB Optical Mouse"" (type: MOUSE)
(**) "Logitech USB Optical Mouse": (accel) keeping acceleration scheme 1
(**) "Logitech USB Optical Mouse": (accel) acceleration profile 0
(II) "Logitech USB Optical Mouse": initialized for relative axes.
(II) config/udev: Adding input device "Logitech USB Optical Mouse" (/dev/input/mouse0)
(**) "Logitech USB Optical Mouse": always reports core events
(**) "Logitech USB Optical Mouse": Device: "/dev/input/mouse0"
(EE) ioctl EVIOCGNAME failed: Inappropriate ioctl for device
(II) UnloadModule: "evdev"
(EE) PreInit returned NULL for ""Logitech USB Optical Mouse""

The kernel log:

[169320.290277] INFO: task Xorg:2069 blocked for more than 120 seconds.
[169320.290281] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[169320.290283] Xorg          D f6b81f04     0  2069   2053 0x00400004
[169320.290287]  f6643480 00203082 00000002 f6b81f04 c3003324 00000000 00000000 f6643480
[169320.290292]  c13d2a80 00000000 c156a480 c1567324 c1564000 f71498dc 00203292 0a109757
[169320.290296]  fffffffe 00203292 f6643604 f6643480 f7149800 fffffffe c12f3850 c122b10f
[169320.290300] Call Trace:
[169320.290308]  [<c12f3850>] ? unlink1+0x30/0xd0
[169320.290313]  [<c122b10f>] ? kobject_get+0xf/0x20
[169320.290316]  [<c12f4cdd>] ? usb_kill_urb+0x5d/0x90
[169320.290319]  [<c105f080>] ? autoremove_wake_function+0x0/0x40
[169320.290323]  [<c133024e>] ? usbhid_close+0x6e/0x80
[169320.290326]  [<c1329413>] ? hidinput_close+0x13/0x20
[169320.290328]  [<c13119f6>] ? input_close_device+0x46/0x70
[169320.290331]  [<c1315140>] ? evdev_release+0x80/0xa0
[169320.290335]  [<c10a8c07>] ? __fput+0xc7/0x1b0
[169320.290337]  [<c10a5b47>] ? filp_close+0x47/0x80
[169320.290339]  [<c10a5bd8>] ? sys_close+0x58/0x90
[169320.290342]  [<c1023610>] ? sysenter_do_call+0x12/0x26
[169339.675813] usb 2-5: USB disconnect, address 2

I tried unplugging the mouse/plugging it back in, to no avail, everything was
still completely frozen on the console.  Although I could SSH in/etc without
any problems..

Below is the t & w output to sysrq-trigger and xorg.conf posted at the 
bottom:

# echo t > /proc/sysrq-trigger

Mar 25 08:05:02 desktop kernel: 5254]  [<c10594c5>] ? sys_kill+0x85/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10bcdb5>] ? mntput_no_expire+0x15/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1056c9d>] ? do_sigaction+0x7d/0x1a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c64f9>] ? do_utimes+0x99/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f323bf10     0 20578  20577 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f5231400 00000086 00000002 f323bf10 c3003324 00000000 c1042298 00000296
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 0000540f bffaafd0 00bcb11e
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f391cd4c f5231584 f5231400 bffaafd0 0000540f c1277c90 c10b3dfb
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277c90>] ? tty_ioctl+0x0/0x7d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b3dfb>] ? vfs_ioctl+0x2b/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] screen        S f319faf0     0 20604      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3080400 00000086 00000002 f319faf0 c3203324 00000000 00000000 00000086
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055440 7fffffff 00c9c943
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 c13c956a f3080584 f3080400 f3080400 00000000 00000001 f3080400
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13c956a>] ? wait_for_common+0x9a/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12cbdae>] ? tg3_start_xmit+0x53e/0x600
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1124ad1>] ? __ext4_handle_dirty_metadata+0x71/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c110c6c1>] ? ext4_mark_iloc_dirty+0x221/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c110d877>] ? ext4_mark_inode_dirty+0x67/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c7fe0>] ? block_write_end+0x40/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c111d6c4>] ? __ext4_journal_stop+0x54/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c11130d0>] ? ext4_da_write_end+0x120/0x330
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1136e95>] ? do_get_write_access+0x2b5/0x3c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1124ad1>] ? __ext4_handle_dirty_metadata+0x71/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10577b0>] ? signal_wake_up+0x20/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058189>] ? T.680+0x139/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058fd0>] ? do_send_sig_info+0x60/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1059274>] ? group_send_sig_info+0x34/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10592bc>] ? kill_pid_info+0x2c/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10594c5>] ? sys_kill+0x85/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10bcdb5>] ? mntput_no_expire+0x15/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1056c9d>] ? do_sigaction+0x7d/0x1a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c64f9>] ? do_utimes+0x99/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f3273f10     0 20605  20604 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1c59030 00000086 00000002 f3273f10 c3003324 00000000 c1042298 00000296
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 0000540f bfb5ee50 00b9177e
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f30e82cc f1c591b4 f1c59030 bfb5ee50 0000540f c1277c90 c10b3dfb
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277c90>] ? tty_ioctl+0x0/0x7d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b3dfb>] ? vfs_ioctl+0x2b/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] screen        S f1d0baf0     0 20701      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f61f2b20 00000086 00000002 f1d0baf0 c3203324 00000000 00000000 00000086
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 7fffffff 00c9d31f
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 c13c956a f61f2ca4 f61f2b20 f61f2b20 00000000 00000001 f61f2b20
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13c956a>] ? wait_for_common+0x9a/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c107f46d>] ? find_get_page+0x1d/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c7495>] ? __find_get_block_slow+0xb5/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1136e95>] ? do_get_write_access+0x2b5/0x3c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1124ad1>] ? __ext4_handle_dirty_metadata+0x71/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10577b0>] ? signal_wake_up+0x20/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058189>] ? T.680+0x139/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058fd0>] ? do_send_sig_info+0x60/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1059274>] ? group_send_sig_info+0x34/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10592bc>] ? kill_pid_info+0x2c/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10594c5>] ? sys_kill+0x85/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10bcdb5>] ? mntput_no_expire+0x15/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1056c9d>] ? do_sigaction+0x7d/0x1a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c64f9>] ? do_utimes+0x99/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f33e5f10     0 20702  20701 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1d25440 00000082 00000002 f33e5f10 c3003324 00000000 c1042298 00000296
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 0000540f bfad9e40 00bf8b70
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f6a7d518 f1d255c4 f1d25440 bfad9e40 0000540f c1277c90 c10b3dfb
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277c90>] ? tty_ioctl+0x0/0x7d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b3dfb>] ? vfs_ioctl+0x2b/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] screen        S f32e5af0     0 20763      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f31c2170 00000082 00000002 f32e5af0 c3203324 00000000 00000000 00000086
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055440 7fffffff 00c9d6ef
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 c13c956a f31c22f4 f31c2170 f31c2170 00000000 00000001 f31c2170
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13c956a>] ? wait_for_common+0x9a/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12cbdae>] ? tg3_start_xmit+0x53e/0x600
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1124ad1>] ? __ext4_handle_dirty_metadata+0x71/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c110c6c1>] ? ext4_mark_iloc_dirty+0x221/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c110d877>] ? ext4_mark_inode_dirty+0x67/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c7fe0>] ? block_write_end+0x40/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c111d6c4>] ? __ext4_journal_stop+0x54/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c11130d0>] ? ext4_da_write_end+0x120/0x330
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1136e95>] ? do_get_write_access+0x2b5/0x3c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1124ad1>] ? __ext4_handle_dirty_metadata+0x71/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10577b0>] ? signal_wake_up+0x20/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058189>] ? T.680+0x139/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058fd0>] ? do_send_sig_info+0x60/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1059274>] ? group_send_sig_info+0x34/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10592bc>] ? kill_pid_info+0x2c/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10594c5>] ? sys_kill+0x85/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10bcdb5>] ? mntput_no_expire+0x15/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1056c9d>] ? do_sigaction+0x7d/0x1a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c64f9>] ? do_utimes+0x99/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f3015f10     0 20764  20763 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3a770b0 00000086 00000002 f3015f10 c3003324 00000000 c1042298 00000296
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 0000540f bf947e80 00bad0ae
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f3991128 f3a77234 f3a770b0 bf947e80 0000540f c1277c90 c10b3dfb
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277c90>] ? tty_ioctl+0x0/0x7d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b3dfb>] ? vfs_ioctl+0x2b/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] screen        S f3367af0     0 20897      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f62810f0 00000082 00000002 f3367af0 c3003324 00000000 00000000 00000086
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 7fffffff 00c9db24
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 c13c956a f6281274 f62810f0 f62810f0 00000000 00000001 f62810f0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13c956a>] ? wait_for_common+0x9a/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1084832>] ? get_page_from_freelist+0x242/0x4c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1084832>] ? get_page_from_freelist+0x242/0x4c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c107f46d>] ? find_get_page+0x1d/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c7495>] ? __find_get_block_slow+0xb5/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1136e95>] ? do_get_write_access+0x2b5/0x3c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10577b0>] ? signal_wake_up+0x20/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058189>] ? T.680+0x139/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058fd0>] ? do_send_sig_info+0x60/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1059274>] ? group_send_sig_info+0x34/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10592bc>] ? kill_pid_info+0x2c/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10594c5>] ? sys_kill+0x85/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10bcdb5>] ? mntput_no_expire+0x15/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1056c9d>] ? do_sigaction+0x7d/0x1a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c64f9>] ? do_utimes+0x99/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f3883f10     0 20898  20897 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3308480 00000082 00000002 f3883f10 c3203324 00000000 c1042298 00000296
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 0000540f bfe9d780 00c2bda1
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f32a956c f3308604 f3308480 bfe9d780 0000540f c1277c90 c10b3dfb
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277c90>] ? tty_ioctl+0x0/0x7d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b3dfb>] ? vfs_ioctl+0x2b/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] screen        S f38a9af0     0 21079      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3980be0 00000086 00000002 f38a9af0 c3003324 00000000 00000000 00000086
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 f70557d0 7fffffff 00c9d191
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 c13c956a f3980d64 f3980be0 f3980be0 00000000 00000001 f3980be0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13c956a>] ? wait_for_common+0x9a/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12cbdae>] ? tg3_start_xmit+0x53e/0x600
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c107f46d>] ? find_get_page+0x1d/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c7495>] ? __find_get_block_slow+0xb5/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1136e95>] ? do_get_write_access+0x2b5/0x3c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10577b0>] ? signal_wake_up+0x20/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058189>] ? T.680+0x139/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058fd0>] ? do_send_sig_info+0x60/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1059274>] ? group_send_sig_info+0x34/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10592bc>] ? kill_pid_info+0x2c/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10594c5>] ? sys_kill+0x85/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10bcdb5>] ? mntput_no_expire+0x15/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1056c9d>] ? do_sigaction+0x7d/0x1a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c64f9>] ? do_utimes+0x99/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f1ec7f10     0 21080  21079 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6039790 00000086 00000002 f1ec7f10 c3203324 00000000 c1042298 00000296
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 0000540f bf898b70 00a9c886
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f1cb4e48 f6039914 f6039790 bf898b70 0000540f c1277c90 c10b3dfb
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277c90>] ? tty_ioctl+0x0/0x7d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b3dfb>] ? vfs_ioctl+0x2b/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] screen        S f1f77af0     0 21213      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f317f170 00000086 00000002 f1f77af0 c3203324 00000000 00000000 00000086
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055440 7fffffff 00c9c473
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 c13c956a f317f2f4 f317f170 f317f170 00000000 00000001 f317f170
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13c956a>] ? wait_for_common+0x9a/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12cbdae>] ? tg3_start_xmit+0x53e/0x600
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 2 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c7495>] ? __find_get_block_slow+0xb5/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c107f46d>] ? find_get_page+0x1d/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c7495>] ? __find_get_block_slow+0xb5/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c797b>] ? __getblk+0x1b/0x320
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1136e95>] ? do_get_write_access+0x2b5/0x3c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10577b0>] ? signal_wake_up+0x20/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058189>] ? T.680+0x139/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1058fd0>] ? do_send_sig_info+0x60/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1059274>] ? group_send_sig_info+0x34/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10592bc>] ? kill_pid_info+0x2c/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10594c5>] ? sys_kill+0x85/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10bcdb5>] ? mntput_no_expire+0x15/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1056c9d>] ? do_sigaction+0x7d/0x1a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c64f9>] ? do_utimes+0x99/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f1e69f10     0 21214  21213 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6039070 00000082 00000002 f1e69f10 c3203324 00000000 c1042298 00000296
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 0000540f bff49a70 00c9a7f3
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f1cd5f98 f60391f4 f6039070 bff49a70 0000540f c1277c90 c10b3dfb
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277c90>] ? tty_ioctl+0x0/0x7d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b3dfb>] ? vfs_ioctl+0x2b/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f1e5daf0     0 21424  20330 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f303e790 00000086 00000002 f1e5daf0 c3203324 00000000 f1c19dd8 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 00000000 00a72d4f
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f1c19dd8 f303e914 f303e790 00000286 c1055d83 00000286 f1c19d68
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1381d8d>] ? tcp_v4_send_check+0x4d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137e485>] ? tcp_send_ack+0xb5/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f1f57af0     0 21474  20385 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f30e3440 00000082 00000002 f1f57af0 c3203324 00000000 f1c19d10 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 00000000 00a93de0
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f1c19d10 f30e35c4 f30e3440 00000286 c1055d83 00000286 f1c19ca0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1381d8d>] ? tcp_v4_send_check+0x4d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137e485>] ? tcp_send_ack+0xb5/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f1fafaf0     0 21485  21080 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f39804c0 00000086 00000002 f1fafaf0 c3003324 00000000 f523a608 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 00000000 00a9fe09
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f523a608 f3980644 f39804c0 00000286 c1055d83 00000286 f523a598
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1381d8d>] ? tcp_v4_send_check+0x4d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133f448>] ? memcpy_toiovec+0x38/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133fdfb>] ? skb_copy_datagram_iovec+0x3b/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13724df>] ? tcp_cleanup_rbuf+0xef/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f63f7af0     0 21537  20454 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3963500 00000082 00000002 f63f7af0 c3003324 00000000 f384f3b0 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 00000000 00aad96a
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f384f3b0 f3963684 f3963500 00000286 c1055d83 00000286 f384f340
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 2 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042b2e>] ? check_preempt_wakeup+0x7e/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f09b>] ? autoremove_wake_function+0x1b/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105bb52>] ? insert_work+0x42/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105c164>] ? __queue_work+0x24/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055881>] ? run_timer_softirq+0x111/0x1c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106c0c8>] ? tick_program_event+0x28/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10513b9>] ? __do_softirq+0x99/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1036714>] ? smp_apic_timer_interrupt+0x54/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cbd3a>] ? apic_timer_interrupt+0x2a/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1231e2a>] ? _copy_from_user+0x5a/0x130
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xterm         S 00000000     0 21539      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3989be0 00200082 000008b7 00000000 00009a25 004afbf8 00000000 f3989be0
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 f6aa5ba0 f3989c0c ffb50f0d
Mar 25 08:05:02 desktop kernel: [169645.245254]  ffffffff c10648d5 f3989d64 00000001 c3006480 c13d2a20 f3989be0 0019de56
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041755>] ? dequeue_task+0x65/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10447e9>] ? enqueue_task_fair+0xe9/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10357fe>] ? native_smp_send_reschedule+0x2e/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133e1af>] ? __alloc_skb+0x4f/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339813>] ? sock_alloc_send_pskb+0x163/0x280
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042505>] ? __wake_up_sync_key+0x45/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c81c>] ? skb_queue_tail+0x1c/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339371>] ? sock_def_readable+0x11/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7626>] ? do_sync_readv_writev+0xb6/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S 7070ed0a     0 21541  21539 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f38d0b60 00200086 c10648d5 7070ed0a 00009a23 c3006950 000ed5a2 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  ffffffff 00000000 c156a480 c1567324 c1564000 c3006480 00000002 c13d2a20
Mar 25 08:05:02 desktop kernel: [169645.245254]  f38d0b60 c3006480 f38d0ce4 c1048e39 f65ab000 c127c592 00000001 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127c592>] ? copy_termios+0x22/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca145>] ? schedule_timeout+0x135/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105bc52>] ? flush_work+0x22/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e1a>] ? try_to_del_timer_sync+0x4a/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a94d>] ? n_tty_read+0x43d/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12762cc>] ? tty_read+0x8c/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a510>] ? n_tty_read+0x0/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1276240>] ? tty_read+0x0/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a83cd>] ? vfs_read+0x9d/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10567dc>] ? sigprocmask+0x5c/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8551>] ? sys_read+0x41/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xterm         S f1ddfaf0     0 21558      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6281ba0 00000082 00000002 f1ddfaf0 c3003324 00000000 f1ddfae8 c3003324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f6aa5ba0 f6281bcc 0a15400c
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000400 f6281d24 f6281ba0 c3006480 c13d2a20 f6281ba0 0015796f
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10447e9>] ? enqueue_task_fair+0xe9/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10357fe>] ? native_smp_send_reschedule+0x2e/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6563>] ? pollwake+0x53/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133e1af>] ? __alloc_skb+0x4f/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339813>] ? sock_alloc_send_pskb+0x163/0x280
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a221e>] ? unix_write_space+0xe/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7626>] ? do_sync_readv_writev+0xb6/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f1f03e80     0 21560  21558 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1e3a0b0 00000082 00000002 f1f03e80 c3203324 00000000 000c2a0f 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 c3206480 00000001 0a13ac2e
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1e3a0b0 c3206480 f1e3a234 f1e3a0b0 f63f9cf0 c1041b07 00000001 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca145>] ? schedule_timeout+0x135/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105bc52>] ? flush_work+0x22/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e1a>] ? try_to_del_timer_sync+0x4a/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a94d>] ? n_tty_read+0x43d/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12762cc>] ? tty_read+0x8c/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a510>] ? n_tty_read+0x0/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1276240>] ? tty_read+0x0/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a83cd>] ? vfs_read+0x9d/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10567dc>] ? sigprocmask+0x5c/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8551>] ? sys_read+0x41/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xterm         S f1f9faf0     0 21582      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f52dbb20 00200082 00000002 f1f9faf0 c3003324 00000000 f1f9fae8 c3003324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f6aa5ba0 f52dbb4c 0a153f16
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000400 f52dbca4 f52dbb20 c3006480 c13d2a20 f52dbb20 001e2ac0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1084c74>] ? __alloc_pages_nodemask+0xe4/0x5c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10557a0>] ? run_timer_softirq+0x30/0x1c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106c0c8>] ? tick_program_event+0x28/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10513b9>] ? __do_softirq+0x99/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a2ec1>] ? cache_alloc_refill+0x91/0x4d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133e1af>] ? __alloc_skb+0x4f/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339813>] ? sock_alloc_send_pskb+0x163/0x280
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042505>] ? __wake_up_sync_key+0x45/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a221e>] ? unix_write_space+0xe/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7626>] ? do_sync_readv_writev+0xb6/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S c3003340     0 21584  21582 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f63017d0 00200082 00000400 c3003340 00000002 f1e53e7c f1e53e78 c3003324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 00000000 00000001 0994df17
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000400 f6301954 f63017d0 f3984400 c127c592 00000001 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127c592>] ? copy_termios+0x22/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca145>] ? schedule_timeout+0x135/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105bc52>] ? flush_work+0x22/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e1a>] ? try_to_del_timer_sync+0x4a/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a94d>] ? n_tty_read+0x43d/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12762cc>] ? tty_read+0x8c/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a510>] ? n_tty_read+0x0/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1276240>] ? tty_read+0x0/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a83cd>] ? vfs_read+0x9d/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10567dc>] ? sigprocmask+0x5c/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8551>] ? sys_read+0x41/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xterm         S c3003340     0 21605      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f30e3b60 00000086 00000400 c3003340 00000002 f1f43aec f1f43ae8 c3003324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 00000000 00000000 0a157ce5
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000400 f30e3ce4 f30e3b60 00000000 00000000 00000000 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1074a9a>] ? handle_fasteoi_irq+0x7a/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1062573>] ? hrtimer_forward+0x163/0x1a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1064a11>] ? sched_clock_cpu+0x61/0x150
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133e1af>] ? __alloc_skb+0x4f/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339813>] ? sock_alloc_send_pskb+0x163/0x280
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042505>] ? __wake_up_sync_key+0x45/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a221e>] ? unix_write_space+0xe/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10491ba>] ? run_rebalance_domains+0x9a/0x4f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f5135f10     0 21608  21605 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6321b20 00000086 00000002 f5135f10 c3203324 00000000 c1042298 00000296
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 0000540f bffc2680 0a1431ad
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f50ecef0 f6321ca4 f6321b20 bffc2680 0000540f c1277c90 c10b3dfb
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277c90>] ? tty_ioctl+0x0/0x7d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b3dfb>] ? vfs_ioctl+0x2b/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xterm         S f1f95af0     0 21677      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6766790 00200082 00000002 f1f95af0 c3003324 00000000 f1f95ae8 c3003324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f6aa5ba0 00000000 0a154310
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000400 f6766914 f6766790 00000000 00000000 00000000 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1024eb0>] ? do_IRQ+0x50/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1084c74>] ? __alloc_pages_nodemask+0xe4/0x5c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10447e9>] ? enqueue_task_fair+0xe9/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a2ec1>] ? cache_alloc_refill+0x91/0x4d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133e1af>] ? __alloc_skb+0x4f/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339813>] ? sock_alloc_send_pskb+0x163/0x280
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a221e>] ? unix_write_space+0xe/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7626>] ? do_sync_readv_writev+0xb6/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S c3203340     0 21680  21677 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3243440 00200082 00000400 c3203340 00000002 f1efbe7c f1efbe78 c3203324
Mar 25 08:05:02 desktop kernel: [169645.245254]  ffffffff 00000001 c156a480 c1567324 c1564000 00000400 00000001 09c4225a
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000400 f32435c4 f3243440 f6290400 c127c592 00000001 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127c592>] ? copy_termios+0x22/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca145>] ? schedule_timeout+0x135/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105bc52>] ? flush_work+0x22/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e1a>] ? try_to_del_timer_sync+0x4a/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a94d>] ? n_tty_read+0x43d/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12762cc>] ? tty_read+0x8c/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a510>] ? n_tty_read+0x0/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1276240>] ? tty_read+0x0/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a83cd>] ? vfs_read+0x9d/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10567dc>] ? sigprocmask+0x5c/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8551>] ? sys_read+0x41/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xterm         S f5023af0     0 21702      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f50580b0 00000082 00000002 f5023af0 c3003324 00000000 f5023ae8 c3203324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f6aa5ba0 c1036714 0a153ef6
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000400 f5058234 f50580b0 f39bdcc8 00000286 00000286 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1036714>] ? smp_apic_timer_interrupt+0x54/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1084c74>] ? __alloc_pages_nodemask+0xe4/0x5c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10447e9>] ? enqueue_task_fair+0xe9/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a2ec1>] ? cache_alloc_refill+0x91/0x4d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133e1af>] ? __alloc_skb+0x4f/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339813>] ? sock_alloc_send_pskb+0x163/0x280
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a221e>] ? unix_write_space+0xe/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7626>] ? do_sync_readv_writev+0xb6/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f1f6be80     0 21704  21702 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1e3b790 00000082 00000002 f1f6be80 c3003324 00000000 000ae42f 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c3006480 00000001 09bcf11c
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1e3b790 c3006480 f1e3b914 f1e3b790 f3196800 c127c592 00000001 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127c592>] ? copy_termios+0x22/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca145>] ? schedule_timeout+0x135/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105bc52>] ? flush_work+0x22/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e1a>] ? try_to_del_timer_sync+0x4a/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a94d>] ? n_tty_read+0x43d/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12762cc>] ? tty_read+0x8c/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a510>] ? n_tty_read+0x0/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1276240>] ? tty_read+0x0/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a83cd>] ? vfs_read+0x9d/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10567dc>] ? sigprocmask+0x5c/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8551>] ? sys_read+0x41/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xterm         S f1f2baf0     0 21726      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f66a3be0 00200082 00000002 f1f2baf0 c3003324 00000000 f1f2bae8 c3003324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 02570400 0a157ce5
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000400 f66a3d64 f66a3be0 c1567460 00000000 00200046 00000008
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1084c74>] ? __alloc_pages_nodemask+0xe4/0x5c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a2ec1>] ? cache_alloc_refill+0x91/0x4d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a2ec1>] ? cache_alloc_refill+0x91/0x4d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133e1af>] ? __alloc_skb+0x4f/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339813>] ? sock_alloc_send_pskb+0x163/0x280
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042505>] ? __wake_up_sync_key+0x45/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a221e>] ? unix_write_space+0xe/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7626>] ? do_sync_readv_writev+0xb6/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f63c1e80     0 21728  21726 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f503d850 00200086 00000002 f63c1e80 c3003324 00000000 000089f5 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c3006480 00000001 05bdd66a
Mar 25 08:05:02 desktop kernel: [169645.245254]  f503d850 c3006480 f503d9d4 f503d850 f334a4f0 c1041b07 00000001 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca145>] ? schedule_timeout+0x135/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105bc52>] ? flush_work+0x22/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e1a>] ? try_to_del_timer_sync+0x4a/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a94d>] ? n_tty_read+0x43d/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12762cc>] ? tty_read+0x8c/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a510>] ? n_tty_read+0x0/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1276240>] ? tty_read+0x0/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a83cd>] ? vfs_read+0x9d/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10567dc>] ? sigprocmask+0x5c/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8551>] ? sys_read+0x41/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f1f7faf0     0 22246  20605 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6321790 00000082 00000002 f1f7faf0 c3203324 00000000 00000046 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 00000000 00b94a34
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f1c64ee8 f6321914 f6321790 f1cfbf40 f33f6401 c1023b29 f33f64c8
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023b29>] ? common_interrupt+0x29/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1381d8d>] ? tcp_v4_send_check+0x4d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133f448>] ? memcpy_toiovec+0x38/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133fdfb>] ? skb_copy_datagram_iovec+0x3b/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13724df>] ? tcp_cleanup_rbuf+0xef/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f1f4baf0     0 22341  20476 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3906890 00000086 00000002 f1f4baf0 c3003324 00000000 f5233588 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 00000000 00bac642
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f5233588 f3906a14 f3906890 00000286 c1055d83 00000286 f5233518
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1381d8d>] ? tcp_v4_send_check+0x4d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133f448>] ? memcpy_toiovec+0x38/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133fdfb>] ? skb_copy_datagram_iovec+0x3b/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13724df>] ? tcp_cleanup_rbuf+0xef/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f510faf0     0 22343  20764 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f50794c0 00000082 00000002 f510faf0 c3203324 00000000 f5313b40 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 00000000 00baeb82
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f5313b40 f5079644 f50794c0 00000286 c1055d83 00000286 f5313ad0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1381d8d>] ? tcp_v4_send_check+0x4d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133f448>] ? memcpy_toiovec+0x38/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133fdfb>] ? skb_copy_datagram_iovec+0x3b/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13724df>] ? tcp_cleanup_rbuf+0xef/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f5025af0     0 22440  20578 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3072750 00000082 00000002 f5025af0 c3203324 00000000 f53139b0 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 00000000 00bccc90
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f53139b0 f30728d4 f3072750 00000286 c1055d83 00000286 f5313940
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1381d8d>] ? tcp_v4_send_check+0x4d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133f448>] ? memcpy_toiovec+0x38/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133fdfb>] ? skb_copy_datagram_iovec+0x3b/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13724df>] ? tcp_cleanup_rbuf+0xef/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f001baf0     0 22636  20702 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f303e400 00000082 00000002 f001baf0 c3203324 00000000 f508fd10 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 00000000 00bfa794
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f508fd10 f303e584 f303e400 00000286 c1055d83 00000286 f508fca0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1381d8d>] ? tcp_v4_send_check+0x4d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133f448>] ? memcpy_toiovec+0x38/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133fdfb>] ? skb_copy_datagram_iovec+0x3b/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13724df>] ? tcp_cleanup_rbuf+0xef/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f1ce3af0     0 22782  20898 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f314f480 00000086 00000002 f1ce3af0 c3003324 00000000 f321dc08 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 00000000 00c2d7c7
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f321dc08 f314f604 f314f480 00000286 c1055d83 00000286 f321db98
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1381d8d>] ? tcp_v4_send_check+0x4d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133f448>] ? memcpy_toiovec+0x38/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133fdfb>] ? skb_copy_datagram_iovec+0x3b/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13724df>] ? tcp_cleanup_rbuf+0xef/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f3349af0     0 22893  21214 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3308810 00000082 00000002 f3349af0 c3003324 00000000 f5313e60 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 00000000 00c9c166
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f5313e60 f3308994 f3308810 00000286 c1055d83 00000286 f5313df0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1381d8d>] ? tcp_v4_send_check+0x4d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133f448>] ? memcpy_toiovec+0x38/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133fdfb>] ? skb_copy_datagram_iovec+0x3b/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13724df>] ? tcp_cleanup_rbuf+0xef/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f62adaf0     0 24852   1696 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f503dbe0 00000082 00000002 f62adaf0 c3203324 00000000 f62adb18 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f62adb18 00000286 0a17618a
Mar 25 08:05:02 desktop kernel: [169645.245254]  039386fe 00000000 f503dd64 f503dbe0 c10627ed 00000000 00000286 039386fe
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10627ed>] ? __remove_hrtimer+0x2d/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa41>] ? schedule_hrtimeout_range+0xb1/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1062660>] ? hrtimer_wakeup+0x0/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055c76>] ? mod_timer+0xc6/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13393ec>] ? sk_reset_timer+0xc/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13801cb>] ? tcp_write_xmit+0x19b/0x970
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339065>] ? lock_sock_nested+0x35/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1374132>] ? tcp_sendmsg+0x7b2/0xa80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7715>] ? do_sync_write+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10674cc>] ? ktime_get_ts+0xcc/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f1c9faf0     0 28060   2305 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3906170 00000082 00000002 f1c9faf0 c3203324 00000000 00000000 00000086
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f6891ae0 7fffffff 00000286
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f380d0d8 f39062f4 f380d0d8 00000286 c1055d83 00000286 f380d068
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1359dba>] ? __nf_ct_refresh_acct+0xca/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6563>] ? pollwake+0x53/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055c76>] ? mod_timer+0xc6/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133f448>] ? memcpy_toiovec+0x38/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133fdfb>] ? skb_copy_datagram_iovec+0x3b/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339065>] ? lock_sock_nested+0x35/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f309baf0     0 28061   2286 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3be0ae0 00200082 00000002 f309baf0 c3003324 00000000 00000004 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 866f90a4 0a17d3de
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f6383608 f3be0c64 f3be0ae0 00200286 c1055d83 00200286 f6383598
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10557a0>] ? run_timer_softirq+0x30/0x1c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106c0c8>] ? tick_program_event+0x28/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055c76>] ? mod_timer+0xc6/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133f448>] ? memcpy_toiovec+0x38/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133fdfb>] ? skb_copy_datagram_iovec+0x3b/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339065>] ? lock_sock_nested+0x35/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f337>] ? remove_wait_queue+0x17/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104258e>] ? __wake_up+0x3e/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f6317af0     0 28660   4415 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f602a130 00000086 00000002 f6317af0 c3203324 00000000 c14e7540 c14e7540
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 00000014 0a173de4
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f5195690 f602a2b4 f602a130 00000286 c1055d83 00000286 f5195620
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 2 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1358426>] ? nf_iterate+0x76/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1084c74>] ? __alloc_pages_nodemask+0xe4/0x5c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055c76>] ? mod_timer+0xc6/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13393ec>] ? sk_reset_timer+0xc/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13801cb>] ? tcp_write_xmit+0x19b/0x970
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339065>] ? lock_sock_nested+0x35/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1374132>] ? tcp_sendmsg+0x7b2/0xa80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7715>] ? do_sync_write+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f1ebbaf0     0 28684   4440 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6ab10f0 00200086 00000002 f1ebbaf0 c3003324 00000000 c3b025a1 00000189
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 0000004a 0a178813
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f631a820 f6ab1274 f6ab10f0 00200286 c1055d83 00200286 f631a7b0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 2 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1358426>] ? nf_iterate+0x76/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055c76>] ? mod_timer+0xc6/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13393ec>] ? sk_reset_timer+0xc/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13801cb>] ? tcp_write_xmit+0x19b/0x970
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339065>] ? lock_sock_nested+0x35/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1374132>] ? tcp_sendmsg+0x7b2/0xa80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7715>] ? do_sync_write+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] apache2       S f1dabe3c     0  2875   1966 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f33aa850 00000082 00000002 f1dabe3c c3003324 00000000 f1e09be4 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c136bfc8 c136c1c0 04b3b134
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1e09be4 f627cc78 f33aa9d4 f33aa850 c136b275 f1c91180 c136b912 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca145>] ? schedule_timeout+0x135/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a3443>] ? kmem_cache_alloc+0x83/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339065>] ? lock_sock_nested+0x35/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8e0e>] ? get_empty_filp+0xfe/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13705df>] ? inet_csk_accept+0x16f/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f080>] ? autoremove_wake_function+0x0/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1390135>] ? inet_accept+0x25/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1337a41>] ? sys_accept4+0xe1/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1091d11>] ? __do_fault+0x311/0x420
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c107fd70>] ? filemap_fault+0x0/0x3b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1093606>] ? handle_mm_fault+0xe6/0x5b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1337f80>] ? sys_socketcall+0xb0/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xterm         S f510daf0     0 15205      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6321400 00200086 00000002 f510daf0 c3003324 00000000 f510dae8 c3003324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f6aa5ba0 00000000 0a153f22
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000400 f6321584 f6321400 00000000 00000000 00000000 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6563>] ? pollwake+0x53/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133e1af>] ? __alloc_skb+0x4f/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339813>] ? sock_alloc_send_pskb+0x163/0x280
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a221e>] ? unix_write_space+0xe/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7626>] ? do_sync_readv_writev+0xb6/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f1c63e80     0 15207  15205 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f63010b0 00200082 00000002 f1c63e80 c3003324 00000000 000bc0a2 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c3006480 00000001 0a120b30
Mar 25 08:05:02 desktop kernel: [169645.245254]  f63010b0 c3006480 f6301234 f63010b0 f50f4000 c127c592 00000001 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127c592>] ? copy_termios+0x22/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca145>] ? schedule_timeout+0x135/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105bc52>] ? flush_work+0x22/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e1a>] ? try_to_del_timer_sync+0x4a/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a94d>] ? n_tty_read+0x43d/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277ab2>] ? tty_wakeup+0x32/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12762cc>] ? tty_read+0x8c/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c127a510>] ? n_tty_read+0x0/0x740
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1276240>] ? tty_read+0x0/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a83cd>] ? vfs_read+0x9d/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10567dc>] ? sigprocmask+0x5c/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8551>] ? sys_read+0x41/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xterm         S c3003340     0 24139      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1d48130 00000082 00000400 c3003340 00000002 f38bdaec f38bdae8 c3003324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 00000000 0000000a 0a157ce5
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000400 f1d482b4 f1d48130 00000046 00000046 00000089 c1024eb0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1024eb0>] ? do_IRQ+0x50/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041d63>] ? sched_slice+0x53/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10447e9>] ? enqueue_task_fair+0xe9/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10357fe>] ? native_smp_send_reschedule+0x2e/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6563>] ? pollwake+0x53/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133e1af>] ? __alloc_skb+0x4f/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339813>] ? sock_alloc_send_pskb+0x163/0x280
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a221e>] ? unix_write_space+0xe/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7626>] ? do_sync_readv_writev+0xb6/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f506df10     0 24141  24139 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f506eb20 00000082 00000002 f506df10 c3203324 00000000 c1042298 00000296
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 0000540f bfb42050 0a10d8cb
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f31ec2cc f506eca4 f506eb20 bfb42050 0000540f c1277c90 c10b3dfb
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277c90>] ? tty_ioctl+0x0/0x7d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b3dfb>] ? vfs_ioctl+0x2b/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] smbd          S f6231af0     0  6453   1710 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1d25b60 00000082 00000002 f6231af0 c3203324 00000000 f6231b18 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f6231b18 00000286 0a17dc96
Mar 25 08:05:02 desktop kernel: [169645.245254]  039386d2 00000000 f1d25ce4 f1d25b60 00000286 00000000 00000286 039386d2
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa41>] ? schedule_hrtimeout_range+0xb1/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1062660>] ? hrtimer_wakeup+0x0/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055c76>] ? mod_timer+0xc6/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13393ec>] ? sk_reset_timer+0xc/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13801cb>] ? tcp_write_xmit+0x19b/0x970
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10c785f>] ? __find_get_block+0x8f/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1374132>] ? tcp_sendmsg+0x7b2/0xa80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13355ca>] ? sock_aio_write+0x11a/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13354b0>] ? sock_aio_write+0x0/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7626>] ? do_sync_readv_writev+0xb6/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10aabfe>] ? cp_new_stat64+0xee/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10674cc>] ? ktime_get_ts+0xcc/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] gvfs-gdu-volu S f1e0db74     0  7394      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f31c2c20 00000082 00000002 f1e0db74 c3203324 00000000 f1e0db9c 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 00000286 09fef0c4
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1e0db9c c3203590 f31c2da4 f31c2c20 c10627ed f1e0db9c 00000001 060473ad
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10627ed>] ? __remove_hrtimer+0x2d/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f3da>] ? add_wait_queue+0x1a/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f3da>] ? add_wait_queue+0x1a/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5767>] ? do_sys_poll+0x317/0x3d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 4 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1064a11>] ? sched_clock_cpu+0x61/0x150
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6563>] ? pollwake+0x53/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042505>] ? __wake_up_sync_key+0x45/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104253f>] ? __wake_up_sync+0xf/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a2247>] ? unix_write_space+0x37/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b15b9>] ? link_path_walk+0x9f9/0xb90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1335712>] ? sock_aio_read+0x122/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c109ddcb>] ? free_pages_and_swap_cache+0x7b/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a847a>] ? vfs_read+0x14a/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b59aa>] ? sys_poll+0x5a/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] devkit-disks- S c122de60     0  7396      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f7190750 00000086 f64f3b18 c122de60 00000008 c3203598 f1c6fb9c 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c3203590 00000001 c156a480 c1567324 c1564000 f1c6fb9c 00000286 c10631e8
Mar 25 08:05:02 desktop kernel: [169645.245254]  05f5e100 00000000 f71908d4 c1567560 c10627ed 00000000 00000286 05f5e100
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c122de60>] ? rb_insert_color+0x80/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10631e8>] ? __hrtimer_start_range_ns+0xf8/0x260
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10627ed>] ? __remove_hrtimer+0x2d/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10633a0>] ? hrtimer_start_range_ns+0x20/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa41>] ? schedule_hrtimeout_range+0xb1/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1062660>] ? hrtimer_wakeup+0x0/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5767>] ? do_sys_poll+0x317/0x3d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c139e752>] ? ipt_do_table+0x232/0x3a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042b2e>] ? check_preempt_wakeup+0x7e/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6563>] ? pollwake+0x53/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042505>] ? __wake_up_sync_key+0x45/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104253f>] ? __wake_up_sync+0xf/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a2247>] ? unix_write_space+0x37/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1335712>] ? sock_aio_read+0x122/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10674cc>] ? ktime_get_ts+0xcc/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b59aa>] ? sys_poll+0x5a/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] devkit-disks- S f0027b74     0  7397   7396 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f33aa130 00000082 00000002 f0027b74 c3203324 00000000 f0027b9c 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f0027b9c 00000286 0a17fe24
Mar 25 08:05:02 desktop kernel: [169645.245254]  001e74de 00000000 f33aa2b4 f33aa130 f6194580 00000000 00000286 001e74de
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa41>] ? schedule_hrtimeout_range+0xb1/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1062660>] ? hrtimer_wakeup+0x0/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5767>] ? do_sys_poll+0x317/0x3d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104456c>] ? dequeue_task_fair+0x3c/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1047394>] ? finish_task_switch+0x34/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13c99a5>] ? schedule+0x345/0x890
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12acfb6>] ? ata_qc_issue+0x1b6/0x300
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c129d79a>] ? scsi_get_cmd_from_req+0x2a/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c129dbb9>] ? scsi_setup_blk_pc_cmnd+0x39/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12b1ddd>] ? ata_scsi_translate+0x7d/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12a7afa>] ? sr_test_unit_ready+0x6a/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1297f90>] ? scsi_done+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca145>] ? schedule_timeout+0x135/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c121d94b>] ? blk_peek_request+0xdb/0x150
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1298071>] ? scsi_dispatch_cmd+0xd1/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c129d26a>] ? scsi_request_fn+0x8a/0x380
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13c956a>] ? wait_for_common+0x9a/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1221ca5>] ? blk_execute_rq+0x75/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1221b70>] ? blk_end_sync_rq+0x0/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1227a30>] ? cfq_set_request+0x0/0x330
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c121b0ff>] ? elv_set_request+0xf/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c121e885>] ? get_request+0x2c5/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c121d4bb>] ? __freed_request+0xcb/0x130
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c121d545>] ? freed_request+0x25/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c121dc49>] ? blk_put_request+0x29/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c129e56c>] ? scsi_execute+0xfc/0x130
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a3443>] ? kmem_cache_alloc+0x83/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c129908c>] ? T.690+0x4c/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12991ba>] ? scsi_set_medium_removal+0x5a/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12eaa5b>] ? cdrom_release+0x8b/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1309f9a>] ? ohci_irq+0xea/0x300
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10674cc>] ? ktime_get_ts+0xcc/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b59aa>] ? sys_poll+0x5a/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] pickup        S 00000000     0 16923   1570 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6166890 00200082 f6d1b42c 00000000 f3b43eb0 00000000 00000000 f3b43f5c
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000001 00000000 c156a480 c1567324 c1564000 f710c810 f70b42c0 f3b43eec
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3b43f5c c10a7715 f6166a14 00000000 c1434840 f318e84c c133538c f318e840
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7715>] ? do_sync_write+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133538c>] ? sock_poll+0xc/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d3e7c>] ? ep_send_events_proc+0x5c/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca103>] ? schedule_timeout+0xf3/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055fb0>] ? process_timeout+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d47b1>] ? sys_epoll_wait+0x1f1/0x2c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xulrunner-stu S f32a5b74     0 19709      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6ab1810 00000082 00000002 f32a5b74 c3003324 00000000 f32a5b9c 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 00000286 0a119061
Mar 25 08:05:02 desktop kernel: [169645.245254]  f32a5b9c c3003590 f6ab1994 f6ab1810 c10627ed f32a5b9c 00000001 614f3427
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10627ed>] ? __remove_hrtimer+0x2d/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1062660>] ? hrtimer_wakeup+0x0/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f3da>] ? add_wait_queue+0x1a/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5767>] ? do_sys_poll+0x317/0x3d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1084c74>] ? __alloc_pages_nodemask+0xe4/0x5c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 2 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a2ec1>] ? cache_alloc_refill+0x91/0x4d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133e1af>] ? __alloc_skb+0x4f/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339813>] ? sock_alloc_send_pskb+0x163/0x280
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339946>] ? sock_alloc_send_skb+0x16/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1fb8>] ? unix_stream_sendmsg+0x238/0x350
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13355ca>] ? sock_aio_write+0x11a/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1084832>] ? get_page_from_freelist+0x242/0x4c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13354b0>] ? sock_aio_write+0x0/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7626>] ? do_sync_readv_writev+0xb6/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106acf0>] ? clockevents_program_event+0xa0/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7d9a>] ? do_readv_writev+0x13a/0x1b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b59aa>] ? sys_poll+0x5a/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xulrunner-stu S c122de60     0 19722      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3979ba0 00200082 f6aab68c c122de60 c3003324 c3003598 f3293eb8 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c3003590 00000000 c156a480 c1567324 c1564000 f3293eb8 00200286 c10631e8
Mar 25 08:05:02 desktop kernel: [169645.245254]  0000c350 00000000 f3979d24 c1567560 f6899000 00000000 00200286 0000c350
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c122de60>] ? rb_insert_color+0x80/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10631e8>] ? __hrtimer_start_range_ns+0xf8/0x260
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10633a0>] ? hrtimer_start_range_ns+0x20/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106ca95>] ? futex_wait_queue_me+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106cc5e>] ? futex_wait+0x18e/0x290
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1062660>] ? hrtimer_wakeup+0x0/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106e7df>] ? do_futex+0x11f/0x920
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1024eb0>] ? do_IRQ+0x50/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023b29>] ? common_interrupt+0x29/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106754d>] ? ktime_get+0x5d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106f086>] ? sys_futex+0xa6/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xulrunner-stu S f1c71b74     0 19723      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f39790f0 00200082 00000002 f1c71b74 c3203324 00000000 f1c71b9c 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 00200286 0a118e25
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1c71b9c c3203590 f3979274 f39790f0 c10627ed f1c71b9c 00000001 c5a447f3
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10627ed>] ? __remove_hrtimer+0x2d/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c105f3da>] ? add_wait_queue+0x1a/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5767>] ? do_sys_poll+0x317/0x3d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133f448>] ? memcpy_toiovec+0x38/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133fdfb>] ? skb_copy_datagram_iovec+0x3b/0x1d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339065>] ? lock_sock_nested+0x35/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13724df>] ? tcp_cleanup_rbuf+0xef/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137308f>] ? tcp_recvmsg+0x59f/0x9c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13385b7>] ? sock_common_recvmsg+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13362f3>] ? sock_recvmsg+0xc3/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6563>] ? pollwake+0x53/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042505>] ? __wake_up_sync_key+0x45/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1336d66>] ? sys_recvfrom+0x156/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1336da7>] ? sys_recv+0x37/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1067626>] ? getnstimeofday+0x46/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b59aa>] ? sys_poll+0x5a/0xc0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1050c40>] ? sys_gettimeofday+0x30/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xulrunner-stu S f63c5e20     0 19724      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3979480 00200082 00000002 f63c5e20 c3203324 00000000 f63c5eb8 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f63c5eb8 00200286 0a169294
Mar 25 08:05:02 desktop kernel: [169645.245254]  0000c350 00000000 f3979604 f3979480 00000001 00000000 00200286 0000c350
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106ca95>] ? futex_wait_queue_me+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106cc5e>] ? futex_wait+0x18e/0x290
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1062660>] ? hrtimer_wakeup+0x0/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106e7df>] ? do_futex+0x11f/0x920
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023b29>] ? common_interrupt+0x29/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106754d>] ? ktime_get+0x5d/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106f086>] ? sys_futex+0xa6/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xulrunner-stu S f61e7e20     0 19727      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6788440 00200082 00000002 f61e7e20 c3003324 00000000 f6ab1810 557a4715
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c10357fe c1042298 0a112f9a
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1048e39 00029cd8 f67885c4 f6788440 00000001 00600aaf 00000000 00200086
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10357fe>] ? native_smp_send_reschedule+0x2e/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106ca95>] ? futex_wait_queue_me+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106cc5e>] ? futex_wait+0x18e/0x290
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7715>] ? do_sync_write+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106e7df>] ? do_futex+0x11f/0x920
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a6a4e>] ? do_truncate+0x6e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106f086>] ? sys_futex+0xa6/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8328>] ? sys_write+0x68/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xulrunner-stu S 00000002     0 19730      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3980130 00200082 001e8480 00000002 00000000 f398015c f3980130 c156a480
Mar 25 08:05:02 desktop kernel: [169645.245254]  f397911c 00000000 c156a480 c1567324 c1564000 f39790f0 c3006480 00200086
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1048e39 00012106 f39802b4 00000001 00000001 017b38bf 00000000 00200086
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106ca95>] ? futex_wait_queue_me+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106cc5e>] ? futex_wait+0x18e/0x290
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7715>] ? do_sync_write+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106e7df>] ? do_futex+0x11f/0x920
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106f086>] ? sys_futex+0xa6/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8328>] ? sys_write+0x68/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xulrunner-stu S f1cf7e20     0 19731      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1e3a440 00200082 00000002 f1cf7e20 c3003324 00000000 000001a5 c1da3ad1
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 c32064b0 003d0900 0a0d6d45
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3b5609c 00001a8e f1e3a5c4 f1e3a440 00000003 00000000 f3979bcc f3979ba0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106ca95>] ? futex_wait_queue_me+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106cc5e>] ? futex_wait+0x18e/0x290
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106cf05>] ? futex_wake+0xd5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106e7df>] ? do_futex+0x11f/0x920
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055030>] ? exit_ptrace+0x20/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f972>] ? do_exit+0x462/0x680
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106f086>] ? sys_futex+0xa6/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1047394>] ? finish_task_switch+0x34/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xulrunner-stu S f51dde20     0 19732      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1e3a7d0 00200082 00000002 f51dde20 c3203324 00000000 f6ab1810 9af49d61
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 c10357fe c1042298 0a118e25
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1048e39 000db47b f1e3a954 f1e3a7d0 00000001 00f477ca 00000000 00200086
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10357fe>] ? native_smp_send_reschedule+0x2e/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106ca95>] ? futex_wait_queue_me+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106cc5e>] ? futex_wait+0x18e/0x290
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106cf05>] ? futex_wake+0xd5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106e7df>] ? do_futex+0x11f/0x920
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106f086>] ? sys_futex+0xa6/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106771d>] ? do_gettimeofday+0xd/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1050c40>] ? sys_gettimeofday+0x30/0x80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xulrunner-stu S c3203340     0 19774      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3b56400 00000082 00000400 c3203340 00000002 f1ea7e1c f1ea7e18 c3203324
Mar 25 08:05:02 desktop kernel: [169645.245254]  f1ea7e10 00000001 c156a480 c1567324 c1564000 00000400 00004cfd 0a0e291a
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000400 f3b56584 f3b56400 c122f355 f1ea7f30 00000005 00000002
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c122f355>] ? number+0x315/0x330
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106ca95>] ? futex_wait_queue_me+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106cc5e>] ? futex_wait+0x18e/0x290
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106e7df>] ? do_futex+0x11f/0x920
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1040b79>] ? flush_tlb_others_ipi+0xb9/0xd0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1093873>] ? handle_mm_fault+0x353/0x5b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cbb8a>] ? invalidate_interrupt0+0x2a/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106f086>] ? sys_futex+0xa6/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10473e6>] ? finish_task_switch+0x86/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xulrunner-stu S f63cbe20     0 19775      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3b56070 00000082 00000002 f63cbe20 c3203324 00000000 000001a3 78bd8bca
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 c32064b0 003d0900 0a0e291a
Mar 25 08:05:02 desktop kernel: [169645.245254]  f63b33ec 000073f8 f3b561f4 f3b56070 00000002 00000000 f1d257fc f1d257d0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106ca95>] ? futex_wait_queue_me+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106cc5e>] ? futex_wait+0x18e/0x290
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10444ca>] ? pick_next_task_fair+0xaa/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106e7df>] ? do_futex+0x11f/0x920
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055030>] ? exit_ptrace+0x20/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1040df0>] ? smp_invalidate_interrupt+0x50/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cbb8a>] ? invalidate_interrupt0+0x2a/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c106f086>] ? sys_futex+0xa6/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] su            S fffffff4     0 19915  24141 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3be03c0 00000082 00000000 fffffff4 5b600310 00000194 9af4a894 ffb6d57f
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000000 c156a480 c1567324 c1564000 c205a160 c2001000 00000001
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f31e9224 f3be0544 00000000 c3006480 00000008 00000000 f61985c4
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f387ff10     0 19923  19915 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f5128810 00000086 00000002 f387ff10 c3003324 00000000 c1042298 00000296
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 0000540f bfed1370 0a12297f
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6081e6c f1d29ff8 f5128994 f5128810 bfed1370 0000540f c1277c90 c10b3dfb
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277c90>] ? tty_ioctl+0x0/0x7d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b3dfb>] ? vfs_ioctl+0x2b/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] anvil         S 00000000     0 19960   1570 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f621a7d0 00200086 00000002 00000000 f5021eb0 00000000 00000000 f5021f5c
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000001 00000001 c156a480 c1567324 c1564000 f71157d0 f70b0e40 f5021eec
Mar 25 08:05:02 desktop kernel: [169645.245254]  f5021f5c c10a7715 f621a954 00000000 c1434840 f679b6cc c133538c f679b6c0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7715>] ? do_sync_write+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133538c>] ? sock_poll+0xc/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d3e7c>] ? ep_send_events_proc+0x5c/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca103>] ? schedule_timeout+0xf3/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055fb0>] ? process_timeout+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d47b1>] ? sys_epoll_wait+0x1f1/0x2c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] strace        S f6081f24     0 19991  19923 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f303e070 00000082 00000002 f6081f24 c3203324 00000000 f6081f14 00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 c1091d11 f6643480 0a122f9f
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000815 c1059027 f303e1f4 f303e070 f303e070 00000000 f6080000 c1059195
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1091d11>] ? __do_fault+0x311/0x420
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1059027>] ? do_send_specific+0x37/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1059195>] ? do_tkill+0x65/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] ssh           S f6b05af0     0 20296  21608 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6281480 00000086 00000002 f6b05af0 c3203324 00000000 00000000 00000086
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 7fffffff 0a173d50
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1055a67 f384f860 f6281604 f6281480 00000286 c1055d83 00000286 f384f7f0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055d83>] ? mod_timer_pending+0xa3/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 2 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1358426>] ? nf_iterate+0x76/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c134502b>] ? dev_queue_xmit+0xcb/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bee0>] ? ip_finish_output+0x0/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136c1c0>] ? ip_output+0x90/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136bfc8>] ? ip_finish_output+0xe8/0x250
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b275>] ? ip_local_out+0x15/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c136b912>] ? ip_queue_xmit+0x132/0x370
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c137ded8>] ? tcp_transmit_skb+0x368/0x7b0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055c76>] ? mod_timer+0xc6/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13393ec>] ? sk_reset_timer+0xc/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13801cb>] ? tcp_write_xmit+0x19b/0x970
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339065>] ? lock_sock_nested+0x35/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13cb788>] ? _raw_spin_lock_bh+0x8/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1338fb2>] ? release_sock+0x12/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1380a0e>] ? __tcp_push_pending_frames+0x2e/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1374132>] ? tcp_sendmsg+0x7b2/0xa80
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1041b07>] ? __wake_up_common+0x47/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7715>] ? do_sync_write+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c12778d9>] ? tty_write+0x1c9/0x230
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] xterm         S f61d7af0     0 20465      1 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f5092170 00000086 00000002 f61d7af0 c3203324 00000000 f61d7ae8 c3203324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f7055b60 f509219c 0a1800dd
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000400 f50922f4 f5092170 c3206480 c13d2a20 f5092170 0012b5c2
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13caa9d>] ? schedule_hrtimeout_range+0x10d/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055e61>] ? del_timer_sync+0x11/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b539d>] ? poll_schedule_timeout+0x3d/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b5e8c>] ? do_select+0x42c/0x4e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6420>] ? __pollwait+0x0/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b6510>] ? pollwake+0x0/0x60
Mar 25 08:05:02 desktop last message repeated 3 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1062573>] ? hrtimer_forward+0x163/0x1a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10648d5>] ? sched_clock_local+0xb5/0x190
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10447e9>] ? enqueue_task_fair+0xe9/0x120
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10357fe>] ? native_smp_send_reschedule+0x2e/0x40
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133e1af>] ? __alloc_skb+0x4f/0x140
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339813>] ? sock_alloc_send_pskb+0x163/0x280
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042505>] ? __wake_up_sync_key+0x45/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c81c>] ? skb_queue_tail+0x1c/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1339371>] ? sock_def_readable+0x11/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133c957>] ? skb_dequeue+0x47/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13a1aa5>] ? unix_stream_recvmsg+0x245/0x520
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b60ed>] ? core_sys_select+0x1ad/0x2a0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7626>] ? do_sync_readv_writev+0xb6/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7805>] ? do_sync_read+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b639f>] ? sys_select+0x2f/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          S f6af3f10     0 20467  20465 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f64aaae0 00000086 00000002 f6af3f10 c3003324 00000000 c1042298 00000296
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 0000540f bfbf74f0 0a17d0ee
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f3b7c17c f64aac64 f64aaae0 bfbf74f0 0000540f c1277c90 c10b3dfb
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1042298>] ? resched_task+0x58/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1277c90>] ? tty_ioctl+0x0/0x7d0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10b3dfb>] ? vfs_ioctl+0x2b/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] su            S c3006950     0 20496  20467 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3811850 00000082 00009a47 c3006950 2eb4c1f6 000001ad f1346eaa ffb87081
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000000 c156a480 c1567324 c1564000 c2cb18e0 c2ab7480 c1573e01
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 f329f668 f38119d4 00000000 c3206480 00000008 00000000 f38b3084
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f2ad>] ? do_wait+0x1cd/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f35b>] ? sys_wait4+0x8b/0xe0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104ddf0>] ? child_wait_callback+0x0/0xa0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104f3d7>] ? sys_waitpid+0x27/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] bash          R running      0 20504  20496 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  c1594931 c12862b0 c1512628 000b8bf4 c104c709 00000009 00000082 c1063b0b
Mar 25 08:05:02 desktop kernel: [169645.245254]  000b8c2b 00000046 c104cc11 00000004 00000046 fffe0000 00000092 c159bda9
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000001 f60e3ea6 00000000 00000046 f60e3eec c1480e11 000296ad 0003be06
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c104cc11>] ? release_console_sem+0x1a1/0x1f0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13c930a>] ? printk+0x17/0x1a
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10265ba>] ? printk_address+0x2a/0x30
Mar 25 08:05:02 desktop last message repeated 2 times
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1026b81>] ? print_context_stack+0x71/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1026b81>] ? print_context_stack+0x71/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10258b9>] ? dump_trace+0x69/0xb0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1026a0b>] ? show_trace_log_lvl+0x4b/0x60
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c102595e>] ? show_stack_log_lvl+0x5e/0x100
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10269bb>] ? show_stack+0x1b/0x20
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1046fc6>] ? show_state_filter+0x56/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c128b2b3>] ? __handle_sysrq+0xf3/0x150
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c128b310>] ? write_sysrq_trigger+0x0/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c128b33c>] ? write_sysrq_trigger+0x2c/0x30
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10e15fd>] ? proc_reg_write+0x5d/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10e15a0>] ? proc_reg_write+0x0/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8180>] ? vfs_write+0xa0/0x160
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c103cf7f>] ? do_page_fault+0xef/0x2e0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a8301>] ? sys_write+0x41/0x70
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] smtpd         S c3203340     0 20512   1570 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f5079130 00200082 00000400 c3203340 00000002 f6299f00 f6299efc c3203324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 00000000 f67fc540 0a17f283
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000000 00000400 f50792b4 f5079130 c1434840 f6aecd4c c133538c f6aecd40
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133538c>] ? sock_poll+0xc/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca103>] ? schedule_timeout+0xf3/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055fb0>] ? process_timeout+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d47b1>] ? sys_epoll_wait+0x1f1/0x2c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] proxymap      S f623ff04     0 20513   1570 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6bfa170 00200086 00000002 f623ff04 c3203324 00000000 00000000 f623ff5c
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000001 c156a480 c1567324 c1564000 f5079130 f67fc5c0 0a17f217
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6785b18 f3b726c4 f6bfa2f4 f6bfa170 c1434840 f679b14c c133538c f679b140
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133538c>] ? sock_poll+0xc/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d3e7c>] ? ep_send_events_proc+0x5c/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca145>] ? schedule_timeout+0x135/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d459b>] ? ep_scan_ready_list+0x13b/0x150
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d47b1>] ? sys_epoll_wait+0x1f1/0x2c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] trivial-rewri S 00000000     0 20514   1570 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f506e400 00200082 000280da 00000000 f3085eb0 00000000 00000000 f3085f5c
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000001 00000001 c156a480 c1567324 c1564000 f317f890 f67fce40 f3085eec
Mar 25 08:05:02 desktop kernel: [169645.245254]  f3085f5c c10a7715 f506e584 00000000 c1434840 f6aecdcc c133538c f6aecdc0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10a7715>] ? do_sync_write+0xb5/0xf0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133538c>] ? sock_poll+0xc/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d3e7c>] ? ep_send_events_proc+0x5c/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca103>] ? schedule_timeout+0xf3/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055fb0>] ? process_timeout+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d47b1>] ? sys_epoll_wait+0x1f1/0x2c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] cleanup       S 00000000     0 20515   1570 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f6bfa890 00200086 00000000 00000000 f6233eb0 00000000 00000000 f6233f5c
Mar 25 08:05:02 desktop kernel: [169645.245254]  00000001 00000001 c156a480 c1567324 c1564000 f506e400 f70b4840 f3b72ac4
Mar 25 08:05:02 desktop kernel: [169645.245254]  f30f4544 f3bb6d84 f6bfaa14 00000000 c1434840 f65b18cc c133538c f65b18c0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133538c>] ? sock_poll+0xc/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d3e7c>] ? ep_send_events_proc+0x5c/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055a67>] ? lock_timer_base+0x27/0x50
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca103>] ? schedule_timeout+0xf3/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055fb0>] ? process_timeout+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d47b1>] ? sys_epoll_wait+0x1f1/0x2c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:02 desktop kernel: [169645.245254] local         S f60c9f04     0 20516   1570 0x00000000
Mar 25 08:05:02 desktop kernel: [169645.245254]  f317f890 00200086 00000002 f60c9f04 c3003324 00000000 f60c9efc c3003324
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000000 c156a480 c1567324 c1564000 f71157d0 c1040cb4 0a17fef5
Mar 25 08:05:02 desktop kernel: [169645.245254]  c13d2a80 00000400 f317fa14 f317f890 c1434840 f6aec4cc c133538c f6aec4c0
Mar 25 08:05:02 desktop kernel: [169645.245254] Call Trace:
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1040cb4>] ? flush_tlb_page+0x34/0x90
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c133538c>] ? sock_poll+0xc/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d3e7c>] ? ep_send_events_proc+0x5c/0x110
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c13ca103>] ? schedule_timeout+0xf3/0x180
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1055fb0>] ? process_timeout+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c10d47b1>] ? sys_epoll_wait+0x1f1/0x2c0
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:02 desktop kernel: [169645.245254]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:05:37 desktop kernel: [169680.290264] INFO: task khubd:295 blocked for more than 120 seconds.
Mar 25 08:05:37 desktop kernel: [169680.290268] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 25 08:05:37 desktop kernel: [169680.290270] khubd         D f688e87c     0   295      2 0x00000000
Mar 25 08:05:37 desktop kernel: [169680.290274]  f70b93c0 00000046 c156a480 f688e87c c1042b2e c3206480 00000002 c13d2a20
Mar 25 08:05:37 desktop kernel: [169680.290279]  f688e850 00000001 c156a480 c1567324 c1564000 00000000 00000001 00000000
Mar 25 08:05:37 desktop kernel: [169680.290283]  001fef03 00000000 f70b9544 f688e850 00000000 00000000 00000000 c10b6563
Mar 25 08:05:37 desktop kernel: [169680.290287] Call Trace:
Mar 25 08:05:37 desktop kernel: [169680.290295]  [<c1042b2e>] ? check_preempt_wakeup+0x7e/0xf0
Mar 25 08:05:37 desktop kernel: [169680.290299]  [<c10b6563>] ? pollwake+0x53/0x60
Mar 25 08:05:37 desktop kernel: [169680.290302]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:05:37 desktop kernel: [169680.290306]  [<c13ca61e>] ? __mutex_lock_slowpath+0xbe/0x130
Mar 25 08:05:37 desktop kernel: [169680.290308]  [<c13ca4a6>] ? mutex_lock+0x16/0x30
Mar 25 08:05:37 desktop kernel: [169680.290311]  [<c13301fc>] ? usbhid_close+0x1c/0x80
Mar 25 08:05:37 desktop kernel: [169680.290313]  [<c1329413>] ? hidinput_close+0x13/0x20
Mar 25 08:05:37 desktop kernel: [169680.290316]  [<c13119f6>] ? input_close_device+0x46/0x70
Mar 25 08:05:37 desktop kernel: [169680.290319]  [<c13157c3>] ? evdev_disconnect+0x23/0x40
Mar 25 08:05:37 desktop kernel: [169680.290321]  [<c1311db8>] ? input_unregister_device+0xe8/0x180
Mar 25 08:05:37 desktop kernel: [169680.290324]  [<c13270df>] ? hidinput_disconnect+0x3f/0x60
Mar 25 08:05:37 desktop kernel: [169680.290327]  [<c132563f>] ? hid_disconnect+0x3f/0x50
Mar 25 08:05:37 desktop kernel: [169680.290330]  [<c1325687>] ? hid_device_remove+0x37/0x50
Mar 25 08:05:37 desktop kernel: [169680.290333]  [<c129130b>] ? __device_release_driver+0x3b/0x90
Mar 25 08:05:37 desktop kernel: [169680.290335]  [<c129140d>] ? device_release_driver+0x1d/0x30
Mar 25 08:05:37 desktop kernel: [169680.290338]  [<c12909f3>] ? bus_remove_device+0x73/0xa0
Mar 25 08:05:37 desktop kernel: [169680.290340]  [<c128f03f>] ? device_del+0xdf/0x140
Mar 25 08:05:37 desktop kernel: [169680.290342]  [<c1325012>] ? hid_destroy_device+0x22/0x40
Mar 25 08:05:37 desktop kernel: [169680.290345]  [<c132f3b8>] ? usbhid_disconnect+0x18/0x30
Mar 25 08:05:37 desktop kernel: [169680.290348]  [<c12f7f48>] ? usb_unbind_interface+0x88/0xd0
Mar 25 08:05:37 desktop kernel: [169680.290350]  [<c129130b>] ? __device_release_driver+0x3b/0x90
Mar 25 08:05:37 desktop kernel: [169680.290353]  [<c129140d>] ? device_release_driver+0x1d/0x30
Mar 25 08:05:37 desktop kernel: [169680.290355]  [<c12909f3>] ? bus_remove_device+0x73/0xa0
Mar 25 08:05:37 desktop kernel: [169680.290357]  [<c128f03f>] ? device_del+0xdf/0x140
Mar 25 08:05:37 desktop kernel: [169680.290359]  [<c12f5839>] ? usb_disable_device+0x79/0xe0
Mar 25 08:05:37 desktop kernel: [169680.290361]  [<c12f11d6>] ? usb_disconnect+0xa6/0x110
Mar 25 08:05:37 desktop kernel: [169680.290364]  [<c12f1ecd>] ? hub_thread+0x3cd/0xe10
Mar 25 08:05:37 desktop kernel: [169680.290366]  [<c1041755>] ? dequeue_task+0x65/0xc0
Mar 25 08:05:37 desktop kernel: [169680.290369]  [<c1047394>] ? finish_task_switch+0x34/0xa0
Mar 25 08:05:37 desktop kernel: [169680.290371]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:05:37 desktop kernel: [169680.290375]  [<c105f080>] ? autoremove_wake_function+0x0/0x40
Mar 25 08:05:37 desktop kernel: [169680.290377]  [<c12f1b00>] ? hub_thread+0x0/0xe10
Mar 25 08:05:37 desktop kernel: [169680.290379]  [<c105ed14>] ? kthread+0x74/0x80
Mar 25 08:05:37 desktop kernel: [169680.290381]  [<c105eca0>] ? kthread+0x0/0x80
Mar 25 08:05:37 desktop kernel: [169680.290384]  [<c1023b36>] ? kernel_thread_helper+0x6/0x10
Mar 25 08:05:37 desktop kernel: [169680.290401] INFO: task Xorg:2069 blocked for more than 120 seconds.
Mar 25 08:05:37 desktop kernel: [169680.290402] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 25 08:05:37 desktop kernel: [169680.290404] Xorg          D f6b81f04     0  2069   2053 0x00400004
Mar 25 08:05:37 desktop kernel: [169680.290407]  f6643480 00203082 00000002 f6b81f04 c3003324 00000000 00000000 f6643480
Mar 25 08:05:37 desktop kernel: [169680.290411]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 00203292 0a13573f
Mar 25 08:05:37 desktop kernel: [169680.290415]  fffffffe 00203292 f6643604 f6643480 f7149800 fffffffe c12f3850 c122b10f
Mar 25 08:05:37 desktop kernel: [169680.290419] Call Trace:
Mar 25 08:05:37 desktop kernel: [169680.290421]  [<c12f3850>] ? unlink1+0x30/0xd0
Mar 25 08:05:37 desktop kernel: [169680.290425]  [<c122b10f>] ? kobject_get+0xf/0x20
Mar 25 08:05:37 desktop kernel: [169680.290427]  [<c12f4cdd>] ? usb_kill_urb+0x5d/0x90
Mar 25 08:05:37 desktop kernel: [169680.290430]  [<c105f080>] ? autoremove_wake_function+0x0/0x40
Mar 25 08:05:37 desktop kernel: [169680.290432]  [<c133024e>] ? usbhid_close+0x6e/0x80
Mar 25 08:05:37 desktop kernel: [169680.290434]  [<c1329413>] ? hidinput_close+0x13/0x20
Mar 25 08:05:37 desktop kernel: [169680.290437]  [<c13119f6>] ? input_close_device+0x46/0x70
Mar 25 08:05:37 desktop kernel: [169680.290439]  [<c1315140>] ? evdev_release+0x80/0xa0
Mar 25 08:05:37 desktop kernel: [169680.290443]  [<c10a8c07>] ? __fput+0xc7/0x1b0
Mar 25 08:05:37 desktop kernel: [169680.290445]  [<c10a5b47>] ? filp_close+0x47/0x80
Mar 25 08:05:37 desktop kernel: [169680.290447]  [<c10a5bd8>] ? sys_close+0x58/0x90
Mar 25 08:05:37 desktop kernel: [169680.290450]  [<c1023610>] ? sysenter_do_call+0x12/0x26

# echo w > /proc/sysrq-trigger

Mar 25 08:07:37 desktop kernel: [169800.290270] khubd         D f688e87c     0   295      2 0x00000000
Mar 25 08:07:37 desktop kernel: [169800.290274]  f70b93c0 00000046 c156a480 f688e87c c1042b2e c3206480 00000002 c13d2a20
Mar 25 08:07:37 desktop kernel: [169800.290279]  f688e850 00000001 c156a480 c1567324 c1564000 00000000 00000001 00000000
Mar 25 08:07:37 desktop kernel: [169800.290283]  001fef03 00000000 f70b9544 f688e850 00000000 00000000 00000000 c10b6563
Mar 25 08:07:37 desktop kernel: [169800.290287] Call Trace:
Mar 25 08:07:37 desktop kernel: [169800.290296]  [<c1042b2e>] ? check_preempt_wakeup+0x7e/0xf0
Mar 25 08:07:37 desktop kernel: [169800.290300]  [<c10b6563>] ? pollwake+0x53/0x60
Mar 25 08:07:37 desktop kernel: [169800.290302]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:07:37 desktop kernel: [169800.290306]  [<c13ca61e>] ? __mutex_lock_slowpath+0xbe/0x130
Mar 25 08:07:37 desktop kernel: [169800.290308]  [<c13ca4a6>] ? mutex_lock+0x16/0x30
Mar 25 08:07:37 desktop kernel: [169800.290311]  [<c13301fc>] ? usbhid_close+0x1c/0x80
Mar 25 08:07:37 desktop kernel: [169800.290314]  [<c1329413>] ? hidinput_close+0x13/0x20
Mar 25 08:07:37 desktop kernel: [169800.290317]  [<c13119f6>] ? input_close_device+0x46/0x70
Mar 25 08:07:37 desktop kernel: [169800.290320]  [<c13157c3>] ? evdev_disconnect+0x23/0x40
Mar 25 08:07:37 desktop kernel: [169800.290322]  [<c1311db8>] ? input_unregister_device+0xe8/0x180
Mar 25 08:07:37 desktop kernel: [169800.290324]  [<c13270df>] ? hidinput_disconnect+0x3f/0x60
Mar 25 08:07:37 desktop kernel: [169800.290328]  [<c132563f>] ? hid_disconnect+0x3f/0x50
Mar 25 08:07:37 desktop kernel: [169800.290330]  [<c1325687>] ? hid_device_remove+0x37/0x50
Mar 25 08:07:37 desktop kernel: [169800.290334]  [<c129130b>] ? __device_release_driver+0x3b/0x90
Mar 25 08:07:37 desktop kernel: [169800.290339]  [<c129140d>] ? device_release_driver+0x1d/0x30
Mar 25 08:07:37 desktop kernel: [169800.290342]  [<c12909f3>] ? bus_remove_device+0x73/0xa0
Mar 25 08:07:37 desktop kernel: [169800.290344]  [<c128f03f>] ? device_del+0xdf/0x140
Mar 25 08:07:37 desktop kernel: [169800.290346]  [<c1325012>] ? hid_destroy_device+0x22/0x40
Mar 25 08:07:37 desktop kernel: [169800.290349]  [<c132f3b8>] ? usbhid_disconnect+0x18/0x30
Mar 25 08:07:37 desktop kernel: [169800.290352]  [<c12f7f48>] ? usb_unbind_interface+0x88/0xd0
Mar 25 08:07:37 desktop kernel: [169800.290354]  [<c129130b>] ? __device_release_driver+0x3b/0x90
Mar 25 08:07:37 desktop kernel: [169800.290357]  [<c129140d>] ? device_release_driver+0x1d/0x30
Mar 25 08:07:37 desktop kernel: [169800.290359]  [<c12909f3>] ? bus_remove_device+0x73/0xa0
Mar 25 08:07:37 desktop kernel: [169800.290361]  [<c128f03f>] ? device_del+0xdf/0x140
Mar 25 08:07:37 desktop kernel: [169800.290363]  [<c12f5839>] ? usb_disable_device+0x79/0xe0
Mar 25 08:07:37 desktop kernel: [169800.290366]  [<c12f11d6>] ? usb_disconnect+0xa6/0x110
Mar 25 08:07:37 desktop kernel: [169800.290368]  [<c12f1ecd>] ? hub_thread+0x3cd/0xe10
Mar 25 08:07:37 desktop kernel: [169800.290370]  [<c1041755>] ? dequeue_task+0x65/0xc0
Mar 25 08:07:37 desktop kernel: [169800.290373]  [<c1047394>] ? finish_task_switch+0x34/0xa0
Mar 25 08:07:37 desktop kernel: [169800.290375]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:07:37 desktop kernel: [169800.290378]  [<c105f080>] ? autoremove_wake_function+0x0/0x40
Mar 25 08:07:37 desktop kernel: [169800.290381]  [<c12f1b00>] ? hub_thread+0x0/0xe10
Mar 25 08:07:37 desktop kernel: [169800.290383]  [<c105ed14>] ? kthread+0x74/0x80
Mar 25 08:07:37 desktop kernel: [169800.290385]  [<c105eca0>] ? kthread+0x0/0x80
Mar 25 08:07:37 desktop kernel: [169800.290388]  [<c1023b36>] ? kernel_thread_helper+0x6/0x10
Mar 25 08:07:37 desktop kernel: [169800.290409] Xorg          D f6b81f04     0  2069   2053 0x00400004
Mar 25 08:07:37 desktop kernel: [169800.290412]  f6643480 00203082 00000002 f6b81f04 c3003324 00000000 00000000 f6643480
Mar 25 08:07:37 desktop kernel: [169800.290416]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 00203292 0a13573f
Mar 25 08:07:37 desktop kernel: [169800.290420]  fffffffe 00203292 f6643604 f6643480 f7149800 fffffffe c12f3850 c122b10f
Mar 25 08:07:37 desktop kernel: [169800.290424] Call Trace:
Mar 25 08:07:37 desktop kernel: [169800.290427]  [<c12f3850>] ? unlink1+0x30/0xd0
Mar 25 08:07:37 desktop kernel: [169800.290431]  [<c122b10f>] ? kobject_get+0xf/0x20
Mar 25 08:07:37 desktop kernel: [169800.290433]  [<c12f4cdd>] ? usb_kill_urb+0x5d/0x90
Mar 25 08:07:37 desktop kernel: [169800.290435]  [<c105f080>] ? autoremove_wake_function+0x0/0x40
Mar 25 08:07:37 desktop kernel: [169800.290438]  [<c133024e>] ? usbhid_close+0x6e/0x80
Mar 25 08:07:37 desktop kernel: [169800.290440]  [<c1329413>] ? hidinput_close+0x13/0x20
Mar 25 08:07:37 desktop kernel: [169800.290442]  [<c13119f6>] ? input_close_device+0x46/0x70
Mar 25 08:07:37 desktop kernel: [169800.290445]  [<c1315140>] ? evdev_release+0x80/0xa0
Mar 25 08:07:37 desktop kernel: [169800.290448]  [<c10a8c07>] ? __fput+0xc7/0x1b0
Mar 25 08:07:37 desktop kernel: [169800.290450]  [<c10a5b47>] ? filp_close+0x47/0x80
Mar 25 08:07:37 desktop kernel: [169800.290452]  [<c10a5bd8>] ? sys_close+0x58/0x90
Mar 25 08:07:37 desktop kernel: [169800.290455]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:08:25 desktop kernel: [169848.302405] SysRq : Show Blocked State
Mar 25 08:08:25 desktop kernel: [169848.302413]   task                PC stack   pid father
Mar 25 08:08:25 desktop kernel: [169848.302417] khubd         D f688e87c     0   295      2 0x00000000
Mar 25 08:08:25 desktop kernel: [169848.302421]  f70b93c0 00000046 c156a480 f688e87c c1042b2e c3206480 00000002 c13d2a20
Mar 25 08:08:25 desktop kernel: [169848.302426]  f688e850 00000001 c156a480 c1567324 c1564000 00000000 00000001 00000000
Mar 25 08:08:25 desktop kernel: [169848.302430]  001fef03 00000000 f70b9544 f688e850 00000000 00000000 00000000 c10b6563
Mar 25 08:08:25 desktop kernel: [169848.302434] Call Trace:
Mar 25 08:08:25 desktop kernel: [169848.302442]  [<c1042b2e>] ? check_preempt_wakeup+0x7e/0xf0
Mar 25 08:08:25 desktop kernel: [169848.302446]  [<c10b6563>] ? pollwake+0x53/0x60
Mar 25 08:08:25 desktop kernel: [169848.302449]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:08:25 desktop kernel: [169848.302453]  [<c13ca61e>] ? __mutex_lock_slowpath+0xbe/0x130
Mar 25 08:08:25 desktop kernel: [169848.302455]  [<c13ca4a6>] ? mutex_lock+0x16/0x30
Mar 25 08:08:25 desktop kernel: [169848.302459]  [<c13301fc>] ? usbhid_close+0x1c/0x80
Mar 25 08:08:25 desktop kernel: [169848.302461]  [<c1329413>] ? hidinput_close+0x13/0x20
Mar 25 08:08:25 desktop kernel: [169848.302464]  [<c13119f6>] ? input_close_device+0x46/0x70
Mar 25 08:08:25 desktop kernel: [169848.302467]  [<c13157c3>] ? evdev_disconnect+0x23/0x40
Mar 25 08:08:25 desktop kernel: [169848.302469]  [<c1311db8>] ? input_unregister_device+0xe8/0x180
Mar 25 08:08:25 desktop kernel: [169848.302471]  [<c13270df>] ? hidinput_disconnect+0x3f/0x60
Mar 25 08:08:25 desktop kernel: [169848.302475]  [<c132563f>] ? hid_disconnect+0x3f/0x50
Mar 25 08:08:25 desktop kernel: [169848.302478]  [<c1325687>] ? hid_device_remove+0x37/0x50
Mar 25 08:08:25 desktop kernel: [169848.302481]  [<c129130b>] ? __device_release_driver+0x3b/0x90
Mar 25 08:08:25 desktop kernel: [169848.302484]  [<c129140d>] ? device_release_driver+0x1d/0x30
Mar 25 08:08:25 desktop kernel: [169848.302486]  [<c12909f3>] ? bus_remove_device+0x73/0xa0
Mar 25 08:08:25 desktop kernel: [169848.302488]  [<c128f03f>] ? device_del+0xdf/0x140
Mar 25 08:08:25 desktop kernel: [169848.302491]  [<c1325012>] ? hid_destroy_device+0x22/0x40
Mar 25 08:08:25 desktop kernel: [169848.302493]  [<c132f3b8>] ? usbhid_disconnect+0x18/0x30
Mar 25 08:08:25 desktop kernel: [169848.302497]  [<c12f7f48>] ? usb_unbind_interface+0x88/0xd0
Mar 25 08:08:25 desktop kernel: [169848.302499]  [<c129130b>] ? __device_release_driver+0x3b/0x90
Mar 25 08:08:25 desktop kernel: [169848.302502]  [<c129140d>] ? device_release_driver+0x1d/0x30
Mar 25 08:08:25 desktop kernel: [169848.302504]  [<c12909f3>] ? bus_remove_device+0x73/0xa0
Mar 25 08:08:25 desktop kernel: [169848.302507]  [<c128f03f>] ? device_del+0xdf/0x140
Mar 25 08:08:25 desktop kernel: [169848.302509]  [<c12f5839>] ? usb_disable_device+0x79/0xe0
Mar 25 08:08:25 desktop kernel: [169848.302511]  [<c12f11d6>] ? usb_disconnect+0xa6/0x110
Mar 25 08:08:25 desktop kernel: [169848.302513]  [<c12f1ecd>] ? hub_thread+0x3cd/0xe10
Mar 25 08:08:25 desktop kernel: [169848.302516]  [<c1041755>] ? dequeue_task+0x65/0xc0
Mar 25 08:08:25 desktop kernel: [169848.302519]  [<c1047394>] ? finish_task_switch+0x34/0xa0
Mar 25 08:08:25 desktop kernel: [169848.302521]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:08:25 desktop kernel: [169848.302525]  [<c105f080>] ? autoremove_wake_function+0x0/0x40
Mar 25 08:08:25 desktop kernel: [169848.302527]  [<c12f1b00>] ? hub_thread+0x0/0xe10
Mar 25 08:08:25 desktop kernel: [169848.302529]  [<c105ed14>] ? kthread+0x74/0x80
Mar 25 08:08:25 desktop kernel: [169848.302531]  [<c105eca0>] ? kthread+0x0/0x80
Mar 25 08:08:25 desktop kernel: [169848.302534]  [<c1023b36>] ? kernel_thread_helper+0x6/0x10
Mar 25 08:08:25 desktop kernel: [169848.302550] Xorg          D f6b81f04     0  2069   2053 0x00400004
Mar 25 08:08:25 desktop kernel: [169848.302553]  f6643480 00203082 00000002 f6b81f04 c3003324 00000000 00000000 f6643480
Mar 25 08:08:25 desktop kernel: [169848.302557]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 00203292 0a13573f
Mar 25 08:08:25 desktop kernel: [169848.302561]  fffffffe 00203292 f6643604 f6643480 f7149800 fffffffe c12f3850 c122b10f
Mar 25 08:08:25 desktop kernel: [169848.302565] Call Trace:
Mar 25 08:08:25 desktop kernel: [169848.302568]  [<c12f3850>] ? unlink1+0x30/0xd0
Mar 25 08:08:25 desktop kernel: [169848.302572]  [<c122b10f>] ? kobject_get+0xf/0x20
Mar 25 08:08:25 desktop kernel: [169848.302574]  [<c12f4cdd>] ? usb_kill_urb+0x5d/0x90
Mar 25 08:08:25 desktop kernel: [169848.302577]  [<c105f080>] ? autoremove_wake_function+0x0/0x40
Mar 25 08:08:25 desktop kernel: [169848.302579]  [<c133024e>] ? usbhid_close+0x6e/0x80
Mar 25 08:08:25 desktop kernel: [169848.302582]  [<c1329413>] ? hidinput_close+0x13/0x20
Mar 25 08:08:25 desktop kernel: [169848.302584]  [<c13119f6>] ? input_close_device+0x46/0x70
Mar 25 08:08:25 desktop kernel: [169848.302586]  [<c1315140>] ? evdev_release+0x80/0xa0
Mar 25 08:08:25 desktop kernel: [169848.302590]  [<c10a8c07>] ? __fput+0xc7/0x1b0
Mar 25 08:08:25 desktop kernel: [169848.302592]  [<c10a5b47>] ? filp_close+0x47/0x80
Mar 25 08:08:25 desktop kernel: [169848.302594]  [<c10a5bd8>] ? sys_close+0x58/0x90
Mar 25 08:08:25 desktop kernel: [169848.302597]  [<c1023610>] ? sysenter_do_call+0x12/0x26
Mar 25 08:09:37 desktop kernel: [169920.290270] khubd         D f688e87c     0   295      2 0x00000000
Mar 25 08:09:37 desktop kernel: [169920.290274]  f70b93c0 00000046 c156a480 f688e87c c1042b2e c3206480 00000002 c13d2a20
Mar 25 08:09:37 desktop kernel: [169920.290279]  f688e850 00000001 c156a480 c1567324 c1564000 00000000 00000001 00000000
Mar 25 08:09:37 desktop kernel: [169920.290283]  001fef03 00000000 f70b9544 f688e850 00000000 00000000 00000000 c10b6563
Mar 25 08:09:37 desktop kernel: [169920.290287] Call Trace:
Mar 25 08:09:37 desktop kernel: [169920.290295]  [<c1042b2e>] ? check_preempt_wakeup+0x7e/0xf0
Mar 25 08:09:37 desktop kernel: [169920.290300]  [<c10b6563>] ? pollwake+0x53/0x60
Mar 25 08:09:37 desktop kernel: [169920.290303]  [<c1048f30>] ? default_wake_function+0x0/0x10
Mar 25 08:09:37 desktop kernel: [169920.290306]  [<c13ca61e>] ? __mutex_lock_slowpath+0xbe/0x130
Mar 25 08:09:37 desktop kernel: [169920.290308]  [<c13ca4a6>] ? mutex_lock+0x16/0x30
Mar 25 08:09:37 desktop kernel: [169920.290312]  [<c13301fc>] ? usbhid_close+0x1c/0x80
Mar 25 08:09:37 desktop kernel: [169920.290314]  [<c1329413>] ? hidinput_close+0x13/0x20
Mar 25 08:09:37 desktop kernel: [169920.290317]  [<c13119f6>] ? input_close_device+0x46/0x70
Mar 25 08:09:37 desktop kernel: [169920.290320]  [<c13157c3>] ? evdev_disconnect+0x23/0x40
Mar 25 08:09:37 desktop kernel: [169920.290322]  [<c1311db8>] ? input_unregister_device+0xe8/0x180
Mar 25 08:09:37 desktop kernel: [169920.290324]  [<c13270df>] ? hidinput_disconnect+0x3f/0x60
Mar 25 08:09:37 desktop kernel: [169920.290328]  [<c132563f>] ? hid_disconnect+0x3f/0x50
Mar 25 08:09:37 desktop kernel: [169920.290330]  [<c1325687>] ? hid_device_remove+0x37/0x50
Mar 25 08:09:37 desktop kernel: [169920.290333]  [<c129130b>] ? __device_release_driver+0x3b/0x90
Mar 25 08:09:37 desktop kernel: [169920.290336]  [<c129140d>] ? device_release_driver+0x1d/0x30
Mar 25 08:09:37 desktop kernel: [169920.290338]  [<c12909f3>] ? bus_remove_device+0x73/0xa0
Mar 25 08:09:37 desktop kernel: [169920.290340]  [<c128f03f>] ? device_del+0xdf/0x140
Mar 25 08:09:37 desktop kernel: [169920.290343]  [<c1325012>] ? hid_destroy_device+0x22/0x40
Mar 25 08:09:37 desktop kernel: [169920.290345]  [<c132f3b8>] ? usbhid_disconnect+0x18/0x30
Mar 25 08:09:37 desktop kernel: [169920.290349]  [<c12f7f48>] ? usb_unbind_interface+0x88/0xd0
Mar 25 08:09:37 desktop kernel: [169920.290351]  [<c129130b>] ? __device_release_driver+0x3b/0x90
Mar 25 08:09:37 desktop kernel: [169920.290353]  [<c129140d>] ? device_release_driver+0x1d/0x30
Mar 25 08:09:37 desktop kernel: [169920.290356]  [<c12909f3>] ? bus_remove_device+0x73/0xa0
Mar 25 08:09:37 desktop kernel: [169920.290358]  [<c128f03f>] ? device_del+0xdf/0x140
Mar 25 08:09:37 desktop kernel: [169920.290360]  [<c12f5839>] ? usb_disable_device+0x79/0xe0
Mar 25 08:09:37 desktop kernel: [169920.290362]  [<c12f11d6>] ? usb_disconnect+0xa6/0x110
Mar 25 08:09:37 desktop kernel: [169920.290364]  [<c12f1ecd>] ? hub_thread+0x3cd/0xe10
Mar 25 08:09:37 desktop kernel: [169920.290367]  [<c1041755>] ? dequeue_task+0x65/0xc0
Mar 25 08:09:37 desktop kernel: [169920.290370]  [<c1047394>] ? finish_task_switch+0x34/0xa0
Mar 25 08:09:37 desktop kernel: [169920.290372]  [<c1048e39>] ? try_to_wake_up+0x219/0x310
Mar 25 08:09:37 desktop kernel: [169920.290376]  [<c105f080>] ? autoremove_wake_function+0x0/0x40
Mar 25 08:09:37 desktop kernel: [169920.290378]  [<c12f1b00>] ? hub_thread+0x0/0xe10
Mar 25 08:09:37 desktop kernel: [169920.290380]  [<c105ed14>] ? kthread+0x74/0x80
Mar 25 08:09:37 desktop kernel: [169920.290382]  [<c105eca0>] ? kthread+0x0/0x80
Mar 25 08:09:37 desktop kernel: [169920.290386]  [<c1023b36>] ? kernel_thread_helper+0x6/0x10
Mar 25 08:09:37 desktop kernel: [169920.290405] Xorg          D f6b81f04     0  2069   2053 0x00400004
Mar 25 08:09:37 desktop kernel: [169920.290408]  f6643480 00203082 00000002 f6b81f04 c3003324 00000000 00000000 f6643480
Mar 25 08:09:37 desktop kernel: [169920.290412]  c13d2a80 00000000 c156a480 c1567324 c1564000 c14f0ea0 00203292 0a13573f
Mar 25 08:09:37 desktop kernel: [169920.290416]  fffffffe 00203292 f6643604 f6643480 f7149800 fffffffe c12f3850 c122b10f
Mar 25 08:09:37 desktop kernel: [169920.290420] Call Trace:
Mar 25 08:09:37 desktop kernel: [169920.290422]  [<c12f3850>] ? unlink1+0x30/0xd0
Mar 25 08:09:37 desktop kernel: [169920.290428]  [<c122b10f>] ? kobject_get+0xf/0x20
Mar 25 08:09:37 desktop kernel: [169920.290430]  [<c12f4cdd>] ? usb_kill_urb+0x5d/0x90
Mar 25 08:09:37 desktop kernel: [169920.290432]  [<c105f080>] ? autoremove_wake_function+0x0/0x40
Mar 25 08:09:37 desktop kernel: [169920.290435]  [<c133024e>] ? usbhid_close+0x6e/0x80
Mar 25 08:09:37 desktop kernel: [169920.290437]  [<c1329413>] ? hidinput_close+0x13/0x20
Mar 25 08:09:37 desktop kernel: [169920.290439]  [<c13119f6>] ? input_close_device+0x46/0x70
Mar 25 08:09:37 desktop kernel: [169920.290442]  [<c1315140>] ? evdev_release+0x80/0xa0
Mar 25 08:09:37 desktop kernel: [169920.290445]  [<c10a8c07>] ? __fput+0xc7/0x1b0
Mar 25 08:09:37 desktop kernel: [169920.290448]  [<c10a5b47>] ? filp_close+0x47/0x80
Mar 25 08:09:37 desktop kernel: [169920.290450]  [<c10a5bd8>] ? sys_close+0x58/0x90
Mar 25 08:09:37 desktop kernel: [169920.290452]  [<c1023610>] ? sysenter_do_call+0x12/0x26

$ cat xorg.conf
Section "ServerLayout"
 	Identifier     "X.org Configured"
 	Screen      0  "Screen0" 0 0
 	InputDevice    "Mouse0" "CorePointer"
 	InputDevice    "Keyboard0" "CoreKeyboard"
EndSection

Section "Files"
 	ModulePath   "/usr/lib/xorg/modules"
 	FontPath     "/usr/share/fonts/X11/misc"
 	FontPath     "/usr/share/fonts/X11/cyrillic"
 	FontPath     "/usr/share/fonts/X11/100dpi/:unscaled"
 	FontPath     "/usr/share/fonts/X11/75dpi/:unscaled"
 	FontPath     "/usr/share/fonts/X11/Type1"
 	FontPath     "/usr/share/fonts/X11/100dpi"
 	FontPath     "/usr/share/fonts/X11/75dpi"
 	FontPath     "/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType"
 	FontPath     "built-ins"
EndSection

Section "Module"
 	Load  "record"
 	Load  "glx"
 	Load  "dbe"
 	Load  "dri"
 	Load  "extmod"
 	Load  "dri2"
EndSection

Section "InputDevice"
 	Identifier  "Keyboard0"
 	Driver      "kbd"
EndSection

Section "InputDevice"
 	Identifier  "Mouse0"
 	Driver      "mouse"
 	Option	    "Protocol" "auto"
 	Option	    "Device" "/dev/input/mice"
 	Option	    "ZAxisMapping" "4 5 6 7"
EndSection

Section "Monitor"
 	#DisplaySize	  380   300	# mm
 	Identifier   "Monitor0"
 	VendorName   "DEL"
 	ModelName    "DELL E193FP"
 	HorizSync    31.0 - 83.0
 	VertRefresh  56.0 - 76.0
 	Option	    "DPMS"
EndSection

Section "Device"
         ### Available Driver options are:-
         ### Values: <i>: integer, <f>: float, <bool>: "True"/"False",
         ### <string>: "String", <freq>: "<f> Hz/kHz/MHz"
         ### [arg]: arg optional
         #Option     "SWcursor"           	# [<bool>]
         #Option     "HWcursor"           	# [<bool>]
         #Option     "NoAccel"            	# [<bool>]
         #Option     "ShadowFB"           	# [<bool>]
         #Option     "UseFBDev"           	# [<bool>]
         #Option     "Rotate"             	# [<str>]
         #Option     "VideoKey"           	# <i>
         #Option     "FlatPanel"          	# [<bool>]
         #Option     "FPDither"           	# [<bool>]
         #Option     "CrtcNumber"         	# <i>
         #Option     "FPScale"            	# [<bool>]
         #Option     "FPTweak"            	# <i>
         #Option     "DualHead"           	# [<bool>]
 	Identifier  "Card0"
 	Driver      "nv"
 	VendorName  "nVidia Corporation"
 	BoardName   "C51 [GeForce 6150 LE]"
 	BusID       "PCI:0:5:0"
EndSection

Section "Screen"
 	Identifier "Screen0"
 	Device     "Card0"
 	Monitor    "Monitor0"
 	DefaultDepth 24

 	SubSection "Display"
 		Depth     24
 		Modes	  "1280x1024"
 	EndSubSection
EndSection

Justin.
