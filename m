Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab2HWFLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 01:11:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58755 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2HWFLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 01:11:04 -0400
Message-ID: <5035BB4D.4020900@gmail.com>
Date: Thu, 23 Aug 2012 13:10:37 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Philip Rakity <prakity@marvell.com>, linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: v3.6-rc1: modprobe hangs with sdhci failure on dell e6410
References: <5034E895.4050105@broadcom.com>
In-Reply-To: <5034E895.4050105@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 10:11 PM, Arend van Spriel wrote:
> A quick search using google did not provide clues. Regardless if there 
> is anything inserted the hang occurs.

your dmesg shows:

[  241.908294] INFO: task modprobe:134 blocked for more than 120 seconds.
[  241.908298] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  241.908301] modprobe        D f48abbcc     0   134     98 0x00000000
[  241.908307]  f48abc3c 00000082 f59d0ebc f48abbcc c1289228 00000000 f4f3e480 c17b0380
[  241.908313]  c17b0380 c17b0380 1de51926 00000000 c17b0380 f59d5380 f4f3e480 f4853ed0
[  241.908319]  00000000 00000001 f48abc28 00000000 f59d0eb0 f4df3131 c17abe80 00000003
[  241.908326] Call Trace:
[  241.908337]  [<c1289228>] ? timerqueue_add+0x58/0xb0
[  241.908345]  [<c14ca103>] schedule+0x23/0x60
[  241.908349]  [<c14c8f5f>] schedule_hrtimeout_range_clock+0xaf/0x130
[  241.908354]  [<c105b4f0>] ? update_rmtp+0x80/0x80
[  241.908359]  [<c105c796>] ? hrtimer_start_range_ns+0x26/0x30
[  241.908362]  [<c14c8ff7>] schedule_hrtimeout_range+0x17/0x20
[  241.908369]  [<c10462c9>] usleep_range+0x39/0x40
[  241.908384]  [<f8030b39>] sdhci_do_start_signal_voltage_switch+0x59/0x150 [sdhci]
[  241.908390]  [<f8030c71>] sdhci_start_signal_voltage_switch+0x41/0x80 [sdhci]
[  241.908401]  [<f805ded8>] mmc_set_signal_voltage+0x58/0xb0 [mmc_core]
[  241.908411]  [<f805e105>] mmc_power_up+0x85/0xf0 [mmc_core]
[  241.908420]  [<f805e1a8>] mmc_start_host+0x38/0x50 [mmc_core]
[  241.908430]  [<f805f4b0>] mmc_add_host+0x50/0x90 [mmc_core]
[  241.908436]  [<f8031b37>] sdhci_add_host+0x837/0xbc0 [sdhci]
[  241.908444]  [<f807f10a>] sdhci_pci_probe+0x3fc/0x5f0 [sdhci_pci]
[  241.908449]  [<c14cac5f>] ? _raw_spin_lock_irqsave+0x2f/0x50
[  241.908455]  [<c12a5407>] local_pci_probe+0x47/0xb0
[  241.908460]  [<c12a6458>] pci_device_probe+0x68/0x90
[  241.908467]  [<c1337c48>] driver_probe_device+0x78/0x1f0
[  241.908471]  [<c12a5393>] ? pci_match_device+0xb3/0xc0
[  241.908476]  [<c1337e41>] __driver_attach+0x81/0x90
[  241.908480]  [<c1336613>] bus_for_each_dev+0x53/0x80
[  241.908484]  [<c1337abe>] driver_attach+0x1e/0x20
[  241.908488]  [<c1337dc0>] ? driver_probe_device+0x1f0/0x1f0
[  241.908491]  [<c1337512>] bus_add_driver+0xb2/0x230
[  241.908495]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  241.908499]  [<c12a62d0>] ? pci_dev_put+0x20/0x20
[  241.908502]  [<c133841a>] driver_register+0x6a/0x140
[  241.908509]  [<c10be41b>] ? tracepoint_module_notify+0x12b/0x190
[  241.908514]  [<c12a6694>] __pci_register_driver+0x44/0xb0
[  241.908522]  [<f8086017>] sdhci_drv_init+0x17/0x19 [sdhci_pci]
[  241.908526]  [<c1001114>] do_one_initcall+0x34/0x170
[  241.908532]  [<f8086000>] ? 0xf8085fff
[  241.908539]  [<c1090c3e>] sys_init_module+0xee/0x1460
[  241.908542]  [<c108f620>] ? free_notes_attrs+0x50/0x50
[  241.908549]  [<f8073000>] ? 0xf8072fff
[  241.908556]  [<c14d175f>] sysenter_do_call+0x12/0x28

Looks like the usleep_range called in
sdhci_do_start_signal_voltage_switch blocked modprobe, maybe the timeout
never happens for whatever reason?

Can you please try the following patch:

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 8ac5246..30ce05d 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1212,6 +1212,9 @@ static void mmc_power_up(struct mmc_host *host)
 	host->ios.timing = MMC_TIMING_LEGACY;
 	mmc_set_ios(host);
 
+	/* debug */
+	usleep_range(5000, 5500);
+
 	/* Set signal voltage to 3.3V */
 	mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_330, false);
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9a11dc3..a181c46 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1616,7 +1616,8 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 	 * to 3.3V. If so, we change the voltage to 3.3V and return quickly.
 	 */
 	ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
-	if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_330) {
+	if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_330 &&
+			(ctrl & SDHCI_CTRL_VDD_180)) {
 		/* Set 1.8V Signal Enable in the Host Control2 register to 0 */
 		ctrl &= ~SDHCI_CTRL_VDD_180;
 		sdhci_writew(host, ctrl, SDHCI_HOST_CONTROL2);


The above code did 2 things:
1 calling usleep_range in another place to see what happened;
2 avoid setting 3.3v signalling voltage if host is already at 3.3v
signalling voltage.

Thanks,
Aaron
