Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1DEQDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:03:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41801 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1DEQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=LYymiZBETjp4J+5IDQNNd/1JYS8AAn17R34DYX/i+7FqcB4LvqvemV/bGxJT745xAn
         hEMdfNA71G0qXfESpVakTpzDgfezwuadXqnvIe6F2X1OF9kY0b3ZUCDl0BOboO8hBXDl
         yXTSI//GIl1UspAGXbjpBwzRjmGpOkuJqeC0M=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: =?UTF-8?q?=5BRFC=5DDocumentation=3Aaccounting=3Agetdelays=2Ec=20Fix=3A=20warning=3A=20variable=20=E2=80=98i=E2=80=99=20set=20but=20not=20used?=
Date: Tue,  5 Apr 2011 09:02:50 -0700
Message-Id: <1302019370-7101-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch takes care of the warning, but keep in mind am unsure if this is a correct way
to resolve this issue.
Documentation/accounting/getdelays.c: In function ‘main’:
Documentation/accounting/getdelays.c:436:7: warning: variable ‘i’ set but not used [-Wunused-but-set-variable]

Keep in mind there is another warning with this file, but need am unsure what might be the best solution:
Documentation/accounting/getdelays.c: In function ‘get_family_id’:
Documentation/accounting/getdelays.c:172:14: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/accounting/getdelays.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index e9c7778..16e16d5 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -433,8 +433,6 @@ int main(int argc, char *argv[])
 	}
 
 	do {
-		int i;
-
 		rep_len = recv(nl_sd, &msg, sizeof(msg), 0);
 		PRINTF("received %d bytes\n", rep_len);
 
@@ -459,7 +457,6 @@ int main(int argc, char *argv[])
 
 		na = (struct nlattr *) GENLMSG_DATA(&msg);
 		len = 0;
-		i = 0;
 		while (len < rep_len) {
 			len += NLA_ALIGN(na->nla_len);
 			switch (na->nla_type) {
-- 
1.7.4.2

