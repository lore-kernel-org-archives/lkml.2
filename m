Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2GDMvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:51:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47219 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab2GDMvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:51:45 -0400
MIME-Version: 1.0
Date: Wed, 4 Jul 2012 18:21:44 +0530
Message-ID: <CADa7JjU0fRQw-erC5w7PbLdF_nHVxJuVb3zJ5TcRMV2DLK4BJw@mail.gmail.com>
Subject: Not getting login prompt after CPU entered into cpu_idle() state
From: Srinidhi M <srinidhi.m26@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We have ported the kernel from 2.6.10 version to 2.6.32 kernel version
for our Phytec LPC-3180 board. We have done good work and able to
complete the kernel part i.e. completed the start_kernel function and
CPU entered into IDLE state from cpu_idle() function which is defined
in rest_init() function in main.c file. However, rest_init() function
also creates TWO threads. One thread is for running the kernel_init()
function where it calls the init_post() function. In this, after a few
other calls, there is a call to init the init-process i.e.
run_init_process("/sbin/init"). After this, we are not seeing neither
any errors nor login prompt in hyper terminal. We end up without
getting any login prompt. Any idea would be greatly help us in getting
the login prompt / for debugging the sources further for identifying
the exact reason / location to find out the error.

Here are the final debug statements which we are seeing in the hyper terminal.

<6>VFP support v0.3: implementor 41 architecture 1 part 10 variant 9 rev 1
<5>RAMDISK: gzip image found at block 0
VFS: Mounted root (ext2 filesystem) on device 1:0.
<6>Freeing init memory: 80K
.....@ <init/main.c>  <init_post>  <900>
.....@ <arch/arm/kernel/sys_arm.c>  <kernel_execve>  <271> ret = 0 : /sbin/init
.....@ <arch/arm/kernel/sys_arm.c>  <kernel_execve>  <274>
.....@ <arch/arm/kernel/sys_arm.c>  <kernel_execve>  <271> ret = 0 :
/sbin/modprobe
.....@ <arch/arm/kernel/sys_arm.c>  <kernel_execve>  <274>
.....@ <arch/arm/kernel/sys_arm.c>  <kernel_execve>  <271> ret = 0 :
/sbin/modprobe
.....@ <arch/arm/kernel/sys_arm.c>  <kernel_execve>  <274>
.....@ <arch/arm/kernel/sys_arm.c>  <kernel_execve>  <271> ret = 0 :
/sbin/modprobe
.....@ <arch/arm/kernel/sys_arm.c>  <kernel_execve>  <274>
.....@ <arch/arm/kernel/sys_arm.c>  <kernel_execve>  <271> ret = 0 :
/sbin/modprobe
.....@ <arch/arm/kernel/sys_arm.c>  <kernel_execve>  <274>

If we load 2.6.10 kernel image, we are getting login prompt in the
hyper terminal on the same Phytec board.

NOTE: We are using the same file system on 2.6.32 kernel which was
running fine on 2.6.10 kernel.

We will provide if any one need additional information / complete log.

Thanks in advance.

Regards,
Srinidhi.
