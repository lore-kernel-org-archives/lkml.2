Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2LKAG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 19:06:58 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:47550 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2LKAG5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 19:06:57 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Topic: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Index: Ac3UwvCZixvXisXmRfC/Xc8ha8nnHAABPNzwAABk6xAAlaV2gAADLeeAAAFSCrA=
Date: Tue, 11 Dec 2012 00:06:38 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1E016@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B7B2@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1C9658B1@ORSMSX108.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B936@USINDEM103.corp.hds.com>
 <20121210164813.GA53431@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F1C966DF1@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1C966DF1@ORSMSX108.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-10_07:2012-12-10,2012-12-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=1 spamscore=1
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1212100248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A boot argument might help - so we can force use of pstore in cases where kdump is failing (or prevent use of pstore in cases where it
> seem to be preventing us getting to kdump ... I don't have a preference).  BUT this would only be useful if we had a repeatable
> problem so that we could switch to the other mode ... and it seems likely that the kinds of problems that cause pstore or kdump to fail
> would be weird cases that are not very repeatable :-(

I think it is helpful for reproducible problems because reasons of kdump failure vary widely.
For example, users may forget to erase vmcores from a dump disk and kdump fails due to lack of space.
Also, FC cable or other hardware may be broken.

But, The person I have to convince is not you but kexec engineers...

> 
> -Tony
