Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2LGXnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:43:20 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:34100 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2LGXnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:43:19 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Topic: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Index: Ac3UwvCZixvXisXmRfC/Xc8ha8nnHAABPNzwAABk6xA=
Date: Fri, 7 Dec 2012 23:43:03 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B936@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B7B2@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1C9658B1@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1C9658B1@ORSMSX108.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-12-07_04:2012-12-07,2012-12-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1212070246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can all these things really happen (did you run into this problem on a real system?). Or is this just a theoretical problem.  Ugly (but
> practical) hacks might be OK to solve real problems. 

It is a theoretical problem right now.
But it is a timing issue and there is a possibility to happen actually.

> But do we really want them to fix problems that actually never happen?

If we find a problem (even if it is theoretical), we can't say "It actually never happen.".

I have some reasons to submit this patch before reproducing actually.

1)
It is too late if we fix a problem after it actually happened in case where we apply Linux, including pstore, 
to mission critical systems, because the failure of those systems has a great impact on a whole society.
Customers in this area ask us to fix a problem as soon as possible.
On the other hand, this kind of timing issue is hard to reproduce.
So, our support service engineers often work all night to reproduce it.
It is a nightmare for us.

If we can fix it with a small patch in adance, it is really helpful for us.

2)
In the long term, I plan to add a kmsg_dump to a kexec path because kdump may fail in the real world.
In that case, we need another troubleshooting material like pstore to detect a root cause of failure.

Actually, someone blamed for a reliability of kdump in LinuxCON Europe.
http://events.linuxfoundation.org/images/stories/pdf/lceu2012_holzheu.pdf

To convince a kexec maintainer to add a kmsg_dump, I need to prove that there is no problem in pstore code
causing a failure of kdump.

Seiji

