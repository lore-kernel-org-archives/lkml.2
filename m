Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab2LABFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 20:05:30 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:54484 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2LABF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 20:05:28 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "jim.cromie@gmail.com" <jim.cromie@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH] Avoid dead lock of console related locks in panic case
Thread-Topic: [PATCH] Avoid dead lock of console related locks in panic case
Thread-Index: Ac3PHT6W8aSr96JsTimOsT6bVlOSHQAVvOuAAAnPGzD//7/lgIAASnWw
Date: Sat, 1 Dec 2012 01:04:22 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A0351F@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A02C44@USINDEM103.corp.hds.com>
	<20121130143023.2d67d817.akpm@linux-foundation.org>
	<A5ED84D3BB3A384992CBB9C77DEDA4D414A0339D@USINDEM103.corp.hds.com>
 <20121130152149.6f266216.akpm@linux-foundation.org>
In-Reply-To: <20121130152149.6f266216.akpm@linux-foundation.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-30_15:2012-11-30,2012-11-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1211300262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I actually meant was: can "this" CPU avoid stopping other CPUs so early?  If we stop the other CPUs when this CPU is ready to
> stop itself then there will never be such deadlocks.

Let me explain my opinion.
When we focus on the deadlock only,   the code will be simple by moving smp_send_stop() at the end of panic().

But, panic situation is not normal.
I don't think that keeping running multiple cpus is safe, because they may touch corrupted data/variables and unnecessary 
panic/BUG() may happen.

IMO, cpus should be stopped "as early as" possible when panic happens.
And then panic() has to take minimal steps with a single cpu.
 - output messages
 - kicking troubleshooting features like kdump/kmsg_dump

Seiji


