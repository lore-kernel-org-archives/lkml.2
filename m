Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab1KRXFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:05:00 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:50908 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab1KRXE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:04:58 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Huang Ying <ying.huang@intel.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, "Chen, Gong" <gong.chen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 18 Nov 2011 18:04:40 -0500
Subject: RE: [RFC][PATCH]ACPI,APEI,ERST, back end driver for NVRAM
Thread-Topic: [RFC][PATCH]ACPI,APEI,ERST, back end driver for NVRAM
Thread-Index: AcyllbRoCuLiJZE9RFemWZ6ttLnJIwAsKlMw
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57B4FA66@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57AC8046@USINDEVS01.corp.hds.com>
 <1321581563.13860.111.camel@yhuang-dev>
In-Reply-To: <1321581563.13860.111.camel@yhuang-dev>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1111180278
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAIN5Akd013527

Hi,

>According to ACPI 4.0a spec:
>
>"""
>17.5.2.4.1 Error Log Address Range Resides in NVRAM
>

Thank you for giving me the information.
Let me clarify one thing.

If the busy bit can be cleared immediately, we don't need to
check busy bit with CHECK_BUSY_STATUS.
So, we should simply execute OSPM operations as follows.

 - Writing
   1. BEGIN_WRITE
   2. SET_RECORD_OFFSET
   3. EXECUTE_OPERATION
   4. END

 - Reading
   1. BEGIN_READ
   2. SET_RECORD_OFFSET
   3. SET_RECORD_ID
   4. EXECUTE_OPERATION
   (END operation is not needed because OSPM requires no platform 
    support to read.)

 - Clearing
   1. BEGIN_CLEAR
   2. SET_RECORD_ID
   3. EXECUTE_OPERATION
   (END operation is not needed because OSPM requires no platform 
    support to clear.)

Is this what you expected?

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
