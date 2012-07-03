Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab2GCXeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 19:34:17 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:41498 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2GCXeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 19:34:10 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [RFC][PATCH 0/2]efi_pstore: Avoid missing panic message in NVRAM
Thread-Topic: [RFC][PATCH 0/2]efi_pstore: Avoid missing panic message in
 NVRAM
Thread-Index: Ac1Zc0Ttax3n3a+KQauWRRp04KBcmA==
Date: Tue, 3 Jul 2012 23:33:57 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAC3@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-03_09:2012-07-03,2012-07-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=10 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1207030268
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Problem]
Current efi_pstore simply overwrites existing entries in NVRAM.
So, if 2nd panic happens before a user checks 1st panic message, 1st panic message will be lost.

[Solution]
To avoid missing 1st panic message, this patch introduce a rule checking if existing entries in NRAM are erasable to efi_pstore.
 
[Patch Descriptions]
 
 [PATCH 1/2] Duplicate a shared code between write and erase callbacks  
 
  Currently, efi_pstore driver shares a code erasing existing entries in NVRAM with write and erase callbacks.
  But there some cases we should avoid erasing existing entries in write callback. (Please see PATCH 2/2).
  This patch duplicates the code so that write and erase callbacks work independently. 
 
 
 [PATCH 2/2] write callback: Check if existing entry is erasable
 
  this patch introduce a rule checking if existing entries in NRAM are erasable to efi_pstore.
  With this patch, if previous event is panic, efi_pstore never overwrite it.

 
  drivers/firmware/efivars.c |   94 +++++++++++++++++++++++++++++++++++++++++++-
  fs/pstore/platform.c       |    4 +-
  include/linux/pstore.h     |    5 ++
  3 files changed, 99 insertions(+), 4 deletions(-)
 
 Seiji
