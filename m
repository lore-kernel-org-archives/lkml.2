Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1IPH36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 03:29:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:51873 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab1IPH34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 03:29:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,392,1312182000"; 
   d="scan'208";a="49459246"
Subject: Re: kmemleaks related to ACPI psparse
From: Lin Ming <ming.m.lin@intel.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "Moore, Robert" <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110916072210.GA25500@sucs.org>
References: <20110916072210.GA25500@sucs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 15:29:54 +0800
Message-ID: <1316158194.5362.5.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 15:22 +0800, Sitsofe Wheeler wrote:
> Hi,
> 
> In 3.1.0-rc5-dirty the following warning appeared in dmesg:

Hi,

Please attach the acpidump output.

Regards,
Lin Ming

> 
> [  249.506212] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110623/evregion-478)
> [  249.506387] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SBRG.EC0_.RCTP] (Node ee96daf0), AE_TIME (20110623/psparse-536)
> [  249.506636] ACPI Error: Method parse/execution failed [\_TZ_.RTMP] (Node eeb85000), AE_TIME (20110623/psparse-536)
> [  249.506827] ACPI Error: Method parse/execution failed [\_TZ_.TZ00._TMP] (Node eeb85190), AE_TIME (20110623/psparse-536)
> [  249.511953] Thermal: failed to read out thermal zone 0
> 
> Shortly followed by a bunch of kmemleak warnings (the initial trigger
> has not been reproducible though):
> 
> unreferenced object 0xedcb81a0 (size 32):
>   comm "kworker/0:2", pid 389, jiffies 4294915201 (age 649.854s)
>   hex dump (first 32 bytes):
>     00 00 00 00 0d 01 70 00 00 00 00 00 00 00 00 00  ......p.........
>     00 00 00 00 d0 8d cb ed 00 00 00 00 01 00 00 00  ................
>   backtrace:
>     [<b0551807>] kmemleak_alloc+0x27/0x50
>     [<b0196435>] kmem_cache_alloc+0xc5/0x180
>     [<b02c5faf>] acpi_ps_alloc_op+0x82/0x84
>     [<b02c55d5>] acpi_ps_parse_loop+0x1e9/0x830
>     [<b02c4e1e>] acpi_ps_parse_aml+0x87/0x235
>     [<b02c61b4>] acpi_ps_execute_method+0x190/0x248
>     [<b02c1f8b>] acpi_ns_evaluate+0xc7/0x179
>     [<b02c1abd>] acpi_evaluate_object+0xd1/0x1c0
>     [<b02ad0aa>] acpi_evaluate_integer+0x2a/0x51
>     [<b02cf9de>] thermal_get_temp+0x34/0x5a
>     [<b03f6d49>] thermal_zone_device_update+0x29/0x2a0
>     [<b03f6fcd>] thermal_zone_device_check+0xd/0x10
>     [<b013bd2c>] process_one_work+0x18c/0x3c0
>     [<b013e697>] worker_thread+0x107/0x310
>     [<b0141cac>] kthread+0x7c/0x90
>     [<b055e102>] kernel_thread_helper+0x6/0xd
> unreferenced object 0xedcb8dd0 (size 32):
>   comm "kworker/0:2", pid 389, jiffies 4294915201 (age 649.854s)
>   hex dump (first 32 bytes):
>     a0 81 cb ed 0d 01 36 00 00 00 00 00 00 00 00 00  ......6.........
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<b0551807>] kmemleak_alloc+0x27/0x50
>     [<b0196435>] kmem_cache_alloc+0xc5/0x180
>     [<b02c5faf>] acpi_ps_alloc_op+0x82/0x84
>     [<b02c5159>] acpi_ps_complete_this_op+0xbb/0x146
>     [<b02c5202>] acpi_ps_complete_op+0x1e/0x208
>     [<b02c5afd>] acpi_ps_parse_loop+0x711/0x830
>     [<b02c4e1e>] acpi_ps_parse_aml+0x87/0x235
>     [<b02c61b4>] acpi_ps_execute_method+0x190/0x248
>     [<b02c1f8b>] acpi_ns_evaluate+0xc7/0x179
>     [<b02c1abd>] acpi_evaluate_object+0xd1/0x1c0
>     [<b02ad0aa>] acpi_evaluate_integer+0x2a/0x51
>     [<b02cf9de>] thermal_get_temp+0x34/0x5a
>     [<b03f6d49>] thermal_zone_device_update+0x29/0x2a0
>     [<b03f6fcd>] thermal_zone_device_check+0xd/0x10
>     [<b013bd2c>] process_one_work+0x18c/0x3c0
>     [<b013e697>] worker_thread+0x107/0x310
> unreferenced object 0xedcb84e0 (size 32):
>   comm "kworker/0:2", pid 389, jiffies 4294915202 (age 649.853s)
>   hex dump (first 32 bytes):
>     00 00 00 00 0d 01 a0 00 03 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 80 cb ed 00 00 00 00 02 00 00 00  ................
>   backtrace:
>     [<b0551807>] kmemleak_alloc+0x27/0x50
>     [<b0196435>] kmem_cache_alloc+0xc5/0x180
>     [<b02c5faf>] acpi_ps_alloc_op+0x82/0x84
>     [<b02c55d5>] acpi_ps_parse_loop+0x1e9/0x830
>     [<b02c4e1e>] acpi_ps_parse_aml+0x87/0x235
>     [<b02c61b4>] acpi_ps_execute_method+0x190/0x248
>     [<b02c1f8b>] acpi_ns_evaluate+0xc7/0x179
>     [<b02c1abd>] acpi_evaluate_object+0xd1/0x1c0
>     [<b02ad0aa>] acpi_evaluate_integer+0x2a/0x51
>     [<b02cf9de>] thermal_get_temp+0x34/0x5a
>     [<b03f6d49>] thermal_zone_device_update+0x29/0x2a0
>     [<b03f6fcd>] thermal_zone_device_check+0xd/0x10
>     [<b013bd2c>] process_one_work+0x18c/0x3c0
>     [<b013e697>] worker_thread+0x107/0x310
>     [<b0141cac>] kthread+0x7c/0x90
>     [<b055e102>] kernel_thread_helper+0x6/0xd
> unreferenced object 0xedcb8000 (size 32):
>   comm "kworker/0:2", pid 389, jiffies 4294915209 (age 649.870s)
>   hex dump (first 32 bytes):
>     e0 84 cb ed 0d 01 a0 00 09 00 00 00 00 00 00 00  ................
>     00 00 00 00 90 8a cb ed 00 00 00 00 02 00 00 00  ................
>   backtrace:
>     [<b0551807>] kmemleak_alloc+0x27/0x50
>     [<b0196435>] kmem_cache_alloc+0xc5/0x180
>     [<b02c5faf>] acpi_ps_alloc_op+0x82/0x84
>     [<b02c55d5>] acpi_ps_parse_loop+0x1e9/0x830
>     [<b02c4e1e>] acpi_ps_parse_aml+0x87/0x235
>     [<b02c61b4>] acpi_ps_execute_method+0x190/0x248
>     [<b02c1f8b>] acpi_ns_evaluate+0xc7/0x179
>     [<b02c1abd>] acpi_evaluate_object+0xd1/0x1c0
>     [<b02ad0aa>] acpi_evaluate_integer+0x2a/0x51
>     [<b02cf9de>] thermal_get_temp+0x34/0x5a
>     [<b03f6d49>] thermal_zone_device_update+0x29/0x2a0
>     [<b03f6fcd>] thermal_zone_device_check+0xd/0x10
>     [<b013bd2c>] process_one_work+0x18c/0x3c0
>     [<b013e697>] worker_thread+0x107/0x310
>     [<b0141cac>] kthread+0x7c/0x90
>     [<b055e102>] kernel_thread_helper+0x6/0xd
> unreferenced object 0xedcb8a90 (size 32):
>   comm "kworker/0:2", pid 389, jiffies 4294915210 (age 649.869s)
>   hex dump (first 32 bytes):
>     00 80 cb ed 0d 01 70 00 14 00 00 00 00 00 00 00  ......p.........
>     00 00 00 00 40 83 cb ed 00 00 00 00 01 00 00 00  ....@...........
>   backtrace:
>     [<b0551807>] kmemleak_alloc+0x27/0x50
>     [<b0196435>] kmem_cache_alloc+0xc5/0x180
>     [<b02c5faf>] acpi_ps_alloc_op+0x82/0x84
>     [<b02c55d5>] acpi_ps_parse_loop+0x1e9/0x830
>     [<b02c4e1e>] acpi_ps_parse_aml+0x87/0x235
>     [<b02c61b4>] acpi_ps_execute_method+0x190/0x248
>     [<b02c1f8b>] acpi_ns_evaluate+0xc7/0x179
>     [<b02c1abd>] acpi_evaluate_object+0xd1/0x1c0
>     [<b02ad0aa>] acpi_evaluate_integer+0x2a/0x51
>     [<b02cf9de>] thermal_get_temp+0x34/0x5a
>     [<b03f6d49>] thermal_zone_device_update+0x29/0x2a0
>     [<b03f6fcd>] thermal_zone_device_check+0xd/0x10
>     [<b013bd2c>] process_one_work+0x18c/0x3c0
>     [<b013e697>] worker_thread+0x107/0x310
>     [<b0141cac>] kthread+0x7c/0x90
>     [<b055e102>] kernel_thread_helper+0x6/0xd
> unreferenced object 0xedcb8340 (size 32):
>   comm "kworker/0:2", pid 389, jiffies 4294915210 (age 649.869s)
>   hex dump (first 32 bytes):
>     90 8a cb ed 0d 01 2d 00 15 00 00 00 00 00 00 00  ......-.........
>     00 00 00 00 85 17 f8 ef 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<b0551807>] kmemleak_alloc+0x27/0x50
>     [<b0196435>] kmem_cache_alloc+0xc5/0x180
>     [<b02c5faf>] acpi_ps_alloc_op+0x82/0x84
>     [<b02c55d5>] acpi_ps_parse_loop+0x1e9/0x830
>     [<b02c4e1e>] acpi_ps_parse_aml+0x87/0x235
>     [<b02c61b4>] acpi_ps_execute_method+0x190/0x248
>     [<b02c1f8b>] acpi_ns_evaluate+0xc7/0x179
>     [<b02c1abd>] acpi_evaluate_object+0xd1/0x1c0
>     [<b02ad0aa>] acpi_evaluate_integer+0x2a/0x51
>     [<b02cf9de>] thermal_get_temp+0x34/0x5a
>     [<b03f6d49>] thermal_zone_device_update+0x29/0x2a0
>     [<b03f6fcd>] thermal_zone_device_check+0xd/0x10
>     [<b013bd2c>] process_one_work+0x18c/0x3c0
>     [<b013e697>] worker_thread+0x107/0x310
>     [<b0141cac>] kthread+0x7c/0x90
>     [<b055e102>] kernel_thread_helper+0x6/0xd
> 


