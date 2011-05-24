Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1EXOL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:11:29 -0400
Received: from imr4.ericy.com ([198.24.6.8]:38099 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab1EXOL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:11:28 -0400
Date: Tue, 24 May 2011 07:09:22 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] coretemp: Initialize sysfs attrs
Message-ID: <20110524140921.GA13039@ericsson.com>
References: <20110524112831.GA5520@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110524112831.GA5520@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 07:28:31AM -0400, Sergey Senozhatsky wrote:
> Initialize sysfs attrs before device_create_file() call to suppress lockdep_init_map()
> warning:
> 
> [    3.653628] WARNING: at kernel/lockdep.c:2885 lockdep_init_map+0xea/0x43c()
> [    3.653698] Modules linked in:
> [    3.654835] Pid: 1, comm: swapper Not tainted 2.6.39-dbg-git8-05624-g46187f8 #576
> [    3.656014] Call Trace:
> [    3.657139]  [<ffffffff8103e4b4>] warn_slowpath_common+0x7e/0x96
> [    3.658298]  [<ffffffff8103e4e1>] warn_slowpath_null+0x15/0x17
> [    3.659460]  [<ffffffff8106d7b9>] lockdep_init_map+0xea/0x43c
> [    3.660616]  [<ffffffff81163c1a>] sysfs_add_file_mode+0x5d/0xa8
> [    3.661785]  [<ffffffff81163c71>] sysfs_add_file+0xc/0xe
> [    3.662929]  [<ffffffff81163d26>] sysfs_create_file+0x23/0x25
> [    3.664045]  [<ffffffff813724d1>] device_create_file+0x14/0x16
> [    3.665172]  [<ffffffff81460ed4>] coretemp_probe+0xf9/0x185
> [    3.666306]  [<ffffffff8137638e>] platform_drv_probe+0x12/0x14
> [    3.667420]  [<ffffffff81375321>] driver_probe_device+0xb0/0x14b
> [    3.668542]  [<ffffffff8137546d>] __device_attach+0x35/0x3a
> [    3.669710]  [<ffffffff81375438>] ? __driver_attach+0x7c/0x7c
> [    3.670816]  [<ffffffff8137426b>] bus_for_each_drv+0x54/0x88
> [    3.671921]  [<ffffffff81375231>] device_attach+0x77/0x9b
> [    3.673027]  [<ffffffff81374aef>] bus_probe_device+0x22/0x39
> [    3.674137]  [<ffffffff81373235>] device_add+0x3c1/0x550
> [    3.675249]  [<ffffffff81371ed9>] ? dev_set_name+0x3c/0x3e
> [    3.676371]  [<ffffffff813769f3>] platform_device_add+0x10c/0x156
> [    3.677491]  [<ffffffff8146af9c>] get_core_online+0xab/0x16e
> [    3.678608]  [<ffffffff81ad8070>] coretemp_init+0x4b/0x80
> [    3.679724]  [<ffffffff81ad8025>] ? hwmon_init+0xee/0xee
> [    3.680853]  [<ffffffff8100020a>] do_one_initcall+0x7a/0x13c
> [    3.681975]  [<ffffffff81aaac74>] kernel_init+0xe1/0x15b
> [    3.683081]  [<ffffffff8147e4e4>] kernel_thread_helper+0x4/0x10
> [    3.684174]  [<ffffffff8102d48c>] ? finish_task_switch+0x76/0xf0
> [    3.685266]  [<ffffffff81477918>] ? retint_restore_args+0x13/0x13
> [    3.686356]  [<ffffffff81aaab93>] ? start_kernel+0x3ee/0x3ee
> [    3.687425]  [<ffffffff8147e4e0>] ? gs_change+0x13/0x13
> [    3.688489] ---[ end trace 7392ad3e6a92ae39 ]---
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
Thanks, applied.

Guenter
