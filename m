Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768377Ab2KOQJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:09:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768347Ab2KOQJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:09:13 -0500
Message-ID: <50A513A8.9010404@redhat.com>
Date: Thu, 15 Nov 2012 17:09:12 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Acpi deadlocks with 3.7.0-rc4
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello


I've already seen twice this oops after resuming my Lenovo T61 in docking station.

Since for some reason currently the serial line doesn't work correctly after 
resume
(while I'm pretty sure it used to work in past) here is at least hand-written oops
message from mobile camera picture.

 From the trace it seem os_wait semaphore is accessed twice.
Unsure which device is behind it - but it seem docking station is need to hit 
this issue.


kernel 3.7.0-rc4

Pid:  pm-suspend

RIP:   acpi_ns_lookup  + 0xa1/0x5b9

Call Trace:

? acpi_os_wait_semaphore + 0x136/0x149
acpi_ns_get_mode + 0x96/0x102
? __lock_is_held +0x5f/0x90
acpi_ns_evaluate +0x47/0x2de
? _raw_spin_lock_irqsave
? acpi_ut_evaluate_object
? sub_preempt_count
? pnpacpi_can_wakeup
acpi_rs_get_method_data
? acpi_os_signal_semaphore
acpi_walk_resources
? acpi_ut_release_mutex
pnpacpi_build_resource_template
? acpi_bus_get_device
pnpacpi_set_resources
? pnp_device_shutdown
pnp_start_dev
pnp_bus_resume
dpm_run_callback
device_resume
dpm_resume
dpm_resume_end
? acpi_suspend_begin_old
suspend_devices_and_enter
pm_suspend
state_store
kobj_attr_store
sysfs_write_file
vgs_write
sys_write
system_call_fastpath

Zdenek


PS: jpg on request
