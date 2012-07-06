Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab2GFAY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 20:24:56 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:59948 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab2GFAYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 20:24:54 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Topic: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Index: Ac1ZdICAdYwUKctERYa3qDPOlfZeVABX5VeAAAHWqnAADJMpgAAIPF3Q///tDACAADRAgA==
Date: Fri, 6 Jul 2012 00:24:42 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D401C48C@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAED@USINDEM103.corp.hds.com>
 <20120705133201.GG5637@redhat.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D401C288@USINDEM103.corp.hds.com>
 <20120705202443.GQ5637@redhat.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D401C31F@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1934764C@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1934764C@ORSMSX104.amr.corp.intel.com>
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
 definitions=main-1207050292
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 10K is almost certainly more than we need for 99.9% of problems ... I set the default there to test out that pstore would correctly
> break a dump into more than one back-end ERST record (about 7K) and never changed it back. So don't treat 10K with any magic
> reverence. It's easy to argue that a smaller number is good enough.

OK.

> There are certainly less over-write worries if you can handle a few (4, 5, 6) simultaneously logged errors of sufficient size to be useful
> (must capture all of the panic strings, backtrace and register dump plus "enough" lines before the panic to see any obvious issues).
>

To handle multiple logs, I will probably introduce a new kernel parameter, like efi_pstore_max_log_num.
Users can calculate  overall consumption of NVRAM for kmsg logging with it.
 
> If you only get to store two errors, then perhaps one non-over writable panic type entry, and one other "most recent" type entry?
> 
> With just one, like current EFI, then there are certainly hard choices that might not be the best for certain pathological situations.

I will consider a policy for multiple logging from now.
(In case where oops happens multiple times and kernel hangs, oldest oops may be informative.... I can't decide the policy at this time.)

Seiji


