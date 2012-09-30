Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab2I3LoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 07:44:18 -0400
Received: from smtp.getmail.no ([84.208.15.66]:44322 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab2I3LoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 07:44:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org
Subject: The 10ms averager in fair.c
Date: Sun, 30 Sep 2012 13:44:14 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wlf5j0i76426ze@localhost.localdomain>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiya. I just had an initial look at fair.c

There seems to be a 10ms averager in there?

You are aware that that means you work on delayed values?

Isn`t that counterintuitive to the principle of sharing?

That means short bursts of cpu-use will be filtered out, and given less  
cpu time.
Starting applications won`t have their cpu-usage before 5ms, which is  
quite a bit on modern machines. Well if you use a linearphase filter, I  
don`t know what kind of averager you use. The best would ofcourse be to  
use a minimalphase gaussian averager. Which might be overkill. Atleast a  
one-pole iir, buf = buf + (-buf + in) * cut)); One pole IIRs also have a  
better frequency response.

When you are working with low-latencies, wouldn`t it be better if such  
things are tuned for target latency. I think few care about latency after  
0.2ms. So say the filter should be set to 0.4ms max.

Why would you want to filter cpu-usage also really?

Peace Be With You.

(please CC me.)
