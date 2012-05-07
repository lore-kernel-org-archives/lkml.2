Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab2EGPwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:52:07 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53909 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756284Ab2EGPwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:52:05 -0400
X-Sasl-enc: c0p45aH+O+FQUL7gNXdTmaDjeZwe39aaJAxD4HPPHN61 1336405923
Date: Mon, 7 May 2012 08:52:02 -0700
From: Greg KH <greg@kroah.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: mchehab@redhat.com, bp@amd64.org, tony.luck@intel.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V3] edac: avoid mce decoding crash after edac driver
 unloaded
Message-ID: <20120507155202.GA3934@kroah.com>
References: <1336374233-11482-1-git-send-email-gong.chen@linux.intel.com>
 <1336395950-12430-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336395950-12430-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 09:05:50PM +0800, Chen Gong wrote:
> Some edac drivers register themselves as mce decoders via
> notifier_chain. But in current notifier_chain implementation logic,
> it doesn't accept same notifier registered twice. If so, it will be
> wrong when adding/removing the element from the list. For example,
> on one SandyBridge platform, remove module sb_edac and then trigger
> one error, it will hit oops because it has no mce decoder registered
> but related notifier_chain still points to an invalid callback
> function. Here is an example:
> 
> Call Trace:
>  [<ffffffff8150ef6a>] atomic_notifier_call_chain+0x1a/0x20
>  [<ffffffff8102b936>] mce_log+0x46/0x180
>  [<ffffffff8102eaea>] apei_mce_report_mem_error+0x4a/0x60
>  [<ffffffff812e19d2>] ghes_do_proc+0x192/0x210
>  [<ffffffff812e2066>] ghes_proc+0x46/0x70
>  [<ffffffff812e20d8>] ghes_notify_sci+0x48/0x80
>  [<ffffffff8150ef05>] notifier_call_chain+0x55/0x80
>  [<ffffffff81076f1a>] __blocking_notifier_call_chain+0x5a/0x80
>  [<ffffffff812aea11>] ? acpi_os_wait_events_complete+0x23/0x23
>  [<ffffffff81076f56>] blocking_notifier_call_chain+0x16/0x20
>  [<ffffffff812ddc4d>] acpi_hed_notify+0x19/0x1b
>  [<ffffffff812b16bd>] acpi_device_notify+0x19/0x1b
>  [<ffffffff812beb38>] acpi_ev_notify_dispatch+0x67/0x7f
>  [<ffffffff812aea3a>] acpi_os_execute_deferred+0x29/0x36
>  [<ffffffff81069dc2>] process_one_work+0x132/0x450
>  [<ffffffff8106bbcb>] worker_thread+0x17b/0x3c0
>  [<ffffffff8106ba50>] ? manage_workers+0x120/0x120
>  [<ffffffff81070aee>] kthread+0x9e/0xb0
>  [<ffffffff81514724>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81070a50>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff81514720>] ? gs_change+0x13/0x13
> Code: f3 49 89 d4 45 85 ed 4d 89 c6 48 8b 0f 74 48 48 85 c9 75 17 eb 41
> 0f 1f 80 00 00 00 00 41 83 ed 01 4c 89 f9 74 22 4d 85 ff 74 1d <4c> 8b
> 79 08 4c 89 e2 48 89 de 48 89 cf ff 11 4d 85 f6 74 04 41
> RIP  [<ffffffff8150eef6>] notifier_call_chain+0x46/0x80
>  RSP <ffff88042868fb20>
> CR2: ffffffffa01af838
> ---[ end trace 0100930068e73e6f ]---
> BUG: unable to handle kernel paging request at fffffffffffffff8
> IP: [<ffffffff810705b0>] kthread_data+0x10/0x20
> PGD 1a0d067 PUD 1a0e067 PMD 0
> Oops: 0000 [#2] SMP
> 
> Only i7core_edac and sb_edac have such issues because they have more
> than one memory controller which means they have to register mce
> decoder many times.
> 
> v3->v2:
>   remove dead code in i7core_edac, suggested by Mauro
> 
> v2->v1:
>   move register/unregister to the init/exit part
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> ---
>  drivers/edac/i7core_edac.c |   15 ++++-----------
>  drivers/edac/sb_edac.c     |    8 ++++----
>  2 files changed, 8 insertions(+), 15 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
