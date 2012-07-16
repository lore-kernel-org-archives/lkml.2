Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab2GPWRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:17:18 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:58367 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2GPWRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:17:12 -0400
From: Marek Vasut <marex@denx.de>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH V2] [SCSI] async: Fixup arguments of async_synchronize_full_domain in alsa-soc
Date: Tue, 17 Jul 2012 00:17:06 +0200
Message-Id: <1342477026-8376-1-git-send-email-marex@denx.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This caused the following crash:

[    3.950000] sgtl5000 0-000a: Using internal LDO instead of VDDD
[    3.960000] sgtl5000 0-000a: sgtl5000 revision 0x11
[    3.970000] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[    3.970000] pgd = c0004000
[    3.970000] [00000000] *pgd=00000000
[    3.970000] Internal error: Oops: 817 [#1] ARM
[    3.970000] Modules linked in:
[    3.970000] CPU: 0    Not tainted  (3.5.0-rc7-next-20120716-00024-g47a3902-dirty #1814)
[    3.970000] PC is at async_run_entry_fn+0x3c/0x1cc
[    3.970000] LR is at process_one_work+0x12c/0x3c8
[    3.970000] pc : [<c0039a84>]    lr : [<c002ead8>]    psr: 60000093
[    3.970000] sp : c74fff38  ip : 00000000  fp : c74fe000
[    3.970000] r10: c7447d98  r9 : c2fc7f40  r8 : c2fc7f48
[    3.970000] r7 : c0039a48  r6 : c7403e00  r5 : c74f7d40  r4 : c2fc7f48
[    3.970000] r3 : 60000013  r2 : 00000000  r1 : c2fc7f80  r0 : c7447da0
[    3.970000] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    3.970000] Control: 0005317f  Table: 42fd0000  DAC: 00000017
[    3.970000] Process kworker/u:1 (pid: 16, stack limit = 0xc74fe270)
[    3.970000] Stack: (0xc74fff38 to 0xc7500000)
[    3.970000] ff20:                                                       c06480d4 c003afe4
[    3.970000] ff40: 00000001 c7444e60 a0000093 00000000 c2fc7f48 c74f7d40 c7403e00 c0039a48
[    3.970000] ff60: 00000000 00000000 c06480d4 c002ead8 00000000 c745bf1c 00000001 c74f7d40
[    3.970000] ff80: c06480d4 c74f7d50 c74fe000 c05ff124 c06255d9 c0647fc4 00000089 c002f518
[    3.970000] ffa0: 00000013 00000000 00000000 c745bf14 c74f7d40 c002f3b4 00000013 00000000
[    3.970000] ffc0: 00000000 00000000 00000000 c00335d8 00000000 00000000 c74f7d40 00000000
[    3.970000] ffe0: c74fffe0 c74fffe0 c745bf14 c0033554 c000fb70 c000fb70 ffbbfaa5 eaeafefe
[    3.970000] [<c0039a84>] (async_run_entry_fn+0x3c/0x1cc) from [<c002ead8>] (process_one_work+0x12c/0x3c8)
[    3.970000] [<c002ead8>] (process_one_work+0x12c/0x3c8) from [<c002f518>] (worker_thread+0x164/0x36c)
[    3.970000] [<c002f518>] (worker_thread+0x164/0x36c) from [<c00335d8>] (kthread+0x84/0x90)
[    3.970000] [<c00335d8>] (kthread+0x84/0x90) from [<c000fb70>] (kernel_thread_exit+0x0/0x8)
[    3.970000] Code: e59a200c e28a0008 e58a900c e9080005 (e5829000)
[    3.970000] ---[ end trace 7e75d80e67ab9651 ]---

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: <alsa-devel@alsa-project.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: James Bottomley <JBottomley@Parallels.com>
---
 sound/soc/soc-dapm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

V2: CC proper people, hopefully proper mailing list
    Adjust the patch subject with proper tags

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index eded657..e491eb0 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1572,7 +1572,7 @@ static int dapm_power_widgets(struct snd_soc_dapm_context *dapm, int event)
 	struct snd_soc_dapm_context *d;
 	LIST_HEAD(up_list);
 	LIST_HEAD(down_list);
-	LIST_HEAD(async_domain);
+	ASYNC_DOMAIN_EXCLUSIVE(async_domain);
 	enum snd_soc_bias_level bias;
 
 	trace_snd_soc_dapm_start(card);
-- 
1.7.10.4

