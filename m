Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1LBWKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 17:10:10 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:52768 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab1LBWKG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 17:10:06 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 2 Dec 2011 17:09:32 -0500
Subject: [RFC][PATCH v3 1/3] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Thread-Topic: [RFC][PATCH v3 1/3] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Thread-Index: AcyxPu4fSl+qdT7oRSamPJnbrxOQwwAAALqw
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D0F@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1112020255
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just moves kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop
for serializing logging process via smp_send_stop.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 kernel/panic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index b265936..c8e0ae8 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -88,8 +88,6 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	crash_kexec(NULL);
 
-	kmsg_dump(KMSG_DUMP_PANIC);
-
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
 	 * unfortunately means it may not be hardened to work in a panic
@@ -97,6 +95,8 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	smp_send_stop();
 
+	kmsg_dump(KMSG_DUMP_PANIC);
+
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
 	bust_spinlocks(0);
-- 1.7.1
