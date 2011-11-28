Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1K1Wo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:44:57 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:32790 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1K1Wo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:44:56 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "nagar@watson.ibm.com" <nagar@watson.ibm.com>,
        "kobayashi.kk@ncos.nec.co.jp" <kobayashi.kk@ncos.nec.co.jp>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Mon, 28 Nov 2011 17:44:08 -0500
Subject: [PATCH 0/4] delayacct: save max CPU/IO/SWAP/RECLAIM delays
Thread-Topic: [PATCH 0/4] delayacct: save max CPU/IO/SWAP/RECLAIM delays
Thread-Index: AcyuHz1jOo2pA4gdSJ2m+oX/c0nTOA==
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB574E70D@USINDEVS02.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1111280247
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the latency sensitive systems, we usually focus on the worst latency.
And so, it is useful to save max delays into the per-task delay
accounting functionality.

Example output:
(on 100 concurrent dd reading sparse files w/ 1 dd writing a file)

CPU             count     real total  virtual total    delay total      delay_max  delay average
                  222       45993008       74603882        7637295        3691858          0.034ms
IO              count    delay total      delay max  delay average
                    2       21812073       12728672             10ms
SWAP            count    delay total      delay max  delay average
                    0              0              0              0ms
RECLAIM         count    delay total      delay_max  delay average
                    2         348488         211985              0ms

Any comments are welcome.


Satoru Moriya (4):
  sched: add members to struct sched_info to save maximum
  delayacct: add members to struct task_delay_info to save max delays
  delayacct: update taskstats to save max delays
  getdelays: show max CPU/IO/SWAP/RECLAIM delays

 Documentation/accounting/getdelays.c          |   28 ++++++++++++++----------
 Documentation/accounting/taskstats-struct.txt |    9 ++++++++
 include/linux/sched.h                         |    5 ++++
 include/linux/taskstats.h                     |    8 ++++++-
 kernel/delayacct.c                            |   25 +++++++++++++++++----
 kernel/sched_stats.h                          |    5 ++++
 6 files changed, 62 insertions(+), 18 deletions(-)

-- 
1.7.6.4


