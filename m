Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0EGF4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:56:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab0EGF4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:56:14 -0400
Message-ID: <4BE3ABEC.1090307@cn.fujitsu.com>
Date: Fri, 07 May 2010 13:58:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 7/8] xconfig: clean up
References: <4BE3AB91.80606@cn.fujitsu.com>
In-Reply-To: <4BE3AB91.80606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@ok is a pointer to a bool var, so we should check the value of
*ok. But actually we don't need to check it, so just remove the
if statement.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/qconf.cc |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 00c5150..47cdeae 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -58,11 +58,10 @@ QValueList<int> ConfigSettings::readSizes(const QString& key, bool *ok)
 {
 	QValueList<int> result;
 	QStringList entryList = readListEntry(key, ok);
-	if (ok) {
-		QStringList::Iterator it;
-		for (it = entryList.begin(); it != entryList.end(); ++it)
-			result.push_back((*it).toInt());
-	}
+	QStringList::Iterator it;
+
+	for (it = entryList.begin(); it != entryList.end(); ++it)
+		result.push_back((*it).toInt());
 
 	return result;
 }
-- 
1.6.3

