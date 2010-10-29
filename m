Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308Ab0J3AnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 20:43:04 -0400
Received: from blade3.isti.cnr.it ([194.119.192.19]:58858 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758951Ab0J3AnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 20:43:01 -0400
X-Greylist: delayed 10153 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2010 20:43:01 EDT
Date: Fri, 29 Oct 2010 23:54:13 +0200
From: Spelic <spelic@shiftmail.org>
Subject: Slow swapping even on fast infiniband
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: spelic@shiftmail.org
Message-id: <4CCB4285.1040501@shiftmail.org>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7bit
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11)
 Gecko/20100713 Thunderbird/3.0.6
X-INSM-ip-source: 151.82.38.89 Auth Done
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all lkml,

I have just set up two servers connected through iSCSI over Infiniband 
(SCST / SRP).

The "target" end exposes a ramdisk over SRP, the "initiator" end uses 
such device as a swap.
(I am trying to aggregate the memory of a few computers in order to 
perform computations not possible with the RAM of one only.)

This remote SRP disk is very fast, around 1 GByte/sec if I write or read 
to it using dd at bs=4K; from the initiator computer. So the IB is not 
the bottleneck.

However if I use such disk as a swap device on the "initiator" computer, 
I seem not able to obtain more than 150MB/sec reads + 150MB/sec writes 
from/to the swap
I can see these figures with iostat and I can roughly confirm them by 
the time it takes for my C++ memory-sweep-test to sweep all the RAM+swap 
for a few rounds.

Why kswapd is so slow?
Is there a way to do faster swapping of pages, such as with some kind of 
readahead or somehow swapping larger chunks together...?

I tweaked lots of settings in /sys/block/sdc/queue/  (scheduler, 
nr_requests, queue_depth), in the /proc/sys/vm/ (dirty_ratio, background 
ratio etc) but 150MB/sec is the most I could obtain.
Remember that this disk performs almost 1GB/sec in write and read tests 
with dd bs=4K. (The srp disk is being used as full device: no 
partitions, no LVM, no RAID.)
Will linux never be able to swap faster than this?

My kernel is 2.6.32 with just a few patches from the scst people.

Thanks for your help
Spelic
PS: please possibly keep me in CC if you reply because I am not 
subscribed to lkml. Ok I will also check via web. Thank you
