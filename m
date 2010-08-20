Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab0HTJGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:06:47 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:22190 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751143Ab0HTJGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:06:45 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 8Ob3X7YVM1kyZINWiTtYEK_Fx5x.8cnlr7RY0XTqtXMKgSx
 wTMCbV5h1imMHc1SWPQw9L.tsv4_d80JIfM2_hmZIwqdEEVFE7Z3Cl.PIkKP
 Rsx41VvLoHyd9E5I_hIw0neVipjVUNiPo2Ub_d_rFeNym4ZYq1ighJxLxNZc
 73XN3rFehHMu.BmrKvW6FO0DWZlxEw4uBrYhbAX_SuKJoj0J3PHMnk_Codqy
 _snhwVRzKeu1yLW2nvVA1hGfPwEf85pAlclA6jDpFD_ugv7ulAHhqJOsz301
 9pKUL7oNIYR9_T7ZN7T3I4k4bfb8pvliBAz.MO7K2cNh9YnR2ujqifXYzGTQ
 3qktkW2dbRW7fEDEs6w--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@suse.de>,
        Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/2] tcm/iblock: SCSI LBA -> block_lba conversion for non 512-byte block_size
Date: Fri, 20 Aug 2010 02:06:39 -0700
Message-Id: <1282295199-8838-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings hch, Jens and Co,

This patch adds support for TCM/IBLOCK backstores doing proper non 512-byte native TCM
struct se_task SCSI LBA conversion into 512-byte units in iblock_map_task_SG() for the
starting and subsequent struct bio->bi_sector going into bio_add_page().  The second patch
converts the same function to use for_each_sg() to follow mainline SGL walking conventions.

So far I have been testing these two with TCM_Loop virtual SCSI on top and scsi_debug
below with non 512-byte sector_sized struct scsi_devices, which now appears to be
functioning as expected.  I will need to test this with more combinations of scsi_debug
max_sectors (and will need a patch to make that a module parameter too.. ;) to ensure
N struct se_task mapping in transport_do_se_mem_map() -> transport_map_mem_to_sg() is
functioning as expected for these > 512-byte block_size / sector_size cases.

Please have a look at let me know what you think, and please let me know if there is
anything else that should be considered for this one.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  tcm/iblock: Add SCSI LBA -> block_lba conversion for non 512-byte
    block_size
  tcm/iblock: Convert iblock_map_task_SG() to use for_each_sg()

 drivers/target/target_core_iblock.c |   50 +++++++++++++++++++++++-----------
 1 files changed, 34 insertions(+), 16 deletions(-)

