Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab0FRI0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 04:26:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:3927 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926Ab0FRI02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 04:26:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,437,1272870000"; 
   d="scan'208";a="290340414"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: "Shi, Alex" <alex.shi@intel.com>,
       "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
       "davem@davemloft.net" <davem@davemloft.net>
CC: "Chen, Tim C" <tim.c.chen@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 18 Jun 2010 16:26:23 +0800
Subject: RE: TCP stream performance regression due to
 c377411f2494a931ff7facdbb3a6839b1266bcf6
Thread-Topic: TCP stream performance regression due to
 c377411f2494a931ff7facdbb3a6839b1266bcf6
Thread-Index: AcsOv0SUslvWGBkZQEeIBAgbXmyIcgAAE10Q
Message-ID: <33AB447FBD802F4E932063B962385B351F483A15@shsmsx501.ccr.corp.intel.com>
References: <1276845448.2118.346.camel@debian>
In-Reply-To: <1276845448.2118.346.camel@debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5I8Qfim026894

More info about the testing:
It's a loopback testing. We start one client netperf process to communicate with netserver process in a stream TCP testing. To reduce the cpu cache effect, we bind the 2 processes on 2 different physical cpus.
#taskset -c 0 ./netserver
#taskset -c 15 ./netperf -t TCP_STREAM -l 60 -H 127.0.0.1 -i 50,3 -I 99,5 -- -s 57344 -S 57344 -m 4096

>>-----Original Message-----
>>From: Shi, Alex
>>Sent: 2010Äê6ÔÂ18ÈÕ 15:17
>>To: eric.dumazet@gmail.com; davem@davemloft.net
>>Cc: Chen, Tim C; Zhang, Yanmin; linux-kernel@vger.kernel.org
>>Subject: TCP stream performance regression due to
>>c377411f2494a931ff7facdbb3a6839b1266bcf6
>>
>>In our netperf testing, TCP_STREAM56 shows about 20% or more performance
>>regression on WSM/NHM and tigerton machines. The testing boot up both
>>netserver and client on localhost. The testing command like this:
>>./snapshot_script_net TC_STREAM56 127.0.0.1
>>
>>We found the following commit causes this issue.
>>c377411f2494a931ff7facdbb3a6839b1266bcf6
>>Revert this commit will recover this regression on all machine.
>>
>>Regards!
>>Alex

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
