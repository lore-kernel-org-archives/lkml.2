Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2CGVRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:17:33 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:48282 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2CGVRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:17:30 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Chen Gong (gong.chen@linux.intel.com)" <gong.chen@linux.intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 7 Mar 2012 16:17:13 -0500
Subject: [Patch]Fix reason_str of pstore so that it can work correctly
Thread-Topic: [Patch]Fix reason_str of pstore so that it can work correctly
Thread-Index: Acz8pzjXjW5PUwweRzSFoEbrg33PyA==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2DACC35686@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1203070227
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently, there has been some changes in kmsg_dump() below.
 (1) kmsg_dump(KMSG_DUMP_KEXEC) was removed.
     http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=a3dd3323058d281abd584b15ad4c5b65064d7a61

 (2) A order of "enum kmsg_dump_reason" was modified.
     http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=c22ab332902333f83766017478c1ef6607ace681

 These above patches modified kmsg_dump_reason in include/linux/kmsg_dump.h. 
 But reason_str in fs/pstore/platform.c was not modified.

 This patch just fixes reason_str in fs/pstore/platform.c so that pstore can work correctly.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 fs/pstore/platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c index 9ec22d3..81f4748 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -69,7 +69,7 @@ void pstore_set_kmsg_bytes(int bytes)
 static int	oopscount;
 
 static char *reason_str[] = {
-	"Oops", "Panic", "Kexec", "Restart", "Halt", "Poweroff", "Emergency"
+	"Panic", "Oops", "Emergency", "Restart", "Halt", "Poweroff"
 };
 
 /*
-- 1.7.1
