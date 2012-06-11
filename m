Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2FKFFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:05:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:58016 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2FKFFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:05:37 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2012 01:05:36 EDT
Message-ID: <4FD57B23.8080409@huawei.com>
Date: Mon, 11 Jun 2012 12:59:15 +0800
From: "Peter Huang(Peng)" <peter.huangpeng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: _spin_unlock_irqrestore() has very high sampling rate when using
 oprofile tool.
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.90.111]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During TPC-C testing on IA64 platform, we binded LGWR process to 1 cpu, and find
 that sys% is over 50%.
With oprofile we find that _spin_unlock_irqrestore() rated over 31%, and try_to_wake_up()
caused this.
I don't understand why unlock operation has high sampling rate, is there anybody know about
this?

Thanks.

-sampling result
CPU: Itanium 2, speed 1.598e+06 MHz (estimated)
Counted CPU_CYCLES events (CPU Cycles) with a unit mask of 0x00 (No unit mask) count 75000
samples  %        app name                 symbol name
53204    31.4940  vmlinux                  _spin_unlock_irqrestore
19788    11.7135  oracle                   kcrfw_redo_write
12804     7.5793  oracle                   $_1$kslpstevent$TAG$GLOB
12004     7.1057  vmlinux                  search_module_extables
8859      5.2441  vmlinux                  search_extable
8150      4.8244  vmlinux                  try_atomic_semop
6121      3.6233  vmlinux                  update_queue
4402      2.6058  scsi_mod                 /scsi_mod
3698      2.1890  vmlinux                  ring_buffer_consume
3069      1.8167  vmlinux                  default_idle
2122      1.2561  oprofile                 /oprofile

-callgraph
CPU: Itanium 2, speed 1.598e+06 MHz (estimated)
Counted CPU_CYCLES events (CPU Cycles) with a unit mask of 0x00 (No unit mask) count 75000
samples  %        image name               app name                 symbol name
-------------------------------------------------------------------------------
  1         0.0021  vmlinux                  vmlinux                  cpufreq_cpu_get
  1         0.0021  vmlinux                  vmlinux                  sys_pfm_start
  1         0.0021  vmlinux                  vmlinux                  try_to_del_timer_sync
  1         0.0021  vmlinux                  vmlinux                  prepare_to_wait
  2         0.0041  vmlinux                  vmlinux                  set_cpus_allowed_ptr
  3         0.0062  vmlinux                  vmlinux                  cpu_quiet_msk
  3         0.0062  vmlinux                  vmlinux                  delayacct_end
  3         0.0062  vmlinux                  vmlinux                  __wake_up
  4         0.0082  vmlinux                  vmlinux                  rcu_process_gp_end
  4         0.0082  vmlinux                  vmlinux                  credit_entropy_bits
  6         0.0123  vmlinux                  vmlinux                  __queue_work
  6         0.0123  vmlinux                  vmlinux                  mod_timer
  23        0.0472  vmlinux                  vmlinux                  dio_bio_end_aio
  26        0.0534  vmlinux                  vmlinux                  __blockdev_direct_IO
  37        0.0760  vmlinux                  vmlinux                  dio_bio_submit
  38        0.0780  vmlinux                  vmlinux                  add_wait_queue_exclusive
  44        0.0903  vmlinux                  vmlinux                  remove_wait_queue
  165       0.3388  vmlinux                  vmlinux                  blk_run_queue
  529       1.0862  vmlinux                  vmlinux                  mix_pool_bytes_extract
  697       1.4312  vmlinux                  vmlinux                  blk_end_bidi_request
  783       1.6077  vmlinux                  vmlinux                  aio_complete
  46325    95.1193  vmlinux                  vmlinux                  try_to_wake_up
53204    31.4940  vmlinux                  vmlinux                  _spin_unlock_irqrestore
