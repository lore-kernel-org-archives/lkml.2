Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab2GEU6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:58:19 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:45192 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab2GEU6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:58:18 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Topic: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Index: Ac1ZdICAdYwUKctERYa3qDPOlfZeVABX5VeAAAHWqnAADJMpgAAIPF3Q
Date: Thu, 5 Jul 2012 20:58:02 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D401C31F@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAED@USINDEM103.corp.hds.com>
 <20120705133201.GG5637@redhat.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D401C288@USINDEM103.corp.hds.com>
 <20120705202443.GQ5637@redhat.com>
In-Reply-To: <20120705202443.GQ5637@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-05_05:2012-07-05,2012-07-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1207050237
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I understand the above scenario and was the one of was thinking of when I replied.  My counter argument is if the NVRAM isn't big
> enough to hold more than two panics, then the logs are too big.
> 
> This stuff should be designed to easily accomodate multiple logs (like say 6 or so), then the above situation doesn't matter.
> 
> I just feel this is adding complexity to something that shouldn't need it.
> 

I see. I understand your argument right  now.

My patch is on assumption that efi_pstore can handle just one log.
But if it can handle multiple logs, we can solve my concern simply.

Default value of pstore.kmsg_byte is 10KB.
I think efi_pstore can log 60KB(= 10KB X 6)...

Original code is developed by Matthew and he is EFI expert.
So, I have to ask Matthew why current write callback simply erases old entries.

Matthew,

Do you think efI_pstore should handle just one log?  Or do you think latest message is most important?
