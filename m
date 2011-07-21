Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1GUJSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:18:45 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57220 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab1GUJSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:18:44 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Vitaliy Ivanov <vitalivanov@gmail.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 01/10] uml: cow_user.c warning corrections
Date: Thu, 21 Jul 2011 11:18:25 +0200
Message-Id: <1311239914-8301-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaliy Ivanov <vitalivanov@gmail.com>

arch/um/drivers/cow_user.c: In function ‘absolutize’:
arch/um/drivers/cow_user.c:189:7: warning: ignoring return value of ‘chdir’, declared with attribute warn_unused_result

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
[richard@nod.at: happens only with -D_FORTIFY_SOURCE=2]
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/cow_user.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/cow_user.c b/arch/um/drivers/cow_user.c
index 93f227a..9cbb426 100644
--- a/arch/um/drivers/cow_user.c
+++ b/arch/um/drivers/cow_user.c
@@ -186,7 +186,11 @@ static int absolutize(char *to, int size, char *from)
 		strcat(to, "/");
 		strcat(to, from);
 	}
-	chdir(save_cwd);
+	if (chdir(save_cwd)) {
+		cow_printf("absolutize : Can't cd to '%s' - "
+			   "errno = %d\n", save_cwd, errno);
+		return -1;
+	}
 	return 0;
 }
 
-- 
1.7.6

