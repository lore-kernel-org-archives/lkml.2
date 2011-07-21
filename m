Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1GUJSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:18:50 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57224 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab1GUJSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:18:46 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Vitaliy Ivanov <vitalivanov@gmail.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 02/10] uml: helper.c warning corrections
Date: Thu, 21 Jul 2011 11:18:26 +0200
Message-Id: <1311239914-8301-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311239914-8301-1-git-send-email-richard@nod.at>
References: <1311239914-8301-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaliy Ivanov <vitalivanov@gmail.com>

arch/um/os-Linux/helper.c: In function ‘helper_child’:
arch/um/os-Linux/helper.c:38:7: warning: ignoring return value of ‘write’, declared with attribute warn_unused_result

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
[richard@nod.at: happens only with -D_FORTIFY_SOURCE=2]
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/os-Linux/helper.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index b6b1096..feff22d 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -28,14 +28,14 @@ static int helper_child(void *arg)
 {
 	struct helper_data *data = arg;
 	char **argv = data->argv;
-	int err;
+	int err, ret;
 
 	if (data->pre_exec != NULL)
 		(*data->pre_exec)(data->pre_data);
 	err = execvp_noalloc(data->buf, argv[0], argv);
 
 	/* If the exec succeeds, we don't get here */
-	write(data->fd, &err, sizeof(err));
+	CATCH_EINTR(ret = write(data->fd, &err, sizeof(err)));
 
 	return 0;
 }
-- 
1.7.6

