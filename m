Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab2CMVUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:20:06 -0400
Received: from antispam01.maxim-ic.com ([205.153.101.182]:34590 "EHLO
	antispam01.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab2CMVUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:20:04 -0400
X-Greylist: delayed 949 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2012 17:20:04 EDT
X-ASG-Debug-ID: 1331672654-02ae9869b715cb80001-xx1T2L
X-Barracuda-Envelope-From: Jason.Wortham@maxim-ic.com
From: Jason Wortham <Jason.Wortham@maxim-ic.com>
To: bruce robertson <bruce.e.robertson@intel.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
CC: "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dg77.kim@samsung.com" <dg77.kim@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Date: Tue, 13 Mar 2012 14:04:12 -0700
Subject: RE: [PATCH 4/5] max17042: Fix value scaling for VCELL and avgVCELL
Thread-Topic: [PATCH 4/5] max17042: Fix value scaling for VCELL and avgVCELL
X-ASG-Orig-Subj: RE: [PATCH 4/5] max17042: Fix value scaling for VCELL and avgVCELL
Thread-Index: Ac0BXG8F5FSBZG0CSu6cSpVTfbRfUAAAD7DQ
Message-ID: <26513DAD5DB1304EAC06B61C2DD20C270DB5ECE32F@ITSVLEX06.it.maxim-ic.internal>
References: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
	<1327425968-21195-5-git-send-email-dirk.brandewie@gmail.com>
	<20120313181918.GA15964@oksana.dev.rtsoft.ru> <m3pqcg5i8y.fsf@intel.com>
In-Reply-To: <m3pqcg5i8y.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: maxdalex02.maxim-ic.internal[10.16.15.104]
X-Barracuda-Start-Time: 1331672654
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.02
X-Barracuda-Spam-Status: No, SCORE=0.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=THREAD_INDEX, THREAD_TOPIC
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.91119
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 THREAD_INDEX           thread-index: AcO7Y8iR61tzADqsRmmc5wNiFHEOig==
	0.01 THREAD_TOPIC           Thread-Topic: ...(Japanese Subject)...
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bottom 3 bits are still functional bits and aren't required to be masked.  Arguably these bits are below the hardware accuracy of the ADC, however, they still provide some averaging information.

--Jason

-----Original Message-----
From: bruce robertson [mailto:bruce.e.robertson@intel.com] 
Sent: Tuesday, March 13, 2012 2:00 PM
To: Anton Vorontsov
Cc: dirk.brandewie@gmail.com; linux-kernel@vger.kernel.org; dg77.kim@samsung.com; kyungmin.park@samsung.com; myungjoo.ham@samsung.com; Jason Wortham
Subject: Re: [PATCH 4/5] max17042: Fix value scaling for VCELL and avgVCELL

Anton Vorontsov <cbouatmailru@gmail.com> writes:

> On Tue, Jan 24, 2012 at 09:26:07AM -0800, dirk.brandewie@gmail.com wrote:
>> From: Bruce Robertson <bruce.e.robertson@intel.com>
>> 
>> The bottom three bits of the register are don't care bits.  The LSB
>> value is 625 uV.  Adjust the returned values appropriately
>> 
>> Signed-off-by: Bruce Robertson <bruce.e.robertson@intel.com>
>> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
>> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>
> I guess this was fixed long ago by the following patch:
>
> commit cf7a8c03db792894f436db5f3ffc44d947b9b068
> Author: MyungJoo Ham <myungjoo.ham@samsung.com>
> Date:   Wed Aug 17 10:18:34 2011 +0900
>
>     max17042_battery: Bugfix of incorrect voltage register value interpretation
>
>     The calculation had error in getting voltage values from
>     MAX17042 registers. The least bit denotes 78.125uV (625/8).

The multipliers I see in the patch are 83 making the voltages somewhat
high and the low 3 bits are not masked off. I'm probably misreading the code.

>
>     Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>     Signed-off-by: Philip Rakity <prakity@marvell.com>
>     Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>     Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
>
> Thanks,
