Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965875Ab2EOCTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:19:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:49827 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965430Ab2EOCR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 146/179] dm mpath: fix potential NULL pointer in feature arg processing
Date: Mon, 14 May 2012 22:14:02 -0400
Message-ID: <1337048075-6132-147-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 286f367dad40beb3234a18c17391d03ba939a7f3 upstream.

Avoid dereferencing a NULL pointer if the number of feature arguments
supplied is fewer than indicated.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/dm-mpath.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index ed1d0c2..78090eb 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -793,6 +793,11 @@ static int parse_features(struct arg_set *as, struct multipath *m)
 	if (!argc)
 		return 0;
 
+	if (argc > as->argc) {
+		ti->error = "not enough arguments for features";
+		return -EINVAL;
+	}
+
 	do {
 		param_name = shift(as);
 		argc--;
-- 
1.7.9.6

