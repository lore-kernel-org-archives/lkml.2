Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab1IQBtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 21:49:31 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39154 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab1IQBt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 21:49:29 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, gthelen@google.com,
        tartler@cs.fau.de, Dmitry Fink <Dmitry.Fink@palm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH 1/2] kconfig: Add make olddefconfig
Date: Fri, 16 Sep 2011 18:49:18 -0700
Message-Id: <1316224159-3556-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1316224159-3556-1-git-send-email-john.stultz@linaro.org>
References: <1316224159-3556-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an "olddefconfig" build target, which updates a .config file
filling any any absent symbols with the Kconfig default value (note:
not the architecture defconfig value).

Similar to oldnoconfig, this option is useful for build systems
when dealing with config fragments.

CC: gthelen@google.com
CC: tartler@cs.fau.de
CC: Dmitry Fink <Dmitry.Fink@palm.com>
CC: Darren Hart <dvhart@linux.intel.com>
CC: Eric B Munson <ebmunson@us.ibm.com>
CC: Bruce Ashfield <Bruce.Ashfield@windriver.com>
CC: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 scripts/kconfig/Makefile |    2 +-
 scripts/kconfig/conf.c   |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 82d2eb2..c238f3e 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -103,7 +103,7 @@ allnoconfig allyesconfig allmodconfig alldefconfig randconfig: $(obj)/conf
 
 PHONY += listnewconfig oldnoconfig savedefconfig defconfig
 
-listnewconfig oldnoconfig: $(obj)/conf
+listnewconfig oldnoconfig olddefconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
 savedefconfig: $(obj)/conf
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index f208f90..ab7bc68 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -33,6 +33,7 @@ enum input_mode {
 	savedefconfig,
 	listnewconfig,
 	oldnoconfig,
+	olddefconfig,
 } input_mode = oldaskconfig;
 
 static int indent = 1;
@@ -455,6 +456,7 @@ static struct option long_opts[] = {
 	{"randconfig",      no_argument,       NULL, randconfig},
 	{"listnewconfig",   no_argument,       NULL, listnewconfig},
 	{"oldnoconfig",     no_argument,       NULL, oldnoconfig},
+	{"olddefconfig",    no_argument,       NULL, olddefconfig},
 	{NULL, 0, NULL, 0}
 };
 
@@ -566,6 +568,7 @@ int main(int ac, char **av)
 	case oldconfig:
 	case listnewconfig:
 	case oldnoconfig:
+	case olddefconfig:
 		conf_read(NULL);
 		break;
 	case allnoconfig:
@@ -624,6 +627,7 @@ int main(int ac, char **av)
 		conf_set_all_new_symbols(def_random);
 		break;
 	case defconfig:
+	case olddefconfig:
 		conf_set_all_new_symbols(def_default);
 		break;
 	case savedefconfig:
-- 
1.7.3.2.146.gca209

