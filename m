Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700Ab1FWRyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:54:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:35260 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664Ab1FWRh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Przemyslaw Bruski <pbruskispam@op.pl>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 191/247] ALSA: ctxfi - Clear input settings before initialization
Date: Thu, 23 Jun 2011 13:34:19 -0400
Message-Id: <1308850515-15242-132-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Przemyslaw Bruski <pbruskispam@op.pl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit efed5f26664f93991c929d5bb343e65f900d72bc upstream.

Clear input settings before initialization.

Signed-off-by: Przemyslaw Bruski <pbruskispam@op.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/ctxfi/ctdaio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index af56eb9..47d9ea9 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -176,6 +176,7 @@ static int dao_set_left_input(struct dao *dao, struct rsc *input)
 	if (!entry)
 		return -ENOMEM;
 
+	dao->ops->clear_left_input(dao);
 	/* Program master and conjugate resources */
 	input->ops->master(input);
 	daio->rscl.ops->master(&daio->rscl);
@@ -204,6 +205,7 @@ static int dao_set_right_input(struct dao *dao, struct rsc *input)
 	if (!entry)
 		return -ENOMEM;
 
+	dao->ops->clear_right_input(dao);
 	/* Program master and conjugate resources */
 	input->ops->master(input);
 	daio->rscr.ops->master(&daio->rscr);
-- 
1.7.4.4

