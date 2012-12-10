Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab2LJX4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:56:09 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:57811 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2LJX4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:56:07 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Topic: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Index: Ac3UwvCZixvXisXmRfC/Xc8ha8nnHAABPNzwAABk6xAAlaV2gAAEWL8Q
Date: Mon, 10 Dec 2012 23:55:48 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1DFE3@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B7B2@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1C9658B1@ORSMSX108.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B936@USINDEM103.corp.hds.com>
 <20121210164813.GA53431@redhat.com>
In-Reply-To: <20121210164813.GA53431@redhat.com>
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
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1212100245
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If we can fix it with a small patch in adance, it is really helpful for us.
> 
> As I said in my email I just sent, it may not help you without testing it.
> As there are probably other problems in that un-tested theoretical scenario.

OK. I understood.

 
> >
> > 2)
> > In the long term, I plan to add a kmsg_dump to a kexec path because kdump may fail in the real world.
> > In that case, we need another troubleshooting material like pstore to detect a root cause of failure.
> 
> But you are assuming that kmsg_dump is perfect and it isn't, in which case by putting kmsg_dump in the kdump path, you actually may
> be blocking kdump from working.

That is why I'm trying to fix problems of pstore in panic path right now.
If kmsg_dump/pstore/platform drivers work well in panic path, they work in kdump path as well.

Seiji
