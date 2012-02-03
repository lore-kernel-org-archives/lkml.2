Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab2BCVCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:02:36 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61986 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2BCVCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:02:35 -0500
Date: Fri, 3 Feb 2012 15:59:53 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: kobject (ffff88003ffbb4b8): tried to init an initialized object,
 something is seriously wrong.
Message-ID: <20120203205953.GA2897@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F2C4B69.006F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

With or without your previous patch (the one that added an cpu_device_release
function) I am getting this in 3.3-rc2.  I did not get this in 3.2.

I added some extra printks to make sure that the handle_vcpu_hotplug_event
code actually did call 'arch_unregister_cpu' which is certainly looks
to be doing.

I hadn't done a bisection yet, but was wondering if this is related
to the previous issues with the sysdev. Or kobject getting more observant.


[   34.984105] Disabling CPU3 present 
[   34.984801] arch_unregister_cpu: CPU 3

sh-4.1# 
sh-4.1# 
sh-4.1# [   42.297542] Contemplating CPU 0 which should be online
[   42.298447] Enabling CPU0 present online
[   42.299229] Contemplating CPU 1 which should be online
[   42.300001] Enabling CPU1 present online
[   42.300783] Contemplating CPU 2 which should be online
[   42.301558] Enabling CPU2 present online
[   42.302387] Contemplating CPU 3 which should be online
[   42.303198] Enabling CPU3  
[   42.303895] arch_register_cpu: CPU 3
[   42.304188] kobject (ffff88003ffbb4b8): tried to init an initialized object, something is seriously wrong.
[   42.304188] Pid: 30, comm: xenwatch Tainted: G           O 3.3.0-rc2-00008-g4b64969 #1
[   42.304188] Call Trace:
[   42.304188]  [<ffffffff812ce4d9>] kobject_init+0x89/0xa0
[   42.304188]  [<ffffffff813ca917>] device_initialize+0x27/0x90
[   42.304188]  [<ffffffff813cbbc1>] device_register+0x11/0x20
[   42.304188]  [<ffffffff815f2210>] register_cpu+0x52/0xb6
[   42.304188]  [<ffffffff815d66c0>] arch_register_cpu+0x60/0x70
[   42.304188]  [<ffffffff8136b095>] handle_vcpu_hotplug_event+0x175/0x180
[   42.304188]  [<ffffffff81367140>] xenwatch_thread+0xb0/0x180
[   42.304188]  [<ffffffff810a7ec0>] ? wake_up_bit+0x40/0x40
[   42.304188]  [<ffffffff81367090>] ? split+0xf0/0xf0
[   42.304188]  [<ffffffff810a77e6>] kthread+0x96/0xa0
[   42.304188]  [<ffffffff815fec24>] kernel_thread_helper+0x4/0x10
[   42.304188]  [<ffffffff815f6b40>] ? retint_restore_args+0x5/0x6
[   42.304188]  [<ffffffff815fec20>] ? gs_change+0x13/0x13

