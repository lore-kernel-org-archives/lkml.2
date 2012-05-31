Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2EaUvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:51:23 -0400
Received: from mail.acc.umu.se ([130.239.18.156]:51214 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab2EaUvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:51:21 -0400
X-Greylist: delayed 657 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 16:51:21 EDT
From: Marcus Karlsson <mk@acc.umu.se>
To: gregkh@linuxfoundation.org
Cc: thomas@m3y3r.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marcus Karlsson <mk@acc.umu.se>
Subject: [PATCH] staging: rts_pstor: fixed some coding style errors
Date: Thu, 31 May 2012 22:39:59 +0200
Message-Id: <1338496799-13437-1-git-send-email-mk@acc.umu.se>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some code styling errors in the following files:

drivers/staging/rts_pstor/rtsx_scsi.c:
* multiple statements on single line

drivers/staging/rts_pstor/trace.h:
* trailing whitespace
* non-enclosed macro

drivers/staging/rts_pstor/xd.c:
* trailing whitespace

Signed-off-by: Marcus Karlsson <mk@acc.umu.se>
---
 drivers/staging/rts_pstor/rtsx_scsi.c |  359 ++++++++++++++++++++++++---------
 drivers/staging/rts_pstor/trace.h     |    5 +-
 drivers/staging/rts_pstor/xd.c        |    1 -
 3 files changed, 271 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx_scsi.c b/drivers/staging/rts_pstor/rtsx_scsi.c
index f2e5842..f67ab9d 100644
--- a/drivers/staging/rts_pstor/rtsx_scsi.c
+++ b/drivers/staging/rts_pstor/rtsx_scsi.c
@@ -41,98 +41,277 @@ void scsi_show_command(struct scsi_cmnd *srb)
 	int i, unknown_cmd = 0;
 
 	switch (srb->cmnd[0]) {
-	case TEST_UNIT_READY: what = "TEST_UNIT_READY"; break;
-	case REZERO_UNIT: what = "REZERO_UNIT"; break;
-	case REQUEST_SENSE: what = "REQUEST_SENSE"; break;
-	case FORMAT_UNIT: what = "FORMAT_UNIT"; break;
-	case READ_BLOCK_LIMITS: what = "READ_BLOCK_LIMITS"; break;
-	case REASSIGN_BLOCKS: what = "REASSIGN_BLOCKS"; break;
-	case READ_6: what = "READ_6"; break;
-	case WRITE_6: what = "WRITE_6"; break;
-	case SEEK_6: what = "SEEK_6"; break;
-	case READ_REVERSE: what = "READ_REVERSE"; break;
-	case WRITE_FILEMARKS: what = "WRITE_FILEMARKS"; break;
-	case SPACE: what = "SPACE"; break;
-	case INQUIRY: what = "INQUIRY"; break;
-	case RECOVER_BUFFERED_DATA: what = "RECOVER_BUFFERED_DATA"; break;
-	case MODE_SELECT: what = "MODE_SELECT"; break;
-	case RESERVE: what = "RESERVE"; break;
-	case RELEASE: what = "RELEASE"; break;
-	case COPY: what = "COPY"; break;
-	case ERASE: what = "ERASE"; break;
-	case MODE_SENSE: what = "MODE_SENSE"; break;
-	case START_STOP: what = "START_STOP"; break;
-	case RECEIVE_DIAGNOSTIC: what = "RECEIVE_DIAGNOSTIC"; break;
-	case SEND_DIAGNOSTIC: what = "SEND_DIAGNOSTIC"; break;
-	case ALLOW_MEDIUM_REMOVAL: what = "ALLOW_MEDIUM_REMOVAL"; break;
-	case SET_WINDOW: what = "SET_WINDOW"; break;
-	case READ_CAPACITY: what = "READ_CAPACITY"; break;
-	case READ_10: what = "READ_10"; break;
-	case WRITE_10: what = "WRITE_10"; break;
-	case SEEK_10: what = "SEEK_10"; break;
-	case WRITE_VERIFY: what = "WRITE_VERIFY"; break;
-	case VERIFY: what = "VERIFY"; break;
-	case SEARCH_HIGH: what = "SEARCH_HIGH"; break;
-	case SEARCH_EQUAL: what = "SEARCH_EQUAL"; break;
-	case SEARCH_LOW: what = "SEARCH_LOW"; break;
-	case SET_LIMITS: what = "SET_LIMITS"; break;
-	case READ_POSITION: what = "READ_POSITION"; break;
-	case SYNCHRONIZE_CACHE: what = "SYNCHRONIZE_CACHE"; break;
-	case LOCK_UNLOCK_CACHE: what = "LOCK_UNLOCK_CACHE"; break;
-	case READ_DEFECT_DATA: what = "READ_DEFECT_DATA"; break;
-	case MEDIUM_SCAN: what = "MEDIUM_SCAN"; break;
-	case COMPARE: what = "COMPARE"; break;
-	case COPY_VERIFY: what = "COPY_VERIFY"; break;
-	case WRITE_BUFFER: what = "WRITE_BUFFER"; break;
-	case READ_BUFFER: what = "READ_BUFFER"; break;
-	case UPDATE_BLOCK: what = "UPDATE_BLOCK"; break;
-	case READ_LONG: what = "READ_LONG"; break;
-	case WRITE_LONG: what = "WRITE_LONG"; break;
-	case CHANGE_DEFINITION: what = "CHANGE_DEFINITION"; break;
-	case WRITE_SAME: what = "WRITE_SAME"; break;
-	case GPCMD_READ_SUBCHANNEL: what = "READ SUBCHANNEL"; break;
-	case READ_TOC: what = "READ_TOC"; break;
-	case GPCMD_READ_HEADER: what = "READ HEADER"; break;
-	case GPCMD_PLAY_AUDIO_10: what = "PLAY AUDIO (10)"; break;
-	case GPCMD_PLAY_AUDIO_MSF: what = "PLAY AUDIO MSF"; break;
+	case TEST_UNIT_READY:
+		what = "TEST_UNIT_READY";
+		break;
+	case REZERO_UNIT:
+		what = "REZERO_UNIT";
+		break;
+	case REQUEST_SENSE:
+		what = "REQUEST_SENSE";
+		break;
+	case FORMAT_UNIT:
+		what = "FORMAT_UNIT";
+		break;
+	case READ_BLOCK_LIMITS:
+		what = "READ_BLOCK_LIMITS";
+		break;
+	case REASSIGN_BLOCKS:
+		what = "REASSIGN_BLOCKS";
+		break;
+	case READ_6:
+		what = "READ_6";
+		break;
+	case WRITE_6:
+		what = "WRITE_6";
+		break;
+	case SEEK_6:
+		what = "SEEK_6";
+		break;
+	case READ_REVERSE:
+		what = "READ_REVERSE";
+		break;
+	case WRITE_FILEMARKS:
+		what = "WRITE_FILEMARKS";
+		break;
+	case SPACE:
+		what = "SPACE";
+		break;
+	case INQUIRY:
+		what = "INQUIRY";
+		break;
+	case RECOVER_BUFFERED_DATA:
+		what = "RECOVER_BUFFERED_DATA";
+		break;
+	case MODE_SELECT:
+		what = "MODE_SELECT";
+		break;
+	case RESERVE:
+		what = "RESERVE";
+		break;
+	case RELEASE:
+		what = "RELEASE";
+		break;
+	case COPY:
+		what = "COPY";
+		break;
+	case ERASE:
+		what = "ERASE";
+		break;
+	case MODE_SENSE:
+		what = "MODE_SENSE";
+		break;
+	case START_STOP:
+		what = "START_STOP";
+		break;
+	case RECEIVE_DIAGNOSTIC:
+		what = "RECEIVE_DIAGNOSTIC";
+		break;
+	case SEND_DIAGNOSTIC:
+		what = "SEND_DIAGNOSTIC";
+		break;
+	case ALLOW_MEDIUM_REMOVAL:
+		what = "ALLOW_MEDIUM_REMOVAL";
+		break;
+	case SET_WINDOW:
+		what = "SET_WINDOW";
+		break;
+	case READ_CAPACITY:
+		what = "READ_CAPACITY";
+		break;
+	case READ_10:
+		what = "READ_10";
+		break;
+	case WRITE_10:
+		what = "WRITE_10";
+		break;
+	case SEEK_10:
+		what = "SEEK_10";
+		break;
+	case WRITE_VERIFY:
+		what = "WRITE_VERIFY";
+		break;
+	case VERIFY:
+		what = "VERIFY";
+		break;
+	case SEARCH_HIGH:
+		what = "SEARCH_HIGH";
+		break;
+	case SEARCH_EQUAL:
+		what = "SEARCH_EQUAL";
+		break;
+	case SEARCH_LOW:
+		what = "SEARCH_LOW";
+		break;
+	case SET_LIMITS:
+		what = "SET_LIMITS";
+		break;
+	case READ_POSITION:
+		what = "READ_POSITION";
+		break;
+	case SYNCHRONIZE_CACHE:
+		what = "SYNCHRONIZE_CACHE";
+		break;
+	case LOCK_UNLOCK_CACHE:
+		what = "LOCK_UNLOCK_CACHE";
+		break;
+	case READ_DEFECT_DATA:
+		what = "READ_DEFECT_DATA";
+		break;
+	case MEDIUM_SCAN:
+		what = "MEDIUM_SCAN";
+		break;
+	case COMPARE:
+		what = "COMPARE";
+		break;
+	case COPY_VERIFY:
+		what = "COPY_VERIFY";
+		break;
+	case WRITE_BUFFER:
+		what = "WRITE_BUFFER";
+		break;
+	case READ_BUFFER:
+		what = "READ_BUFFER";
+		break;
+	case UPDATE_BLOCK:
+		what = "UPDATE_BLOCK";
+		break;
+	case READ_LONG:
+		what = "READ_LONG";
+		break;
+	case WRITE_LONG:
+		what = "WRITE_LONG";
+		break;
+	case CHANGE_DEFINITION:
+		what = "CHANGE_DEFINITION";
+		break;
+	case WRITE_SAME:
+		what = "WRITE_SAME";
+		break;
+	case GPCMD_READ_SUBCHANNEL:
+		what = "READ SUBCHANNEL";
+		break;
+	case READ_TOC:
+		what = "READ_TOC";
+		break;
+	case GPCMD_READ_HEADER:
+		what = "READ HEADER";
+		break;
+	case GPCMD_PLAY_AUDIO_10:
+		what = "PLAY AUDIO (10)";
+		break;
+	case GPCMD_PLAY_AUDIO_MSF:
+		what = "PLAY AUDIO MSF";
+		break;
 	case GPCMD_GET_EVENT_STATUS_NOTIFICATION:
-		what = "GET EVENT/STATUS NOTIFICATION"; break;
-	case GPCMD_PAUSE_RESUME: what = "PAUSE/RESUME"; break;
-	case LOG_SELECT: what = "LOG_SELECT"; break;
-	case LOG_SENSE: what = "LOG_SENSE"; break;
-	case GPCMD_STOP_PLAY_SCAN: what = "STOP PLAY/SCAN"; break;
-	case GPCMD_READ_DISC_INFO: what = "READ DISC INFORMATION"; break;
+		what = "GET EVENT/STATUS NOTIFICATION";
+		break;
+	case GPCMD_PAUSE_RESUME:
+		what = "PAUSE/RESUME";
+		break;
+	case LOG_SELECT:
+		what = "LOG_SELECT";
+		break;
+	case LOG_SENSE:
+		what = "LOG_SENSE";
+		break;
+	case GPCMD_STOP_PLAY_SCAN:
+		what = "STOP PLAY/SCAN";
+		break;
+	case GPCMD_READ_DISC_INFO:
+		what = "READ DISC INFORMATION";
+		break;
 	case GPCMD_READ_TRACK_RZONE_INFO:
-		what = "READ TRACK INFORMATION"; break;
-	case GPCMD_RESERVE_RZONE_TRACK: what = "RESERVE TRACK"; break;
-	case GPCMD_SEND_OPC: what = "SEND OPC"; break;
-	case MODE_SELECT_10: what = "MODE_SELECT_10"; break;
-	case GPCMD_REPAIR_RZONE_TRACK: what = "REPAIR TRACK"; break;
-	case 0x59: what = "READ MASTER CUE"; break;
-	case MODE_SENSE_10: what = "MODE_SENSE_10"; break;
-	case GPCMD_CLOSE_TRACK: what = "CLOSE TRACK/SESSION"; break;
-	case 0x5C: what = "READ BUFFER CAPACITY"; break;
-	case 0x5D: what = "SEND CUE SHEET"; break;
-	case GPCMD_BLANK: what = "BLANK"; break;
-	case REPORT_LUNS: what = "REPORT LUNS"; break;
-	case MOVE_MEDIUM: what = "MOVE_MEDIUM or PLAY AUDIO (12)"; break;
-	case READ_12: what = "READ_12"; break;
-	case WRITE_12: what = "WRITE_12"; break;
-	case WRITE_VERIFY_12: what = "WRITE_VERIFY_12"; break;
-	case SEARCH_HIGH_12: what = "SEARCH_HIGH_12"; break;
-	case SEARCH_EQUAL_12: what = "SEARCH_EQUAL_12"; break;
-	case SEARCH_LOW_12: what = "SEARCH_LOW_12"; break;
-	case SEND_VOLUME_TAG: what = "SEND_VOLUME_TAG"; break;
-	case READ_ELEMENT_STATUS: what = "READ_ELEMENT_STATUS"; break;
-	case GPCMD_READ_CD_MSF: what = "READ CD MSF"; break;
-	case GPCMD_SCAN: what = "SCAN"; break;
-	case GPCMD_SET_SPEED: what = "SET CD SPEED"; break;
-	case GPCMD_MECHANISM_STATUS: what = "MECHANISM STATUS"; break;
-	case GPCMD_READ_CD: what = "READ CD"; break;
-	case 0xE1: what = "WRITE CONTINUE"; break;
-	case WRITE_LONG_2: what = "WRITE_LONG_2"; break;
-	case VENDOR_CMND: what = "Realtek's vendor command"; break;
-	default: what = "(unknown command)"; unknown_cmd = 1; break;
+		what = "READ TRACK INFORMATION";
+		break;
+	case GPCMD_RESERVE_RZONE_TRACK:
+		what = "RESERVE TRACK";
+		break;
+	case GPCMD_SEND_OPC:
+		what = "SEND OPC";
+		break;
+	case MODE_SELECT_10:
+		what = "MODE_SELECT_10";
+		break;
+	case GPCMD_REPAIR_RZONE_TRACK:
+		what = "REPAIR TRACK";
+		break;
+	case 0x59:
+		what = "READ MASTER CUE";
+		break;
+	case MODE_SENSE_10:
+		what = "MODE_SENSE_10";
+		break;
+	case GPCMD_CLOSE_TRACK:
+		what = "CLOSE TRACK/SESSION";
+		break;
+	case 0x5C:
+		what = "READ BUFFER CAPACITY";
+		break;
+	case 0x5D:
+		what = "SEND CUE SHEET";
+		break;
+	case GPCMD_BLANK:
+		what = "BLANK";
+		break;
+	case REPORT_LUNS:
+		what = "REPORT LUNS";
+		break;
+	case MOVE_MEDIUM:
+		what = "MOVE_MEDIUM or PLAY AUDIO (12)";
+		break;
+	case READ_12:
+		what = "READ_12";
+		break;
+	case WRITE_12:
+		what = "WRITE_12";
+		break;
+	case WRITE_VERIFY_12:
+		what = "WRITE_VERIFY_12";
+		break;
+	case SEARCH_HIGH_12:
+		what = "SEARCH_HIGH_12";
+		break;
+	case SEARCH_EQUAL_12:
+		what = "SEARCH_EQUAL_12";
+		break;
+	case SEARCH_LOW_12:
+		what = "SEARCH_LOW_12";
+		break;
+	case SEND_VOLUME_TAG:
+		what = "SEND_VOLUME_TAG";
+		break;
+	case READ_ELEMENT_STATUS:
+		what = "READ_ELEMENT_STATUS";
+		break;
+	case GPCMD_READ_CD_MSF:
+		what = "READ CD MSF";
+		break;
+	case GPCMD_SCAN:
+		what = "SCAN";
+		break;
+	case GPCMD_SET_SPEED:
+		what = "SET CD SPEED";
+		break;
+	case GPCMD_MECHANISM_STATUS:
+		what = "MECHANISM STATUS";
+		break;
+	case GPCMD_READ_CD:
+		what = "READ CD";
+		break;
+	case 0xE1:
+		what = "WRITE CONTINUE";
+		break;
+	case WRITE_LONG_2:
+		what = "WRITE_LONG_2";
+		break;
+	case VENDOR_CMND:
+		what = "Realtek's vendor command";
+		break;
+	default:
+		what = "(unknown command)";
+		unknown_cmd = 1;
+		break;
 	}
 
 	if (srb->cmnd[0] != TEST_UNIT_READY) {
diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
index bc83b49..f014198 100644
--- a/drivers/staging/rts_pstor/trace.h
+++ b/drivers/staging/rts_pstor/trace.h
@@ -39,7 +39,6 @@ static inline char *filename(char *path)
 	while (*ptr != '\0') {
 		if ((*ptr == '\\') || (*ptr == '/'))
 			path = ptr + 1;
-		
 		ptr++;
 	}
 
@@ -78,8 +77,8 @@ do {													\
 	goto label; 											\
 } while (0)
 #else
-#define TRACE_RET(chip, ret)	return ret
-#define TRACE_GOTO(chip, label)	goto label
+#define TRACE_RET(chip, ret)	(return ret)
+#define TRACE_GOTO(chip, label)	(goto label)
 #endif
 
 #ifdef CONFIG_RTS_PSTOR_DEBUG
diff --git a/drivers/staging/rts_pstor/xd.c b/drivers/staging/rts_pstor/xd.c
index 9bba5b1..6b0cec2 100644
--- a/drivers/staging/rts_pstor/xd.c
+++ b/drivers/staging/rts_pstor/xd.c
@@ -1919,7 +1919,6 @@ int xd_rw(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32 start_sector, u16 s
 				set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 			else
 				set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
-			
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 
-- 
1.7.10.2

