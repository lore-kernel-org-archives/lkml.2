Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab2GXN2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:28:24 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:48559 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab2GXN2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:28:23 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "H. Peter Anvin (hpa@linux.intel.com)" <hpa@linux.intel.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "Paul Gortmaker (paul.gortmaker@windriver.com)" 
	<paul.gortmaker@windriver.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [PATCH]efi: initialize efi.runtime_version to make
 query_variable_info/update_capsule workable
Thread-Topic: [PATCH]efi: initialize efi.runtime_version to make
 query_variable_info/update_capsule workable
Thread-Index: Ac1poA7Y3jWzc10QRtmaCd8ESCF/xA==
Date: Tue, 24 Jul 2012 13:27:23 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2ED8D@USINDEM101.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-24_04:2012-07-24,2012-07-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1207240090
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A value of efi.runtime_version is checked before calling 
update_capsule()/query_variable_info() as follows.
But it isn't initialized anywhere.

<snip>
static efi_status_t virt_efi_query_variable_info(u32 attr,
                                                 u64 *storage_space,
                                                 u64 *remaining_space,
                                                 u64 *max_variable_size)
{
        if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
                return EFI_UNSUPPORTED;
<snip>

This patch initializes a value of efi.runtime_version at boot time.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 arch/x86/platform/efi/efi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 92660ed..f55a4ce 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -890,6 +890,7 @@ void __init efi_enter_virtual_mode(void)
 	 *
 	 * Call EFI services through wrapper functions.
 	 */
+	efi.runtime_version = efi_systab.fw_revision;
 	efi.get_time = virt_efi_get_time;
 	efi.set_time = virt_efi_set_time;
 	efi.get_wakeup_time = virt_efi_get_wakeup_time;
-- 1.7.1
