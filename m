Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab1JNRDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:03:16 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:45483 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1JNRDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:03:15 -0400
From: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "Seger, Mark" <mark.seger@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Fri, 14 Oct 2011 18:02:16 +0100
Subject: RE: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Topic: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Index: AcyKkpBGBr00LwCHTo6XbMuC8Y0O1wAABydw
Message-ID: <8DC664164FA4D1449479E7B36CDCFB1F221F060AC2@GVW0676EXC.americas.hpqcorp.net>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
	 <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>
	 <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <8DC664164FA4D1449479E7B36CDCFB1F221F060A48@GVW0676EXC.americas.hpqcorp.net>
	 <1318610416.2223.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <8DC664164FA4D1449479E7B36CDCFB1F221F060A92@GVW0676EXC.americas.hpqcorp.net>
 <1318611542.2223.47.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1318611542.2223.47.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9EH3NT2020339

Hi Eric,

Just FYI, the same behavior is seen on multiple hardware platforms so it is definitely kernel changes. The earlier kernel on the DL785 platform was returning reads within 60 microseconds.
I have measured it on multiple platforms.

In this case we have a DL980 with HT enabled so you will see 128 CPUS. If I shut off HT, it does not make a difference.

[root@linuxbeast boot]# dmesg | grep nr_cpu_ids
NR_CPUS:4096 nr_cpumask_bits:128 nr_cpu_ids:128 nr_node_ids:8

-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
Sent: Friday, October 14, 2011 12:59 PM
To: Oberman, Laurence (HAS GSE)
Cc: Seger, Mark; linux-kernel@vger.kernel.org; Cabaniols, Sebastien
Subject: RE: Regression in reading /proc/stat in the newer kernels with large SMP and NUMA configurations

Le vendredi 14 octobre 2011 Ã  17:52 +0100, Oberman, Laurence (HAS GSE) a
Ã©crit :
> Standard RHEL kernel build.
> What the customer would be using.
> 
> [root@linuxbeast boot]# cat config-2.6.32-131.6.1.el6.x86_64 | grep NR
> CONFIG_NR_CPUS=4096

Then something must be wrong.... what are your nr_cpu_ids /
nr_cpumask_bits values ?


dmesg | grep nr_cpu_ids



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
