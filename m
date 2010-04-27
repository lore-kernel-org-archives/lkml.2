Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab0D0Hr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:47:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61258 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab0D0HrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:47:25 -0400
Message-ID: <4BD696FA.30009@cn.fujitsu.com>
Date: Tue, 27 Apr 2010 15:49:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH 5/6] xconfig: remove unused function
References: <4BD696C0.8050500@cn.fujitsu.com>
In-Reply-To: <4BD696C0.8050500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove ConfigInfoView::setSource().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/qconf.cc |   28 ----------------------------
 scripts/kconfig/qconf.h  |    1 -
 2 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 00c5150..d950fff 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -964,34 +964,6 @@ void ConfigInfoView::setInfo(struct menu *m)
 		menuInfo();
 }
 
-void ConfigInfoView::setSource(const QString& name)
-{
-	const char *p = name.latin1();
-
-	menu = NULL;
-	sym = NULL;
-
-	switch (p[0]) {
-	case 'm':
-		struct menu *m;
-
-		if (sscanf(p, "m%p", &m) == 1 && menu != m) {
-			menu = m;
-			menuInfo();
-			emit menuSelected(menu);
-		}
-		break;
-	case 's':
-		struct symbol *s;
-
-		if (sscanf(p, "s%p", &s) == 1 && sym != s) {
-			sym = s;
-			symbolInfo();
-		}
-		break;
-	}
-}
-
 void ConfigInfoView::symbolInfo(void)
 {
 	QString str;
diff --git a/scripts/kconfig/qconf.h b/scripts/kconfig/qconf.h
index b3b5657..54775ae 100644
--- a/scripts/kconfig/qconf.h
+++ b/scripts/kconfig/qconf.h
@@ -254,7 +254,6 @@ public:
 public slots:
 	void setInfo(struct menu *menu);
 	void saveSettings(void);
-	void setSource(const QString& name);
 	void setShowDebug(bool);
 
 signals:
-- 
1.6.3

