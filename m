Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2IQSQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:16:36 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:36638 "EHLO
	Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab2IQSQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:16:35 -0400
X-Greylist: delayed 951 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 14:16:35 EDT
Message-ID: <5057654A.803@tlinx.org>
Date: Mon, 17 Sep 2012 11:00:42 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Gecko/20100228 Lightning/0.9 Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: 2 physical-cpu (like 2x6core) config and NUMA?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was wondering, on dual processor MB's, Intel uses dedicated memory for

each cpu ....  6 memchips in the X5XXX series, and to access the memory
of the other chip's cores, the memory has to be transferred over the QPI
bus.

So wouldn't it be of benefit if such dual chip configurations were to
be setup as 'NUMA', as there is a higher cost between migrating 
memory/processes
between Cores on different chips vs. on the same chip?  

I note from 'cpupower -c all frequency-info, that the "odd" cpu-cores
all hve to run at the same clock frequency, and the "even" all have
to run together, which I take to mean that the odd number cores are
on 1 chip and the even numbered cores are on the other chip.

Since the QPI path is limited and appears to be < the local memory access
rate, wouldn't it be appropriate if 2 cpu-chip setups were configured
as 2 NUMA cores?  

Although -- I have no clue how the memory space is divided between the
two cores -- i.e. I don't know if say, I have 24G on each, if they
alternate 4G in the physical address space or what (that would all be
handed (or mapped) before the chips come up.. so it could be contiguous).


Does the kernel support scheduling based on the different speed of
memory between "on die" vs. "off die"?   I was surprised to see
that it viewed my system as 1 NUMA node with all 12 on 1 node -- when
I know that it is physically organized as 2x6. 

Do I have to configure that manually or did I maybe turn off something
in my kernel config I should have turned on?

(HW= 2 X5560 @ 2.8GHZ w/6 cores/siblings/chip...

And most certainly, 6 cores would share a 12MB L3 cache as
well, that wouldn't be "hot" for the other 6 cores.

Any suggestions would be appreciated.

Thanks,
Linda





