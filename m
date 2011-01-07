Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1AGQzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:55:51 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:39855 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab1AGQzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:55:49 -0500
Subject: [PATCH 2/3] hpsa: Fix problem that CMD_UNABORTABLE command status was
	treated as unknown
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com,
        akpm@linux-foundation.org, smcameron@yahoo.com
Date: Fri, 07 Jan 2011 10:55:48 -0600
Message-ID: <20110107165548.14259.50339.stgit@beardog.cce.hp.com>
In-Reply-To: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
References: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <StephenM.Cameron>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c6c13b0..5828bcb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1152,6 +1152,10 @@ static void complete_scsi_command(struct CommandList *cp,
 		cmd->result = DID_TIME_OUT << 16;
 		dev_warn(&h->pdev->dev, "cp %p timedout\n", cp);
 		break;
+	case CMD_UNABORTABLE:
+		cmd->result = DID_ERROR << 16;
+		dev_warn(&h->pdev->dev, "Command unabortable\n");
+		break;
 	default:
 		cmd->result = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "cp %p returned unknown status %x\n",
@@ -1317,6 +1321,9 @@ static void hpsa_scsi_interpret_error(struct CommandList *cp)
 	case CMD_TIMEOUT:
 		dev_warn(d, "cp %p timed out\n", cp);
 		break;
+	case CMD_UNABORTABLE:
+		dev_warn(d, "Command unabortable\n");
+		break;
 	default:
 		dev_warn(d, "cp %p returned unknown status %x\n", cp,
 				ei->CommandStatus);

