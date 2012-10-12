Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab2JLOzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:55:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:21473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758849Ab2JLOzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:55:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="204846858"
From: "Ma, Ling" <ling.ma@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iant@google.com" <iant@google.com>
Subject: RE: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Thread-Topic: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Thread-Index: AQHNp3KHe7EK2OTz7EWBVGWon0YSZpe0HToigADK2YCAAD/sAIAAl/5g
Date: Fri, 12 Oct 2012 14:54:54 +0000
Message-ID: <B2310DA9850C8743AA7AA0055500E90F0FD70B53@SHSMSX102.ccr.corp.intel.com>
References: <1349958548-1868-1-git-send-email-ling.ma@intel.com>
 <m2bog9t9cr.fsf@firstfloor.org>
 <B2310DA9850C8743AA7AA0055500E90F0FD709C4@SHSMSX102.ccr.corp.intel.com>
 <20121012133554.GA16230@one.firstfloor.org>
In-Reply-To: <20121012133554.GA16230@one.firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_B2310DA9850C8743AA7AA0055500E90F0FD70B53SHSMSX102ccrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_B2310DA9850C8743AA7AA0055500E90F0FD70B53SHSMSX102ccrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> If you can't test the CPUs who run this code I think it's safer if you
> add a new variant for Atom, not change the existing well tested code.
> Otherwise you risk performance regressions on these older CPUs.

I found one older machine, and tested the code on it, the results between t=
hem are almost the same as below(attached cpu info).
      1                         copy_page_org   copy_page_new
      2 TPT: Len 4096, alignment  0/ 0: 2252    2218
      3 TPT: Len 4096, alignment  0/ 0: 2244    2193
      4 TPT: Len 4096, alignment  0/ 0: 2261    2227
      5 TPT: Len 4096, alignment  0/ 0: 2235    2244
      6 TPT: Len 4096, alignment  0/ 0: 2261    2184

Thanks
Ling

--_002_B2310DA9850C8743AA7AA0055500E90F0FD70B53SHSMSX102ccrcor_
Content-Type: application/octet-stream; name="xeon-cpu-info"
Content-Description: xeon-cpu-info
Content-Disposition: attachment; filename="xeon-cpu-info"; size=2376;
	creation-date="Fri, 12 Oct 2012 14:43:17 GMT";
	modification-date="Fri, 12 Oct 2012 14:43:17 GMT"
Content-Transfer-Encoding: base64

cHJvY2Vzc29yCTogMAp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDE1Cm1v
ZGVsCQk6IDMKbW9kZWwgbmFtZQk6ICAgICAgICAgICAgICAgICAgIEludGVsKFIpIFhlb24oVE0p
IENQVSAzLjQwR0h6CnN0ZXBwaW5nCTogNApjcHUgTUh6CQk6IDM0MDAuMjg1CmNhY2hlIHNpemUJ
OiAxMDI0IEtCCnBoeXNpY2FsIGlkCTogMApzaWJsaW5ncwk6IDIKY29yZSBpZAkJOiAwCmNwdSBj
b3Jlcwk6IDEKZnB1CQk6IHllcwpmcHVfZXhjZXB0aW9uCTogeWVzCmNwdWlkIGxldmVsCTogNQp3
cAkJOiB5ZXMKZmxhZ3MJCTogZnB1IHZtZSBkZSBwc2UgdHNjIG1zciBwYWUgbWNlIGN4OCBhcGlj
IHNlcCBtdHJyIHBnZSBtY2EgY21vdiBwYXQgcHNlMzYgY2xmbHVzaCBkdHMgYWNwaSBtbXggZnhz
ciBzc2Ugc3NlMiBzcyBodCB0bSBzeXNjYWxsIGxtIHBuaSBtb25pdG9yIGRzX2NwbCBlc3QgdG0y
IGNpZCB4dHByCmJvZ29taXBzCTogNjcxNy40NApjbGZsdXNoIHNpemUJOiA2NApjYWNoZV9hbGln
bm1lbnQJOiAxMjgKYWRkcmVzcyBzaXplcwk6IDM2IGJpdHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmly
dHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogMQp2ZW5kb3JfaWQJOiBHZW51aW5l
SW50ZWwKY3B1IGZhbWlseQk6IDE1Cm1vZGVsCQk6IDMKbW9kZWwgbmFtZQk6ICAgICAgICAgICAg
ICAgICAgIEludGVsKFIpIFhlb24oVE0pIENQVSAzLjQwR0h6CnN0ZXBwaW5nCTogNApjcHUgTUh6
CQk6IDM0MDAuMjg1CmNhY2hlIHNpemUJOiAxMDI0IEtCCnBoeXNpY2FsIGlkCTogMwpzaWJsaW5n
cwk6IDIKY29yZSBpZAkJOiAzCmNwdSBjb3Jlcwk6IDEKZnB1CQk6IHllcwpmcHVfZXhjZXB0aW9u
CTogeWVzCmNwdWlkIGxldmVsCTogNQp3cAkJOiB5ZXMKZmxhZ3MJCTogZnB1IHZtZSBkZSBwc2Ug
dHNjIG1zciBwYWUgbWNlIGN4OCBhcGljIHNlcCBtdHJyIHBnZSBtY2EgY21vdiBwYXQgcHNlMzYg
Y2xmbHVzaCBkdHMgYWNwaSBtbXggZnhzciBzc2Ugc3NlMiBzcyBodCB0bSBzeXNjYWxsIGxtIHBu
aSBtb25pdG9yIGRzX2NwbCBlc3QgdG0yIGNpZCB4dHByCmJvZ29taXBzCTogNjc4Mi45NwpjbGZs
dXNoIHNpemUJOiA2NApjYWNoZV9hbGlnbm1lbnQJOiAxMjgKYWRkcmVzcyBzaXplcwk6IDM2IGJp
dHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29y
CTogMgp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDE1Cm1vZGVsCQk6IDMK
bW9kZWwgbmFtZQk6ICAgICAgICAgICAgICAgICAgIEludGVsKFIpIFhlb24oVE0pIENQVSAzLjQw
R0h6CnN0ZXBwaW5nCTogNApjcHUgTUh6CQk6IDM0MDAuMjg1CmNhY2hlIHNpemUJOiAxMDI0IEtC
CnBoeXNpY2FsIGlkCTogMApzaWJsaW5ncwk6IDIKY29yZSBpZAkJOiAwCmNwdSBjb3Jlcwk6IDEK
ZnB1CQk6IHllcwpmcHVfZXhjZXB0aW9uCTogeWVzCmNwdWlkIGxldmVsCTogNQp3cAkJOiB5ZXMK
ZmxhZ3MJCTogZnB1IHZtZSBkZSBwc2UgdHNjIG1zciBwYWUgbWNlIGN4OCBhcGljIHNlcCBtdHJy
IHBnZSBtY2EgY21vdiBwYXQgcHNlMzYgY2xmbHVzaCBkdHMgYWNwaSBtbXggZnhzciBzc2Ugc3Nl
MiBzcyBodCB0bSBzeXNjYWxsIGxtIHBuaSBtb25pdG9yIGRzX2NwbCBlc3QgdG0yIGNpZCB4dHBy
CmJvZ29taXBzCTogNjc4Mi45NwpjbGZsdXNoIHNpemUJOiA2NApjYWNoZV9hbGlnbm1lbnQJOiAx
MjgKYWRkcmVzcyBzaXplcwk6IDM2IGJpdHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dl
ciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogMwp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1
IGZhbWlseQk6IDE1Cm1vZGVsCQk6IDMKbW9kZWwgbmFtZQk6ICAgICAgICAgICAgICAgICAgIElu
dGVsKFIpIFhlb24oVE0pIENQVSAzLjQwR0h6CnN0ZXBwaW5nCTogNApjcHUgTUh6CQk6IDM0MDAu
Mjg1CmNhY2hlIHNpemUJOiAxMDI0IEtCCnBoeXNpY2FsIGlkCTogMwpzaWJsaW5ncwk6IDIKY29y
ZSBpZAkJOiAzCmNwdSBjb3Jlcwk6IDEKZnB1CQk6IHllcwpmcHVfZXhjZXB0aW9uCTogeWVzCmNw
dWlkIGxldmVsCTogNQp3cAkJOiB5ZXMKZmxhZ3MJCTogZnB1IHZtZSBkZSBwc2UgdHNjIG1zciBw
YWUgbWNlIGN4OCBhcGljIHNlcCBtdHJyIHBnZSBtY2EgY21vdiBwYXQgcHNlMzYgY2xmbHVzaCBk
dHMgYWNwaSBtbXggZnhzciBzc2Ugc3NlMiBzcyBodCB0bSBzeXNjYWxsIGxtIHBuaSBtb25pdG9y
IGRzX2NwbCBlc3QgdG0yIGNpZCB4dHByCmJvZ29taXBzCTogNjc4Mi45NwpjbGZsdXNoIHNpemUJ
OiA2NApjYWNoZV9hbGlnbm1lbnQJOiAxMjgKYWRkcmVzcyBzaXplcwk6IDM2IGJpdHMgcGh5c2lj
YWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoK

--_002_B2310DA9850C8743AA7AA0055500E90F0FD70B53SHSMSX102ccrcor_--
