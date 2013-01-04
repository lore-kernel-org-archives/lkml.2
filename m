Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3ADTQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:16:14 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:34484 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060Ab3ADTQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:16:12 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Jon Loeliger <jdl@jdl.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Fix test relying in wrong behavior of is_printable
Date: Fri,  4 Jan 2013 21:16:08 +0200
Message-Id: <1357326968-13124-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After fixing the is_printable bug the test suite fails.
Fix it with this patch

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 tests/run_tests.sh | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tests/run_tests.sh b/tests/run_tests.sh
index dd7f217..43279c9 100755
--- a/tests/run_tests.sh
+++ b/tests/run_tests.sh
@@ -498,9 +498,8 @@ fdtget_tests () {
 
     # run_fdtget_test <expected-result> [<flags>] <file> <node> <property>
     run_fdtget_test "MyBoardName" $dtb / model
-    run_fdtget_test "77 121 66 111 \
-97 114 100 78 97 109 101 0 77 121 66 111 97 114 100 70 97 109 105 \
-108 121 78 97 109 101 0" $dtb / compatible
+    # run_fdtget_test "77 121 66 111 97 114 100 78 97 109 101 0 77 121 66 111 97 114 100 70 97 109 105 108 121 78 97 109 101 0" $dtb / compatible
+    run_fdtget_test "MyBoardName MyBoardFamilyName" $dtb / compatible
     run_fdtget_test "MyBoardName MyBoardFamilyName" -t s $dtb / compatible
     run_fdtget_test 32768 $dtb /cpus/PowerPC,970@1 d-cache-size
     run_fdtget_test 8000 -tx $dtb /cpus/PowerPC,970@1 d-cache-size
-- 
1.7.12

