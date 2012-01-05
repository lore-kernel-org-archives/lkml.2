Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2AERmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:42:25 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:45204 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2AERmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:42:24 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Thu, 5 Jan 2012 12:41:21 -0500
Subject: [RFC][PATCH v4 -next 4/4] Skip spin_lock of efi_pstore_write() in
 panic case
Thread-Topic: [RFC][PATCH v4 -next 4/4] Skip spin_lock of efi_pstore_write()
 in panic case
Thread-Index: AczL0HMFUhgCH34WQWyA76ETk3pYJwAAJ9RA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF89@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {25FA42C8-09E6-4435-9F21-B26D6962878B}
x-cr-hashedpuzzle: =?us-ascii?Q?A4yB_alj1_yY1E_ABY7jg=3D=3D_AEGJkQ=3D=3D_AEqY0Q=3D=3D_AFXFEg?=
 =?us-ascii?Q?=3D=3D_AF669Q=3D=3D_AK4KwA=3D=3D_ANUsSA=3D=3D_AQhFhA=3D=3D_A?=
 =?us-ascii?Q?R3/Nw=3D=3D_ATfQDQ=3D=3D_AVlpdg=3D=3D_Aghaug=3D=3D_Ag3PXw=3D?=
 =?us-ascii?Q?=3D;16;JwBhAGsAQABsAGkAbgB1AHgALgBpAG4AdABlAGwALgBjAG8AbQAnA?=
 =?us-ascii?Q?DsAJwBoAHUAZwBoAGQAQABjAGgAcgBvAG0AaQB1AG0ALgBvAHIAZwAnADsAJ?=
 =?us-ascii?Q?wBtAGkAbgBnAG8AQABlAGwAdABlAC4AaAB1ACcAOwAnAHkAaQBuAGcALgBoA?=
 =?us-ascii?Q?HUAYQBuAGcAQABpAG4AdABlAGwALgBjAG8AbQAnADsAYQAuAHAALgB6AGkAa?=
 =?us-ascii?Q?gBsAHMAdAByAGEAQABjAGgAZQBsAGwAbwAuAG4AbAA7AGEAawBwAG0AQABsA?=
 =?us-ascii?Q?GkAbgB1AHgALQBmAG8AdQBuAGQAYQB0AGkAbwBuAC4AbwByAGcAOwBkAGwAZ?=
 =?us-ascii?Q?QAtAGQAZQB2AGUAbABvAHAAQABsAGkAcwB0AHMALgBzAG8AdQByAGMAZQBmA?=
 =?us-ascii?Q?G8AcgBnAGUALgBuAGUAdAA7AGQAegBpAGMAawB1AHMAQAByAGUAZABoAGEAd?=
 =?us-ascii?Q?AAuAGMAbwBtADsAZwBvAG4AZwAuAGMAaABlAG4AQABpAG4AdABlAGwALgBjA?=
 =?us-ascii?Q?G8AbQA7AGoAbQBvAHIAcgBpAHMAQABuAGEAbQBlAGkALgBvAHIAZwA7AGwAZ?=
 =?us-ascii?Q?QBuAC4AYgByAG8AdwBuAEAAaQBuAHQAZQBsAC4AYwBvAG0AOwBsAGkAbgB1A?=
 =?us-ascii?Q?HgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8Ac?=
 =?us-ascii?Q?gBnADsAbQBqAGcAQAByAGUAZABoAGEAdAAuAGMAbwBtADsAbgBhAG0AaAB5A?=
 =?us-ascii?Q?HUAbgBnAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwB0AG8AbgB5AC4AbAB1AGMAa?=
 =?us-ascii?Q?wBAAGkAbgB0AGUAbAAuAGMAbwBtADsAdgBnAG8AeQBhAGwAQAByAGUAZABoA?=
 =?us-ascii?Q?GEAdAAuAGMAbwBtAA=3D=3D;Sosha1=5Fv1;7;{25FA42C8-09E6-4435-9F?=
 =?us-ascii?Q?21-B26D6962878B};cwBlAGkAagBpAC4AYQBnAHUAYwBoAGkAQABoAGQAcwA?=
 =?us-ascii?Q?uAGMAbwBtAA=3D=3D;Thu,_05_Jan_2012_17:41:21_GMT;WwBSAEYAQwBd?=
 =?us-ascii?Q?AFsAUABBAFQAQwBIACAAdgA0ACAALQBuAGUAeAB0ACAANAAvADQAXQAgAFMA?=
 =?us-ascii?Q?awBpAHAAIABzAHAAaQBuAF8AbABvAGMAawAgAG8AZgAgAGUAZgBpAF8AcABz?=
 =?us-ascii?Q?AHQAbwByAGUAXwB3AHIAaQB0AGUAKAApACAAaQBuACAAcABhAG4AaQBjACAA?=
 =?us-ascii?Q?YwBhAHMAZQA=3D?=
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1201050180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch skips spin_lock of efi_pstore_write() in panic path for these reasons.
 - efi_pstore_write() is serialized via smp_send_stop().
 - SetVariable runtime service is guaranteed to work correctly if you call
   it a second time when you have taken an exception in trying
   to execute them already.

We can avoid deadlock of spin_lock(&efivars->lock) in panic path and get panic log
reliably.


 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 drivers/firmware/efivars.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d25599f..657e6f1 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -510,7 +510,15 @@ static int efi_pstore_write(enum pstore_type_id type,
 	sprintf(stub_name, "dump-type%u-%u-", type, part);
 	sprintf(name, "%s%lu", stub_name, get_seconds());
 
-	spin_lock(&efivars->lock);
+	/*
+	 * We don't need to take any locks in panic path for these reasons.
+	 *  - efi_pstore_write() is serialized via smp_send_stop().
+	 *  - SetVariable runtime service is guaranteed to work correctly
+	 *    if you call it a second time when you have taken an exception
+	 *    in trying to execute them already.
+	 */
+	if (reason != KMSG_DUMP_PANIC)
+		spin_lock(&efivars->lock);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = stub_name[i];
@@ -548,7 +556,8 @@ static int efi_pstore_write(enum pstore_type_id type,
 	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
 				   size, psi->buf);
 
-	spin_unlock(&efivars->lock);
+	if (reason != KMSG_DUMP_PANIC)
+		spin_unlock(&efivars->lock);
 
 	if (found)
 		efivar_unregister(found);
-- 
1.7.1



