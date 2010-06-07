Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab0FGDtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 23:49:17 -0400
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:39994 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756053Ab0FGDtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 23:49:15 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: ZzwuY1oVM1n6XYKF5WcTO1WnxoF5oLPdPRTv2xv9hY.E.7X7mNCa8MTp.5Jhnu7NnX6ofRcmE9yyHDY84bSxuov9q1IzapjlQUCTMKAYQam7huabkeapT7yoAacAPltC3jheliX7W3QgyHPN58.jGReByifY0k6NjlwcAyI6eVVxO_cfzNcmoFAkR43uK31ivsTyB74IQwADiRexj8txIb0Vlj_a1Qp82EzE3Ey6fH9S3jgLMYRHDtMK_.MYVe1ztWMZVd.gI1EX4iULdm3ErX4T8Ff8.AHr9CFJfHtWDLbNmWmP35zP3c6PwXakb7rQ.9HAGpopwIeDfdc6SwonKliI_BTxRX0o6TUfNx86foFWZg--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Douglas Gilbert <dgilbert@interlog.com>,
       Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/3] Add proper STGT <-> bs_sg passthrough v3
Date: Sun,  6 Jun 2010 20:50:15 -0700
Message-Id: <1275882615-5354-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greeting STGT folks,

This is the third round of patches for adding proper LUN passthrough support into STGT
using struct scsi_lu->cmd_perform() and struct scsi_lu->cmd_done() callers with existing
SG_IO and the new BSG v4 backstores.

Following Tomo-san's input, the changelog between v2 -> v3 is as follows:

1) Add struct device_type_template sg_template for SG_IO and BSG in usr/bs_sg.c instead
   of making changes to usr/sbc.c

2) Add struct backingstore_template->bs_passthrough member of type int for SG_IO and BSG.

3) In usr/target.c:tgt_device_create() pass bst->bs_passthrough into device_type_lookup()
   and for passthrough case use the new device_type_passthrough() to locate
   struct device_type_template sg_template.

4) Remove unnecessary post_cmd_done() from usr/target.c:__cmd_done_passthrough()

This patch series has been tested with STGT/iSCSI using 'sg'+'bsg' and 'rdwr' for non
passthrough mode backstores into TCM_Loop LLD emulated iSCSI target ports.

Best,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org

Nicholas Bellinger (3):
  [tgt]: Add proper STGT LUN backstore passthrough support (rev 3)
  [tgt]: Add bs_sg struct device_type_template sg_template and struct
    backingstore_template->bs_init()
  [tgt]: Add BSG v4 backstore support to usr/bs_sg.c

 usr/bs_sg.c     |  247 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 usr/scsi_cmnd.h |    7 ++
 usr/target.c    |  113 +++++++++++++++++++++++---
 usr/tgtd.h      |   16 ++++
 4 files changed, 362 insertions(+), 21 deletions(-)

