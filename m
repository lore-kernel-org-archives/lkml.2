Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab2IDOGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:06:13 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43099 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2IDOGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:06:11 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] rts_pstor: Fix invalid check
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 04 Sep 2012 15:23:46 +0100
Message-ID: <20120904142335.5597.21406.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

As noted by David Binderman

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=46581
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/rts_pstor/rtsx_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts_pstor/rtsx_scsi.c b/drivers/staging/rts_pstor/rtsx_scsi.c
index f2e5842..936b82d 100644
--- a/drivers/staging/rts_pstor/rtsx_scsi.c
+++ b/drivers/staging/rts_pstor/rtsx_scsi.c
@@ -2482,7 +2482,7 @@ static int spi_vendor_cmd(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 gpio_dir;
 
-	if (CHECK_PID(chip, 0x5208) && CHECK_PID(chip, 0x5288)) {
+	if (CHECK_PID(chip, 0x5208) || CHECK_PID(chip, 0x5288)) {
 		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}

