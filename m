Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1KUTmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:42:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:16658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab1KUTmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:42:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="78485973"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, gthelen@google.com,
        Dmitry Fink <Dmitry.Fink@palm.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Richard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 1/2] merge_config.sh: use signal names compatible with dash and bash
Date: Mon, 21 Nov 2011 11:42:29 -0800
Message-Id: <591b0f764fd9eb0bc7873ef775052cb038484ae7.1321904550.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321567131.25715.32.camel@work-vm>
References: <1321567131.25715.32.camel@work-vm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SIGHUP SIGINT and SIGTERM names caused failures when running
merge_config.sh with the dash shell. Dropping the "SIG" component
makes the script work in both bash and dash.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 scripts/kconfig/merge_config.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index 890276b..b91015d 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -24,7 +24,7 @@ clean_up() {
        rm -f $TMP_FILE
        exit
 }
-trap clean_up SIGHUP SIGINT SIGTERM
+trap clean_up HUP INT TERM
 
 usage() {
 	echo "Usage: $0 [OPTIONS] [CONFIG [...]]"
-- 
1.7.6.4

