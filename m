Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab0JSCLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:11:30 -0400
Received: from [120.204.251.227] ([120.204.251.227]:36836 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752889Ab0JSCL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:11:29 -0400
Subject: Re: oom_killer crash linux system
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        figo1802 <figo1802@gmail.com>
In-Reply-To: <20101018180919.3AF8.A69D9226@jp.fujitsu.com>
References: <20101018021126.GB8654@localhost>
	 <1287389631.1997.9.camel@myhost>
	 <20101018180919.3AF8.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 10:07:38 +0800
Message-ID: <1287454058.2078.12.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2010 02:11:25.0174 (UTC) FILETIME=[EE915160:01CB6F32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> very lots of change ;)
> can you please send us your crash log?

i add some prink in select_bad_process() and oom_badness() to see
pid/totalpages/points/memoryuseage/and finally process to selet to kill.

i found it the oom-killer select: syslog-ng,mysqld,nautilus,VirtualBox
to kill, so my question is:

1. the syslog-ng,mysqld,nautilus is the system foundamental process, so
if oom-killer kill those process, the system will be damaged, such as
lose some important data.

2. the new oom-killer just use percentage of used memory as score to
select the candidate to kill, but how to know this process to very
important for system?

oom_score_adj, it is anyone commercial linux distributions to use this
to protect the critical process.

Best,
Figo.zhang


here is the message log:


Oct 19 09:44:08 myhost kernel: [  618.440834] select_bad_process,
pid=584, points=0
Oct 19 09:44:08 myhost kernel: [  618.440839] oom_badness: memoy use
=52, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440842] oom_badness: pid = 1304,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440844] select_bad_process,
pid=1304, points=1
Oct 19 09:44:08 myhost kernel: [  618.440846] select_bad_process,
===========have choose pid=1304 to kill, points=1
Oct 19 09:44:08 myhost kernel: [  618.440848] oom_badness: memoy use
=115, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440851] oom_badness: pid = 1305,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440853] select_bad_process,
pid=1305, points=1
Oct 19 09:44:08 myhost kernel: [  618.440855] oom_badness: memoy use
=215, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440858] oom_badness: pid = 1307,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.440860] select_bad_process,
pid=1307, points=1
Oct 19 09:44:08 myhost kernel: [  618.440862] oom_badness: memoy use
=214, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440865] oom_badness: pid = 1310,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.440867] select_bad_process,
pid=1310, points=1
Oct 19 09:44:08 myhost kernel: [  618.440875] oom_badness: memoy use
=62, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440877] oom_badness: pid = 1311,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440879] select_bad_process,
pid=1311, points=1
Oct 19 09:44:08 myhost kernel: [  618.440882] oom_badness: memoy use
=33, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440884] oom_badness: pid = 1340,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440886] select_bad_process,
pid=1340, points=1
Oct 19 09:44:08 myhost kernel: [  618.440888] oom_badness: memoy use
=35, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440891] oom_badness: pid = 1354,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440893] select_bad_process,
pid=1354, points=1
Oct 19 09:44:08 myhost kernel: [  618.440895] oom_badness: memoy use
=40, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440897] oom_badness: pid = 1356,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.440899] select_bad_process,
pid=1356, points=1
Oct 19 09:44:08 myhost kernel: [  618.440902] oom_badness: memoy use
=22, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440904] oom_badness: pid = 1419,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440906] select_bad_process,
pid=1419, points=1
Oct 19 09:44:08 myhost kernel: [  618.440909] oom_badness: memoy use
=103, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440911] oom_badness: pid = 1450,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440913] select_bad_process,
pid=1450, points=1
Oct 19 09:44:08 myhost kernel: [  618.440915] oom_badness: memoy use
=52, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440918] oom_badness: pid = 1453,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440919] select_bad_process,
pid=1453, points=1
Oct 19 09:44:08 myhost kernel: [  618.440922] oom_badness: memoy use
=23, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440924] oom_badness: pid = 1465,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440926] select_bad_process,
pid=1465, points=1
Oct 19 09:44:08 myhost kernel: [  618.440929] oom_badness: memoy use
=23, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440931] oom_badness: pid = 1466,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440933] select_bad_process,
pid=1466, points=1
Oct 19 09:44:08 myhost kernel: [  618.440936] oom_badness: memoy use
=23, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440938] oom_badness: pid = 1467,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440940] select_bad_process,
pid=1467, points=1
Oct 19 09:44:08 myhost kernel: [  618.440943] oom_badness: memoy use
=23, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440945] oom_badness: pid = 1468,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440947] select_bad_process,
pid=1468, points=1
Oct 19 09:44:08 myhost kernel: [  618.440949] oom_badness: memoy use
=22, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440951] oom_badness: pid = 1469,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440953] select_bad_process,
pid=1469, points=1
Oct 19 09:44:08 myhost kernel: [  618.440956] oom_badness: memoy use
=22, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440958] oom_badness: pid = 1470,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440960] select_bad_process,
pid=1470, points=1
Oct 19 09:44:08 myhost kernel: [  618.440962] select_bad_process,
pid=1547, points=0
Oct 19 09:44:08 myhost kernel: [  618.440965] oom_badness: memoy use
=170, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440967] oom_badness: pid = 1571,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440969] select_bad_process,
pid=1571, points=1
Oct 19 09:44:08 myhost kernel: [  618.440971] oom_badness: memoy use
=23, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440974] oom_badness: pid = 1586,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440976] select_bad_process,
pid=1586, points=1
Oct 19 09:44:08 myhost kernel: [  618.440978] oom_badness: memoy use
=179, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440985] oom_badness: pid = 1592,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440987] select_bad_process,
pid=1592, points=1
Oct 19 09:44:08 myhost kernel: [  618.440988] oom_badness: memoy use
=168, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440990] oom_badness: pid = 1593,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440991] select_bad_process,
pid=1593, points=1
Oct 19 09:44:08 myhost kernel: [  618.440993] oom_badness: memoy use
=236, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440995] oom_badness: pid = 1616,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.440996] select_bad_process,
pid=1616, points=1
Oct 19 09:44:08 myhost kernel: [  618.440998] oom_badness: memoy use
=61, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.440999] oom_badness: pid = 1626,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441000] select_bad_process,
pid=1626, points=1
Oct 19 09:44:08 myhost kernel: [  618.441002] oom_badness: memoy use
=7037, totalpages=506807, points=13
Oct 19 09:44:08 myhost kernel: [  618.441004] oom_badness: pid = 1658,
oom_score_adj=0, points=-17
Oct 19 09:44:08 myhost kernel: [  618.441005] select_bad_process,
pid=1658, points=1
Oct 19 09:44:08 myhost kernel: [  618.441007] oom_badness: memoy use
=2816, totalpages=506807, points=5
Oct 19 09:44:08 myhost kernel: [  618.441008] oom_badness: pid = 1700,
oom_score_adj=0, points=5
Oct 19 09:44:08 myhost kernel: [  618.441010] select_bad_process,
pid=1700, points=5
Oct 19 09:44:08 myhost kernel: [  618.441011] select_bad_process,
===========have choose pid=1700 to kill, points=5
Oct 19 09:44:08 myhost kernel: [  618.441013] oom_badness: memoy use
=225, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441014] oom_badness: pid = 1701,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441016] select_bad_process,
pid=1701, points=1
Oct 19 09:44:08 myhost kernel: [  618.441017] oom_badness: memoy use
=187, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441019] oom_badness: pid = 1710,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441020] select_bad_process,
pid=1710, points=1
Oct 19 09:44:08 myhost kernel: [  618.441022] oom_badness: memoy use
=56, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441023] oom_badness: pid = 1715,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441024] select_bad_process,
pid=1715, points=1
Oct 19 09:44:08 myhost kernel: [  618.441026] select_bad_process,
pid=1716, points=0
Oct 19 09:44:08 myhost kernel: [  618.441028] oom_badness: memoy use
=225, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441030] oom_badness: pid = 1738,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441031] select_bad_process,
pid=1738, points=1
Oct 19 09:44:08 myhost kernel: [  618.441032] oom_badness: memoy use
=1363, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441034] oom_badness: pid = 1739,
oom_score_adj=0, points=-28
Oct 19 09:44:08 myhost kernel: [  618.441035] select_bad_process,
pid=1739, points=1
Oct 19 09:44:08 myhost kernel: [  618.441037] oom_badness: memoy use
=1148, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441038] oom_badness: pid = 1742,
oom_score_adj=0, points=2
Oct 19 09:44:08 myhost kernel: [  618.441040] select_bad_process,
pid=1742, points=2
Oct 19 09:44:08 myhost kernel: [  618.441041] oom_badness: memoy use
=40, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441043] oom_badness: pid = 1748,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441044] select_bad_process,
pid=1748, points=1
Oct 19 09:44:08 myhost kernel: [  618.441046] oom_badness: memoy use
=768, totalpages=506807, points=1
Oct 19 09:44:08 myhost kernel: [  618.441048] oom_badness: pid = 1749,
oom_score_adj=0, points=-29
Oct 19 09:44:08 myhost kernel: [  618.441049] select_bad_process,
pid=1749, points=1
Oct 19 09:44:08 myhost kernel: [  618.441051] oom_badness: memoy use
=1359, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441052] oom_badness: pid = 1752,
oom_score_adj=0, points=2
Oct 19 09:44:08 myhost kernel: [  618.441054] select_bad_process,
pid=1752, points=2
Oct 19 09:44:08 myhost kernel: [  618.441055] oom_badness: memoy use
=1359, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441057] oom_badness: pid = 1753,
oom_score_adj=0, points=2
Oct 19 09:44:08 myhost kernel: [  618.441058] select_bad_process,
pid=1753, points=2
Oct 19 09:44:08 myhost kernel: [  618.441060] oom_badness: memoy use
=1359, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441061] oom_badness: pid = 1754,
oom_score_adj=0, points=2
Oct 19 09:44:08 myhost kernel: [  618.441063] select_bad_process,
pid=1754, points=2
Oct 19 09:44:08 myhost kernel: [  618.441064] oom_badness: memoy use
=1359, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441066] oom_badness: pid = 1755,
oom_score_adj=0, points=2
Oct 19 09:44:08 myhost kernel: [  618.441067] select_bad_process,
pid=1755, points=2
Oct 19 09:44:08 myhost kernel: [  618.441069] oom_badness: memoy use
=1359, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441070] oom_badness: pid = 1756,
oom_score_adj=0, points=2
Oct 19 09:44:08 myhost kernel: [  618.441072] select_bad_process,
pid=1756, points=2
Oct 19 09:44:08 myhost kernel: [  618.441074] oom_badness: memoy use
=149, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441075] oom_badness: pid = 1775,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441076] select_bad_process,
pid=1775, points=1
Oct 19 09:44:08 myhost kernel: [  618.441078] oom_badness: memoy use
=24, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441080] oom_badness: pid = 1867,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441081] select_bad_process,
pid=1867, points=1
Oct 19 09:44:08 myhost kernel: [  618.441083] oom_badness: memoy use
=285, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441084] oom_badness: pid = 1893,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441086] select_bad_process,
pid=1893, points=1
Oct 19 09:44:08 myhost kernel: [  618.441088] oom_badness: memoy use
=110, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441089] oom_badness: pid = 1899,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441091] select_bad_process,
pid=1899, points=1
Oct 19 09:44:08 myhost kernel: [  618.441092] oom_badness: memoy use
=97, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441094] oom_badness: pid = 1900,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441095] select_bad_process,
pid=1900, points=1
Oct 19 09:44:08 myhost kernel: [  618.441097] oom_badness: memoy use
=134, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441099] oom_badness: pid = 1967,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441100] select_bad_process,
pid=1967, points=1
Oct 19 09:44:08 myhost kernel: [  618.441102] oom_badness: memoy use
=301, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441103] oom_badness: pid = 1986,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441104] select_bad_process,
pid=1986, points=1
Oct 19 09:44:08 myhost kernel: [  618.441106] select_bad_process,
pid=2003, points=0
Oct 19 09:44:08 myhost kernel: [  618.441108] oom_badness: memoy use
=42, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441109] oom_badness: pid = 2013,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441110] select_bad_process,
pid=2013, points=1
Oct 19 09:44:08 myhost kernel: [  618.441112] oom_badness: memoy use
=261, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441114] oom_badness: pid = 2014,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441115] select_bad_process,
pid=2014, points=1
Oct 19 09:44:08 myhost kernel: [  618.441117] oom_badness: memoy use
=51, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441118] oom_badness: pid = 2016,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441119] select_bad_process,
pid=2016, points=1
Oct 19 09:44:08 myhost kernel: [  618.441121] oom_badness: memoy use
=463, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441123] oom_badness: pid = 2021,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441124] select_bad_process,
pid=2021, points=1
Oct 19 09:44:08 myhost kernel: [  618.441126] oom_badness: memoy use
=1031, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441127] oom_badness: pid = 2024,
oom_score_adj=0, points=2
Oct 19 09:44:08 myhost kernel: [  618.441129] select_bad_process,
pid=2024, points=2
Oct 19 09:44:08 myhost kernel: [  618.441131] oom_badness: memoy use
=824, totalpages=506807, points=1
Oct 19 09:44:08 myhost kernel: [  618.441132] oom_badness: pid = 2033,
oom_score_adj=0, points=1
Oct 19 09:44:08 myhost kernel: [  618.441133] select_bad_process,
pid=2033, points=1
Oct 19 09:44:08 myhost kernel: [  618.441135] oom_badness: memoy use
=70, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441137] oom_badness: pid = 2038,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441138] select_bad_process,
pid=2038, points=1
Oct 19 09:44:08 myhost kernel: [  618.441140] oom_badness: memoy use
=720, totalpages=506807, points=1
Oct 19 09:44:08 myhost kernel: [  618.441141] oom_badness: pid = 2041,
oom_score_adj=0, points=1
Oct 19 09:44:08 myhost kernel: [  618.441143] select_bad_process,
pid=2041, points=1
Oct 19 09:44:08 myhost kernel: [  618.441144] select_bad_process,
pid=2047, points=0
Oct 19 09:44:08 myhost kernel: [  618.441146] oom_badness: memoy use
=130, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441147] oom_badness: pid = 2051,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441149] select_bad_process,
pid=2051, points=1
Oct 19 09:44:08 myhost kernel: [  618.441150] oom_badness: memoy use
=1167, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441152] oom_badness: pid = 2055,
oom_score_adj=0, points=2
Oct 19 09:44:08 myhost kernel: [  618.441153] select_bad_process,
pid=2055, points=2
Oct 19 09:44:08 myhost kernel: [  618.441155] oom_badness: memoy use
=146, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441157] oom_badness: pid = 2058,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441158] select_bad_process,
pid=2058, points=1
Oct 19 09:44:08 myhost kernel: [  618.441160] oom_badness: memoy use
=151, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441161] oom_badness: pid = 2060,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441162] select_bad_process,
pid=2060, points=1
Oct 19 09:44:08 myhost kernel: [  618.441164] oom_badness: memoy use
=52, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441165] oom_badness: pid = 2061,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441167] select_bad_process,
pid=2061, points=1
Oct 19 09:44:08 myhost kernel: [  618.441168] oom_badness: memoy use
=4346, totalpages=506807, points=8
Oct 19 09:44:08 myhost kernel: [  618.441170] oom_badness: pid = 2065,
oom_score_adj=0, points=8
Oct 19 09:44:08 myhost kernel: [  618.441171] select_bad_process,
pid=2065, points=8
Oct 19 09:44:08 myhost kernel: [  618.441172] select_bad_process,
===========have choose pid=2065 to kill, points=8
Oct 19 09:44:08 myhost kernel: [  618.441174] oom_badness: memoy use
=139, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441176] oom_badness: pid = 2067,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441177] select_bad_process,
pid=2067, points=1
Oct 19 09:44:08 myhost kernel: [  618.441179] oom_badness: memoy use
=1040, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441181] oom_badness: pid = 2075,
oom_score_adj=0, points=2
Oct 19 09:44:08 myhost kernel: [  618.441182] select_bad_process,
pid=2075, points=2
Oct 19 09:44:08 myhost kernel: [  618.441184] oom_badness: memoy use
=72, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441186] oom_badness: pid = 2076,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441187] select_bad_process,
pid=2076, points=1
Oct 19 09:44:08 myhost kernel: [  618.441189] oom_badness: memoy use
=18211, totalpages=506807, points=35
Oct 19 09:44:08 myhost kernel: [  618.441190] oom_badness: pid = 2078,
oom_score_adj=0, points=35
Oct 19 09:44:08 myhost kernel: [  618.441191] select_bad_process,
pid=2078, points=35
Oct 19 09:44:08 myhost kernel: [  618.441193] select_bad_process,
===========have choose pid=2078 to kill, points=35
Oct 19 09:44:08 myhost kernel: [  618.441195] oom_badness: memoy use
=197, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441196] oom_badness: pid = 2082,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441198] select_bad_process,
pid=2082, points=1
Oct 19 09:44:08 myhost kernel: [  618.441199] oom_badness: memoy use
=1587, totalpages=506807, points=3
Oct 19 09:44:08 myhost kernel: [  618.441201] oom_badness: pid = 2083,
oom_score_adj=0, points=3
Oct 19 09:44:08 myhost kernel: [  618.441202] select_bad_process,
pid=2083, points=3
Oct 19 09:44:08 myhost kernel: [  618.441204] oom_badness: memoy use
=403, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441206] oom_badness: pid = 2085,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441207] select_bad_process,
pid=2085, points=1
Oct 19 09:44:08 myhost kernel: [  618.441209] oom_badness: memoy use
=575, totalpages=506807, points=1
Oct 19 09:44:08 myhost kernel: [  618.441210] oom_badness: pid = 2091,
oom_score_adj=0, points=1
Oct 19 09:44:08 myhost kernel: [  618.441211] select_bad_process,
pid=2091, points=1
Oct 19 09:44:08 myhost kernel: [  618.441213] oom_badness: memoy use
=366, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441214] oom_badness: pid = 2093,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441216] select_bad_process,
pid=2093, points=1
Oct 19 09:44:08 myhost kernel: [  618.441218] oom_badness: memoy use
=912, totalpages=506807, points=1
Oct 19 09:44:08 myhost kernel: [  618.441219] oom_badness: pid = 2094,
oom_score_adj=0, points=1
Oct 19 09:44:08 myhost kernel: [  618.441221] select_bad_process,
pid=2094, points=1
Oct 19 09:44:08 myhost kernel: [  618.441222] oom_badness: memoy use
=315, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441224] oom_badness: pid = 2095,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441225] select_bad_process,
pid=2095, points=1
Oct 19 09:44:08 myhost kernel: [  618.441227] oom_badness: memoy use
=264, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441229] oom_badness: pid = 2096,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441230] select_bad_process,
pid=2096, points=1
Oct 19 09:44:08 myhost kernel: [  618.441232] oom_badness: memoy use
=274, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441233] oom_badness: pid = 2097,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441235] select_bad_process,
pid=2097, points=1
Oct 19 09:44:08 myhost kernel: [  618.441236] oom_badness: memoy use
=300, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441238] oom_badness: pid = 2098,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441239] select_bad_process,
pid=2098, points=1
Oct 19 09:44:08 myhost kernel: [  618.441241] oom_badness: memoy use
=466, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441243] oom_badness: pid = 2099,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441244] select_bad_process,
pid=2099, points=1
Oct 19 09:44:08 myhost kernel: [  618.441245] oom_badness: memoy use
=782, totalpages=506807, points=1
Oct 19 09:44:08 myhost kernel: [  618.441247] oom_badness: pid = 2116,
oom_score_adj=0, points=1
Oct 19 09:44:08 myhost kernel: [  618.441248] select_bad_process,
pid=2116, points=1
Oct 19 09:44:08 myhost kernel: [  618.441250] oom_badness: memoy use
=269, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441252] oom_badness: pid = 2119,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441253] select_bad_process,
pid=2119, points=1
Oct 19 09:44:08 myhost kernel: [  618.441255] oom_badness: memoy use
=362, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441256] oom_badness: pid = 2121,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441257] select_bad_process,
pid=2121, points=1
Oct 19 09:44:08 myhost kernel: [  618.441259] oom_badness: memoy use
=141, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441261] oom_badness: pid = 2130,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441262] select_bad_process,
pid=2130, points=1
Oct 19 09:44:08 myhost kernel: [  618.441264] oom_badness: memoy use
=66, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441265] oom_badness: pid = 2133,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441266] select_bad_process,
pid=2133, points=1
Oct 19 09:44:08 myhost kernel: [  618.441268] oom_badness: memoy use
=1142, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441270] oom_badness: pid = 2144,
oom_score_adj=0, points=2
Oct 19 09:44:08 myhost kernel: [  618.441271] select_bad_process,
pid=2144, points=2
Oct 19 09:44:08 myhost kernel: [  618.441273] oom_badness: memoy use
=2208, totalpages=506807, points=4
Oct 19 09:44:08 myhost kernel: [  618.441274] oom_badness: pid = 2147,
oom_score_adj=0, points=-26
Oct 19 09:44:08 myhost kernel: [  618.441276] select_bad_process,
pid=2147, points=1
Oct 19 09:44:08 myhost kernel: [  618.441278] oom_badness: memoy use
=102, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441279] oom_badness: pid = 2151,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441281] select_bad_process,
pid=2151, points=1
Oct 19 09:44:08 myhost kernel: [  618.441282] oom_badness: memoy use
=161, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441284] oom_badness: pid = 2157,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441285] select_bad_process,
pid=2157, points=1
Oct 19 09:44:08 myhost kernel: [  618.441287] oom_badness: memoy use
=30, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441288] oom_badness: pid = 2159,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441290] select_bad_process,
pid=2159, points=1
Oct 19 09:44:08 myhost kernel: [  618.441291] oom_badness: memoy use
=481, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441293] oom_badness: pid = 2161,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441294] select_bad_process,
pid=2161, points=1
Oct 19 09:44:08 myhost kernel: [  618.441296] oom_badness: memoy use
=183, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441298] oom_badness: pid = 2173,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441299] select_bad_process,
pid=2173, points=1
Oct 19 09:44:08 myhost kernel: [  618.441301] oom_badness: memoy use
=189, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441302] oom_badness: pid = 2192,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441303] select_bad_process,
pid=2192, points=1
Oct 19 09:44:08 myhost kernel: [  618.441305] oom_badness: memoy use
=41, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441307] oom_badness: pid = 2218,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441308] select_bad_process,
pid=2218, points=1
Oct 19 09:44:08 myhost kernel: [  618.441310] oom_badness: memoy use
=46, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441312] oom_badness: pid = 2219,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441313] select_bad_process,
pid=2219, points=1
Oct 19 09:44:08 myhost kernel: [  618.441314] oom_badness: memoy use
=36, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441316] oom_badness: pid = 2284,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441317] select_bad_process,
pid=2284, points=1
Oct 19 09:44:08 myhost kernel: [  618.441319] oom_badness: memoy use
=480, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441321] oom_badness: pid = 2285,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441322] select_bad_process,
pid=2285, points=1
Oct 19 09:44:08 myhost kernel: [  618.441324] oom_badness: memoy use
=288, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441325] oom_badness: pid = 2339,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441327] select_bad_process,
pid=2339, points=1
Oct 19 09:44:08 myhost kernel: [  618.441329] oom_badness: memoy use
=76, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441330] oom_badness: pid = 2403,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441331] select_bad_process,
pid=2403, points=1
Oct 19 09:44:08 myhost kernel: [  618.441333] oom_badness: memoy use
=480, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441335] oom_badness: pid = 2425,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441336] select_bad_process,
pid=2425, points=1
Oct 19 09:44:08 myhost kernel: [  618.441338] oom_badness: memoy use
=36, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441339] oom_badness: pid = 2513,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441341] select_bad_process,
pid=2513, points=1
Oct 19 09:44:08 myhost kernel: [  618.441342] oom_badness: memoy use
=455, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441344] oom_badness: pid = 2518,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441345] select_bad_process,
pid=2518, points=1
Oct 19 09:44:08 myhost kernel: [  618.441347] oom_badness: memoy use
=592, totalpages=506807, points=1
Oct 19 09:44:08 myhost kernel: [  618.441349] oom_badness: pid = 2581,
oom_score_adj=0, points=1
Oct 19 09:44:08 myhost kernel: [  618.441350] select_bad_process,
pid=2581, points=1
Oct 19 09:44:08 myhost kernel: [  618.441352] oom_badness: memoy use
=1076, totalpages=506807, points=2
Oct 19 09:44:08 myhost kernel: [  618.441353] oom_badness: pid = 2590,
oom_score_adj=0, points=2
Oct 19 09:44:08 myhost kernel: [  618.441355] select_bad_process,
pid=2590, points=2
Oct 19 09:44:08 myhost kernel: [  618.441356] oom_badness: memoy use
=278247, totalpages=506807, points=549
Oct 19 09:44:08 myhost kernel: [  618.441358] oom_badness: pid = 2646,
oom_score_adj=0, points=549
Oct 19 09:44:08 myhost kernel: [  618.441359] select_bad_process,
pid=2646, points=549
Oct 19 09:44:08 myhost kernel: [  618.441360] select_bad_process,
===========have choose pid=2646 to kill, points=549
Oct 19 09:44:08 myhost kernel: [  618.441362] oom_badness: memoy use
=12734, totalpages=506807, points=25
Oct 19 09:44:08 myhost kernel: [  618.441364] oom_badness: pid = 2834,
oom_score_adj=0, points=25
Oct 19 09:44:08 myhost kernel: [  618.441365] select_bad_process,
pid=2834, points=25
Oct 19 09:44:08 myhost kernel: [  618.441367] oom_badness: memoy use
=101, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441368] oom_badness: pid = 2838,
oom_score_adj=0, points=0
Oct 19 09:44:08 myhost kernel: [  618.441370] select_bad_process,
pid=2838, points=1
Oct 19 09:44:08 myhost kernel: [  618.441372] oom_badness: memoy use
=23285, totalpages=506807, points=45
Oct 19 09:44:08 myhost kernel: [  618.441373] oom_badness: pid = 2854,
oom_score_adj=0, points=45
Oct 19 09:44:08 myhost kernel: [  618.441374] select_bad_process,
pid=2854, points=45
Oct 19 09:44:08 myhost kernel: [  618.441376] oom_badness: memoy use
=15149, totalpages=506807, points=29
Oct 19 09:44:08 myhost kernel: [  618.441377] oom_badness: pid = 2942,
oom_score_adj=0, points=29
Oct 19 09:44:08 myhost kernel: [  618.441379] select_bad_process,
pid=2942, points=29
Oct 19 09:44:08 myhost kernel: [  618.441380] oom_badness: memoy use
=23280, totalpages=506807, points=45
Oct 19 09:44:08 myhost kernel: [  618.441382] oom_badness: pid = 3140,
oom_score_adj=0, points=45
Oct 19 09:44:08 myhost kernel: [  618.441383] select_bad_process,
pid=3140, points=45
Oct 19 09:44:08 myhost kernel: [  618.441384] oom_badness: memoy use
=12292, totalpages=506807, points=24
Oct 19 09:44:08 myhost kernel: [  618.441386] oom_badness: pid = 3298,
oom_score_adj=0, points=24
Oct 19 09:44:08 myhost kernel: [  618.441387] select_bad_process,
pid=3298, points=24
Oct 19 09:44:08 myhost kernel: [  618.441389] oom_badness: memoy use
=15003, totalpages=506807, points=29
Oct 19 09:44:08 myhost kernel: [  618.441390] oom_badness: pid = 3327,
oom_score_adj=0, points=29
Oct 19 09:44:08 myhost kernel: [  618.441392] select_bad_process,
pid=3327, points=29
Oct 19 09:44:08 myhost kernel: [  618.441394] oom_badness: memoy use
=34, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441395] oom_badness: pid = 3346,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441396] select_bad_process,
pid=3346, points=1
Oct 19 09:44:08 myhost kernel: [  618.441398] oom_badness: memoy use
=35, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441399] oom_badness: pid = 3347,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441401] select_bad_process,
pid=3347, points=1
Oct 19 09:44:08 myhost kernel: [  618.441403] oom_badness: memoy use
=35, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441404] oom_badness: pid = 3349,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441405] select_bad_process,
pid=3349, points=1
Oct 19 09:44:08 myhost kernel: [  618.441407] oom_badness: memoy use
=43, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441409] oom_badness: pid = 3353,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441410] select_bad_process,
pid=3353, points=1
Oct 19 09:44:08 myhost kernel: [  618.441412] oom_badness: memoy use
=43, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441413] oom_badness: pid = 3354,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441415] select_bad_process,
pid=3354, points=1
Oct 19 09:44:08 myhost kernel: [  618.441417] oom_badness: memoy use
=56, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441418] oom_badness: pid = 3355,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441419] select_bad_process,
pid=3355, points=1
Oct 19 09:44:08 myhost kernel: [  618.441421] oom_badness: memoy use
=56, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441423] oom_badness: pid = 3356,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441424] select_bad_process,
pid=3356, points=1
Oct 19 09:44:08 myhost kernel: [  618.441426] oom_badness: memoy use
=58, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441427] oom_badness: pid = 3387,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441429] select_bad_process,
pid=3387, points=1
Oct 19 09:44:08 myhost kernel: [  618.441430] oom_badness: memoy use
=59, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441432] oom_badness: pid = 3388,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441433] select_bad_process,
pid=3388, points=1
Oct 19 09:44:08 myhost kernel: [  618.441435] oom_badness: memoy use
=87, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441436] oom_badness: pid = 3389,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441438] select_bad_process,
pid=3389, points=1
Oct 19 09:44:08 myhost kernel: [  618.441439] oom_badness: memoy use
=87, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441441] oom_badness: pid = 3390,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441442] select_bad_process,
pid=3390, points=1
Oct 19 09:44:08 myhost kernel: [  618.441444] oom_badness: memoy use
=17474, totalpages=506807, points=34
Oct 19 09:44:08 myhost kernel: [  618.441445] oom_badness: pid = 3414,
oom_score_adj=0, points=34
Oct 19 09:44:08 myhost kernel: [  618.441446] select_bad_process,
pid=3414, points=34
Oct 19 09:44:08 myhost kernel: [  618.441448] oom_badness: memoy use
=7391, totalpages=506807, points=14
Oct 19 09:44:08 myhost kernel: [  618.441450] oom_badness: pid = 3536,
oom_score_adj=0, points=14
Oct 19 09:44:08 myhost kernel: [  618.441451] select_bad_process,
pid=3536, points=14
Oct 19 09:44:08 myhost kernel: [  618.441453] oom_badness: memoy use
=24, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441454] oom_badness: pid = 3560,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441456] select_bad_process,
pid=3560, points=1
Oct 19 09:44:08 myhost kernel: [  618.441457] oom_badness: memoy use
=22, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441459] oom_badness: pid = 3562,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441460] select_bad_process,
pid=3562, points=1
Oct 19 09:44:08 myhost kernel: [  618.441462] oom_badness: memoy use
=22, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441463] oom_badness: pid = 3563,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441464] select_bad_process,
pid=3563, points=1
Oct 19 09:44:08 myhost kernel: [  618.441466] oom_badness: memoy use
=22, totalpages=506807, points=0
Oct 19 09:44:08 myhost kernel: [  618.441467] oom_badness: pid = 3564,
oom_score_adj=0, points=-30
Oct 19 09:44:08 myhost kernel: [  618.441469] select_bad_process,
pid=3564, points=1
Oct 19 09:44:08 myhost kernel: [  618.441470] httpd invoked oom-killer:
gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
Oct 19 09:44:08 myhost kernel: [  618.441473] httpd cpuset=/
mems_allowed=0
Oct 19 09:44:08 myhost kernel: [  618.441475] Pid: 1739, comm: httpd Not
tainted 2.6.36testing #5
Oct 19 09:44:08 myhost kernel: [  618.441476] Call Trace:
Oct 19 09:44:08 myhost kernel: [  618.441482]  [<c10c0a20>]
dump_header.clone.5+0x80/0x1e0
Oct 19 09:44:08 myhost kernel: [  618.441486]  [<c12eb566>] ? printk
+0x18/0x1a
Oct 19 09:44:08 myhost kernel: [  618.441488]  [<c10c0d85>] ?
oom_badness+0x185/0x1a0
Oct 19 09:44:08 myhost kernel: [  618.441490]  [<c10c0dfc>]
oom_kill_process+0x5c/0x1c0
Oct 19 09:44:08 myhost kernel: [  618.441492]  [<c10c102a>] ?
select_bad_process.clone.7+0xca/0x100
Oct 19 09:44:08 myhost kernel: [  618.441494]  [<c10c12ff>]
out_of_memory+0xbf/0x1d0
Oct 19 09:44:08 myhost kernel: [  618.441496]  [<c10c11c8>] ?
try_set_zonelist_oom+0xc8/0xe0
Oct 19 09:44:08 myhost kernel: [  618.441499]  [<c10c4b88>]
__alloc_pages_nodemask+0x5e8/0x600
Oct 19 09:44:08 myhost kernel: [  618.441502]  [<c10c6535>]
__do_page_cache_readahead+0x105/0x230
Oct 19 09:44:08 myhost kernel: [  618.441504]  [<c10c68c1>] ra_submit
+0x21/0x30
Oct 19 09:44:08 myhost kernel: [  618.441506]  [<c10beb8b>]
filemap_fault+0x36b/0x3e0
Oct 19 09:44:08 myhost kernel: [  618.441510]  [<c10d5c5b>] __do_fault
+0x3b/0x4f0
Oct 19 09:44:08 myhost kernel: [  618.441512]  [<c10d8cbd>]
handle_mm_fault+0xfd/0x930
Oct 19 09:44:08 myhost kernel: [  618.441515]  [<c1029250>] ?
do_page_fault+0x0/0x3e0
Oct 19 09:44:08 myhost kernel: [  618.441517]  [<c10293a0>]
do_page_fault+0x150/0x3e0
Oct 19 09:44:08 myhost kernel: [  618.441521]  [<c1045d70>] ?
child_wait_callback+0x0/0xa0
Oct 19 09:44:08 myhost kernel: [  618.441523]  [<c1048467>] ?
sys_waitpid+0x27/0x30
Oct 19 09:44:08 myhost kernel: [  618.441525]  [<c1029250>] ?
do_page_fault+0x0/0x3e0
Oct 19 09:44:08 myhost kernel: [  618.441527]  [<c12ef1ab>] error_code
+0x67/0x6c
Oct 19 09:44:08 myhost kernel: [  618.441529] Mem-Info:
Oct 19 09:44:08 myhost kernel: [  618.441530] DMA per-cpu:
Oct 19 09:44:08 myhost kernel: [  618.441531] CPU    0: hi:    0, btch:
1 usd:   0
Oct 19 09:44:08 myhost kernel: [  618.441533] CPU    1: hi:    0, btch:
1 usd:   0
Oct 19 09:44:08 myhost kernel: [  618.441534] Normal per-cpu:
Oct 19 09:44:08 myhost kernel: [  618.441535] CPU    0: hi:  186, btch:
31 usd:  35
Oct 19 09:44:08 myhost kernel: [  618.441536] CPU    1: hi:  186, btch:
31 usd:  14
Oct 19 09:44:08 myhost kernel: [  618.441538] HighMem per-cpu:
Oct 19 09:44:08 myhost kernel: [  618.441539] CPU    0: hi:  186, btch:
31 usd:  98
Oct 19 09:44:08 myhost kernel: [  618.441540] CPU    1: hi:  186, btch:
31 usd:  58
Oct 19 09:44:08 myhost kernel: [  618.441543] active_anon:168162
inactive_anon:48949 isolated_anon:0
Oct 19 09:44:08 myhost kernel: [  618.441544]  active_file:69
inactive_file:350 isolated_file:0
Oct 19 09:44:08 myhost kernel: [  618.441545]  unevictable:10 dirty:0
writeback:5 unstable:0
Oct 19 09:44:08 myhost kernel: [  618.441546]  free:11927
slab_reclaimable:1903 slab_unreclaimable:3882
Oct 19 09:44:08 myhost kernel: [  618.441546]  mapped:267673 shmem:19397
pagetables:1721 bounce:0
Oct 19 09:44:08 myhost kernel: [  618.441551] DMA free:7968kB min:64kB
low:80kB high:96kB active_anon:3700kB inactive_anon:3752kB
active_file:12kB inactive_file:252kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15788kB mlocked:0kB dirty:0kB writeback:4kB
mapped:52kB shmem:348kB slab_reclaimable:0kB slab_unreclaimable:16kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:421 all_unreclaimable? yes
Oct 19 09:44:08 myhost kernel: [  618.441554] lowmem_reserve[]: 0 865
1980 1980
Oct 19 09:44:08 myhost kernel: [  618.441560] Normal free:39348kB
min:3728kB low:4660kB high:5592kB active_anon:176740kB
inactive_anon:25640kB active_file:84kB inactive_file:308kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB
mlocked:0kB dirty:0kB writeback:4kB mapped:576992kB shmem:5024kB
slab_reclaimable:7612kB slab_unreclaimable:15512kB kernel_stack:2792kB
pagetables:6884kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:741 all_unreclaimable? yes
Oct 19 09:44:08 myhost kernel: [  618.441563] lowmem_reserve[]: 0 0 8921
8921
Oct 19 09:44:08 myhost kernel: [  618.441569] HighMem free:392kB
min:512kB low:1712kB high:2912kB active_anon:492208kB
inactive_anon:166404kB active_file:180kB inactive_file:840kB
unevictable:40kB isolated(anon):0kB isolated(file):0kB present:1141984kB
mlocked:40kB dirty:0kB writeback:12kB mapped:493648kB shmem:72216kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:1552 all_unreclaimable? yes
Oct 19 09:44:08 myhost kernel: [  618.441572] lowmem_reserve[]: 0 0 0 0
Oct 19 09:44:08 myhost kernel: [  618.441575] DMA: 6*4kB 9*8kB 31*16kB
18*32kB 12*64kB 9*128kB 3*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =
7952kB
Oct 19 09:44:08 myhost kernel: [  618.441581] Normal: 37*4kB 176*8kB
152*16kB 63*32kB 55*64kB 25*128kB 16*256kB 10*512kB 9*1024kB 2*2048kB
1*4096kB = 39348kB
Oct 19 09:44:08 myhost kernel: [  618.441587] HighMem: 70*4kB 6*8kB
4*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB
= 392kB
Oct 19 09:44:08 myhost kernel: [  618.441592] 19873 total pagecache
pages
Oct 19 09:44:08 myhost kernel: [  618.441594] 0 pages in swap cache
Oct 19 09:44:08 myhost kernel: [  618.441595] Swap cache stats: add 0,
delete 0, find 0/0
Oct 19 09:44:08 myhost kernel: [  618.441596] Free swap  = 0kB
Oct 19 09:44:08 myhost kernel: [  618.441597] Total swap = 0kB
Oct 19 09:44:08 myhost kernel: [  618.445111] 515070 pages RAM
Oct 19 09:44:08 myhost kernel: [  618.445112] 287745 pages HighMem
Oct 19 09:44:08 myhost kernel: [  618.445113] 273107 pages reserved
Oct 19 09:44:08 myhost kernel: [  618.445114] 20369 pages shared
Oct 19 09:44:08 myhost kernel: [  618.445115] 218695 pages non-shared
Oct 19 09:44:08 myhost kernel: [  618.445116] [ pid ]   uid  tgid
total_vm      rss cpu oom_adj oom_score_adj name
Oct 19 09:44:08 myhost kernel: [  618.445123] [  584]     0   584
574      166   0     -17         -1000 udevd
Oct 19 09:44:08 myhost kernel: [  618.445127] [ 1304]     0  1304
1280       52   1       0             0 syslog-ng
Oct 19 09:44:08 myhost kernel: [  618.445129] [ 1305]     0  1305
1358      115   1       0             0 syslog-ng
Oct 19 09:44:08 myhost kernel: [  618.445132] [ 1307]    81  1307
752      215   0       0             0 dbus-daemon
Oct 19 09:44:08 myhost kernel: [  618.445135] [ 1310]    82  1310
3757      214   1       0             0 hald
Oct 19 09:44:08 myhost kernel: [  618.445137] [ 1311]     0  1311
898       62   0       0             0 hald-runner
Oct 19 09:44:08 myhost kernel: [  618.445140] [ 1340]     0  1340
914       33   1       0             0 hald-addon-inpu
Oct 19 09:44:08 myhost kernel: [  618.445142] [ 1354]     0  1354
914       35   1       0             0 hald-addon-stor
Oct 19 09:44:08 myhost kernel: [  618.445145] [ 1356]    82  1356
823       40   0       0             0 hald-addon-acpi
Oct 19 09:44:08 myhost kernel: [  618.445148] [ 1419]     0  1419
451       22   1       0             0 crond
Oct 19 09:44:08 myhost kernel: [  618.445150] [ 1450]     0  1450
3575      103   1       0             0 gdm-binary
Oct 19 09:44:08 myhost kernel: [  618.445153] [ 1453]     0  1453
718       52   0       0             0 mysqld_safe
Oct 19 09:44:08 myhost kernel: [  618.445156] [ 1465]     0  1465
439       23   0       0             0 agetty
Oct 19 09:44:08 myhost kernel: [  618.445158] [ 1466]     0  1466
439       23   1       0             0 agetty
Oct 19 09:44:08 myhost kernel: [  618.445161] [ 1467]     0  1467
439       23   1       0             0 agetty
Oct 19 09:44:08 myhost kernel: [  618.445163] [ 1468]     0  1468
439       23   1       0             0 agetty
Oct 19 09:44:08 myhost kernel: [  618.445166] [ 1469]     0  1469
439       22   0       0             0 agetty
Oct 19 09:44:08 myhost kernel: [  618.445168] [ 1470]     0  1470
439       22   1       0             0 agetty
Oct 19 09:44:08 myhost kernel: [  618.445171] [ 1547]     0  1547
1647       96   0     -17         -1000 sshd
Oct 19 09:44:08 myhost kernel: [  618.445174] [ 1571]     0  1571
2214      170   1       0             0 cupsd
Oct 19 09:44:08 myhost kernel: [  618.445176] [ 1586]     0  1586
477       23   0       0             0 cntlm
Oct 19 09:44:08 myhost kernel: [  618.445179] [ 1592]     0  1592
4391      179   1       0             0 gdm-simple-slav
Oct 19 09:44:08 myhost kernel: [  618.445181] [ 1593]     0  1593
6451      168   1       0             0 NetworkManager
Oct 19 09:44:08 myhost kernel: [  618.445184] [ 1616]     0  1616
5745      236   1       0             0 polkitd
Oct 19 09:44:08 myhost kernel: [  618.445187] [ 1626]     0  1626
2014       61   0       0             0 vmware-usbarbit
Oct 19 09:44:08 myhost kernel: [  618.445189] [ 1658]     0  1658
25307     7037   1       0             0 Xorg
Oct 19 09:44:08 myhost kernel: [  618.445192] [ 1700]    89  1700
29902     2816   1       0             0 mysqld
Oct 19 09:44:08 myhost kernel: [  618.445194] [ 1701]     0  1701
4910      225   1       0             0 smbd
Oct 19 09:44:08 myhost kernel: [  618.445197] [ 1710]     0  1710
2809      187   0       0             0 nmbd
Oct 19 09:44:08 myhost kernel: [  618.445199] [ 1715]     0  1715
1247       56   0       0             0 wpa_supplicant
Oct 19 09:44:08 myhost kernel: [  618.445202] [ 1716]     0  1716
540      137   1     -17         -1000 udevd
Oct 19 09:44:08 myhost kernel: [  618.445204] [ 1738]     0  1738
4910      225   0       0             0 smbd
Oct 19 09:44:08 myhost kernel: [  618.445207] [ 1739]     0  1739
5162     1363   0       0             0 httpd
Oct 19 09:44:08 myhost kernel: [  618.445209] [ 1742]    33  1742
4841     1148   0       0             0 httpd
Oct 19 09:44:08 myhost kernel: [  618.445211] [ 1748]     0  1748
946       40   0       0             0 ApplicationPool
Oct 19 09:44:08 myhost kernel: [  618.445214] [ 1749]     0  1749
3555      768   1       0             0 ruby
Oct 19 09:44:08 myhost kernel: [  618.445217] [ 1752]    33  1752
5162     1359   1       0             0 httpd
Oct 19 09:44:08 myhost kernel: [  618.445219] [ 1753]    33  1753
5162     1359   0       0             0 httpd
Oct 19 09:44:08 myhost kernel: [  618.445222] [ 1754]    33  1754
5162     1359   0       0             0 httpd
Oct 19 09:44:08 myhost kernel: [  618.445224] [ 1755]    33  1755
5162     1359   0       0             0 httpd
Oct 19 09:44:08 myhost kernel: [  618.445226] [ 1756]    33  1756
5162     1359   0       0             0 httpd
Oct 19 09:44:08 myhost kernel: [  618.445229] [ 1775]     0  1775
6671      149   1       0             0 console-kit-dae
Oct 19 09:44:08 myhost kernel: [  618.445232] [ 1867]     0  1867
487       24   1       0             0 dhcpcd
Oct 19 09:44:08 myhost kernel: [  618.445234] [ 1893]   120  1893
6828      285   0       0             0 polkit-gnome-au
Oct 19 09:44:08 myhost kernel: [  618.445237] [ 1899]     0  1899
3668      110   0       0             0 upowerd
Oct 19 09:44:08 myhost kernel: [  618.445239] [ 1900]     0  1900
3900       97   0       0             0 gdm-session-wor
Oct 19 09:44:08 myhost kernel: [  618.445242] [ 1967]  1000  1967
7737      134   1       0             0 gnome-keyring-d
Oct 19 09:44:08 myhost kernel: [  618.445244] [ 1986]  1000  1986
9209      301   1       0             0 gnome-session
Oct 19 09:44:08 myhost kernel: [  618.445247] [ 2013]  1000  2013
794       42   1       0             0 dbus-launch
Oct 19 09:44:08 myhost kernel: [  618.445250] [ 2014]  1000  2014
1034      261   0       0             0 dbus-daemon
Oct 19 09:44:08 myhost kernel: [  618.445252] [ 2016]  1000  2016
886       51   0       0             0 ssh-agent
Oct 19 09:44:08 myhost kernel: [  618.445255] [ 2021]  1000  2021
2645      463   0       0             0 gconfd-2
Oct 19 09:44:08 myhost kernel: [  618.445257] [ 2024]  1000  2024
7535     1031   1       0             0 fcitx
Oct 19 09:44:08 myhost kernel: [  618.445260] [ 2033]  1000  2033
8792      824   1       0             0 gnome-settings-
Oct 19 09:44:08 myhost kernel: [  618.445263] [ 2038]  1000  2038
2168       70   1       0             0 gvfsd
Oct 19 09:44:08 myhost kernel: [  618.445265] [ 2041]  1000  2041
8709      720   1       0             0 metacity
Oct 19 09:44:08 myhost kernel: [  618.445268] [ 2047]     0  2047
573      160   0     -17         -1000 udevd
Oct 19 09:44:08 myhost kernel: [  618.445271] [ 2051]  1000  2051
7599      130   1       0             0 gvfs-fuse-daemo
Oct 19 09:44:08 myhost kernel: [  618.445273] [ 2055]  1000  2055
46424     1167   0       0             0 gnome-panel
Oct 19 09:44:08 myhost kernel: [  618.445276] [ 2058]  1000  2058
2510      146   0       0             0 gvfs-gdu-volume
Oct 19 09:44:08 myhost kernel: [  618.445278] [ 2060]     0  2060
5721      151   0       0             0 udisks-daemon
Oct 19 09:44:08 myhost kernel: [  618.445281] [ 2061]     0  2061
1284       52   1       0             0 udisks-daemon
Oct 19 09:44:08 myhost kernel: [  618.445284] [ 2065]  1000  2065
59963     4346   0       0             0 nautilus
Oct 19 09:44:08 myhost kernel: [  618.445286] [ 2067]  1000  2067
9063      139   1       0             0 bonobo-activati
Oct 19 09:44:08 myhost kernel: [  618.445289] [ 2075]  1000  2075
43722     1040   1       0             0 wnck-applet
Oct 19 09:44:08 myhost kernel: [  618.445292] [ 2076]  1000  2076
1631       72   0       0             0 sh
Oct 19 09:44:08 myhost kernel: [  618.445294] [ 2078]  1000  2078
86505    18211   1       0             0 evolution
Oct 19 09:44:08 myhost kernel: [  618.445297] [ 2082]  1000  2082
6808      197   0       0             0 polkit-gnome-au
Oct 19 09:44:08 myhost kernel: [  618.445299] [ 2083]  1000  2083
8439     1587   1       0             0 applet.py
Oct 19 09:44:08 myhost kernel: [  618.445302] [ 2085]  1000  2085
10769      403   0       0             0 evolution-alarm
Oct 19 09:44:08 myhost kernel: [  618.445304] [ 2091]  1000  2091
42308      575   1       0             0 cpufreq-applet
Oct 19 09:44:08 myhost kernel: [  618.445307] [ 2093]  1000  2093
41468      366   1       0             0 multiload-apple
Oct 19 09:44:08 myhost kernel: [  618.445310] [ 2094]  1000  2094
43601      912   1       0             0 mixer_applet2
Oct 19 09:44:08 myhost kernel: [  618.445312] [ 2095]  1000  2095
40975      315   0       0             0 notification-ar
Oct 19 09:44:08 myhost kernel: [  618.445315] [ 2096]  1000  2096
5037      264   0       0             0 gdu-notificatio
Oct 19 09:44:08 myhost kernel: [  618.445317] [ 2097]  1000  2097
7274      274   1       0             0 gnome-power-man
Oct 19 09:44:08 myhost kernel: [  618.445320] [ 2098]  1000  2098
7574      300   0       0             0 vino-server
Oct 19 09:44:08 myhost kernel: [  618.445322] [ 2099]  1000  2099
72310      466   0       0             0 nm-applet
Oct 19 09:44:08 myhost kernel: [  618.445325] [ 2116]  1000  2116
45627      782   0       0             0 clock-applet
Oct 19 09:44:08 myhost kernel: [  618.445328] [ 2119]  1000  2119
7247      269   1       0             0 gnome-screensav
Oct 19 09:44:08 myhost kernel: [  618.445330] [ 2121]  1000  2121
15260      362   0       0             0 e-calendar-fact
Oct 19 09:44:08 myhost kernel: [  618.445333] [ 2130]  1000  2130
2299      141   0       0             0 gvfsd-trash
Oct 19 09:44:08 myhost kernel: [  618.445335] [ 2133]     0  2133
3290       66   1       0             0 system-tools-ba
Oct 19 09:44:08 myhost kernel: [  618.445338] [ 2144]  1000  2144
43820     1142   0       0             0 gnome-terminal
Oct 19 09:44:08 myhost kernel: [  618.445340] [ 2147]     0  2147
3296     2208   1       0             0 SystemToolsBack
Oct 19 09:44:08 myhost kernel: [  618.445343] [ 2151]  1000  2151
2201      102   1       0             0 gvfsd-burn
Oct 19 09:44:08 myhost kernel: [  618.445346] [ 2157]  1000  2157
1806      161   0       0             0 mission-control
Oct 19 09:44:08 myhost kernel: [  618.445348] [ 2159]  1000  2159
450       30   1       0             0 gnome-pty-helpe
Oct 19 09:44:08 myhost kernel: [  618.445351] [ 2161]  1000  2161
2067      481   0       0             0 bash
Oct 19 09:44:08 myhost kernel: [  618.445353] [ 2173]  1000  2173
2287      183   0       0             0 gvfsd-metadata
Oct 19 09:44:08 myhost kernel: [  618.445356] [ 2192]  1000  2192
22559      189   0       0             0 conky
Oct 19 09:44:08 myhost kernel: [  618.445358] [ 2218]     0  2218
794       41   0       0             0 dbus-launch
Oct 19 09:44:08 myhost kernel: [  618.445361] [ 2219]     0  2219
593       46   1       0             0 dbus-daemon
Oct 19 09:44:08 myhost kernel: [  618.445363] [ 2284]  1000  2284
1480       36   1       0             0 su
Oct 19 09:44:08 myhost kernel: [  618.445366] [ 2285]     0  2285
2042      480   1       0             0 bash
Oct 19 09:44:08 myhost kernel: [  618.445368] [ 2339]     0  2339
6275      288   0       0             0 vim
Oct 19 09:44:08 myhost kernel: [  618.445371] [ 2403]     0  2403
1663       76   1       0             0 sh
Oct 19 09:44:08 myhost kernel: [  618.445373] [ 2425]  1000  2425
2067      480   0       0             0 bash
Oct 19 09:44:08 myhost kernel: [  618.445376] [ 2513]  1000  2513
1480       36   0       0             0 su
Oct 19 09:44:08 myhost kernel: [  618.445378] [ 2518]     0  2518
2042      455   1       0             0 bash
Oct 19 09:44:08 myhost kernel: [  618.445381] [ 2581]  1000  2581
2930      592   1       0             0 VBoxXPCOMIPCD
Oct 19 09:44:08 myhost kernel: [  618.445384] [ 2590]  1000  2590
4996     1076   0       0             0 VBoxSVC
Oct 19 09:44:08 myhost kernel: [  618.445386] [ 2646]  1000  2646
311501   278247   0       0             0 VirtualBox
Oct 19 09:44:08 myhost kernel: [  618.445389] [ 2834]  1000  2834
61628    12734   1       0             0 evince
Oct 19 09:44:08 myhost kernel: [  618.445391] [ 2838]  1000  2838
5458      101   1       0             0 evinced
Oct 19 09:44:08 myhost kernel: [  618.445394] [ 2854]  1000  2854
61457    23285   1       0             0 acroread
Oct 19 09:44:08 myhost kernel: [  618.445396] [ 2942]  1000  2942
60581    15149   0       0             0 evince
Oct 19 09:44:08 myhost kernel: [  618.445399] [ 3140]  1000  3140
81044    23280   1       0             0 evince
Oct 19 09:44:08 myhost kernel: [  618.445401] [ 3298]  1000  3298
59753    12292   0       0             0 evince
Oct 19 09:44:08 myhost kernel: [  618.445404] [ 3327]  1000  3327
60274    15003   0       0             0 evince
Oct 19 09:44:08 myhost kernel: [  618.445406] [ 3346]     0  3346
717       34   0       0             0 sh
Oct 19 09:44:08 myhost kernel: [  618.445408] [ 3347]     0  3347
717       35   0       0             0 sh
Oct 19 09:44:08 myhost kernel: [  618.445411] [ 3349]     0  3349
717       35   1       0             0 sh
Oct 19 09:44:08 myhost kernel: [  618.445413] [ 3353]     0  3353
1185       43   0       0             0 git
Oct 19 09:44:08 myhost kernel: [  618.445416] [ 3354]     0  3354
1185       43   1       0             0 git
Oct 19 09:44:08 myhost kernel: [  618.445418] [ 3355]     0  3355
717       56   0       0             0 git-pull
Oct 19 09:44:08 myhost kernel: [  618.445421] [ 3356]     0  3356
717       56   1       0             0 git-pull
Oct 19 09:44:08 myhost kernel: [  618.445423] [ 3387]     0  3387
1187       58   1       0             0 git
Oct 19 09:44:08 myhost kernel: [  618.445426] [ 3388]     0  3388
1187       59   0       0             0 git
Oct 19 09:44:08 myhost kernel: [  618.445428] [ 3389]     0  3389
1571       87   1       0             0 ssh
Oct 19 09:44:08 myhost kernel: [  618.445430] [ 3390]     0  3390
1571       87   0       0             0 ssh
Oct 19 09:44:08 myhost kernel: [  618.445433] [ 3414]  1000  3414
63272    17474   0       0             0 evince
Oct 19 09:44:08 myhost kernel: [  618.445436] [ 3536]  1000  3536
59510     7391   1       0             0 evince
Oct 19 09:44:08 myhost kernel: [  618.445438] [ 3560]     0  3560
1016       24   0       0             0 cp
Oct 19 09:44:08 myhost kernel: [  618.445441] [ 3562]     0  3562
451       22   1       0             0 crond
Oct 19 09:44:08 myhost kernel: [  618.445443] [ 3563]     0  3563
451       22   0       0             0 crond
Oct 19 09:44:08 myhost kernel: [  618.445446] [ 3564]     0  3564
451       22   1       0             0 crond

