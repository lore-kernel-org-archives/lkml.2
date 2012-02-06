Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2BFNNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 08:13:35 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:57215 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab2BFNNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 08:13:33 -0500
Message-ID: <4F2FD1F4.9050702@bootc.net>
Date: Mon, 06 Feb 2012 13:13:24 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
CC: Clemens Ladisch <clemens@ladisch.de>, Boaz Harrosh <bharrosh@panasas.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: FireWire/SBP2 Target mode
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de> <4F29978A.3010707@redhat.com> <20120201224156.0773ebc6@stein> <4F2A55B9.4040005@panasas.com> <4F2A60DC.9030007@ladisch.de>
In-Reply-To: <4F2A60DC.9030007@ladisch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I've been forging ahead in the last few days with my target code and 
have got to a point where it appears to work fairly well and now needs 
some real testing and ideally some initial review.

So far I've tested that I can export LUNs to Linux and Mac OS X machines 
and they can read/write data without issues as you might expect. I've 
even installed Mac OS X onto an exported LUN and booted from it on an 
old PowerBook without issue.

You can pull the code from:
git://github.com/bootc/Linux-SBP-2-Target.git

Or use GitHub to have a look etc...:
https://github.com/bootc/Linux-SBP-2-Target

I used the following script to set up a LUN on the target:

modprobe firewire-sbp-target
mkdir /sys/kernel/config/target/sbp
mkdir /sys/kernel/config/target/sbp/test
mkdir /sys/kernel/config/target/sbp/test/unit_0
mkdir /sys/kernel/config/target/sbp/test/unit_0/lun/lun_0
ln -s /sys/kernel/config/target/core/iblock_0/test 
/sys/kernel/config/target/sbp/test/unit_0/lun/lun_0/test
echo 1 > /sys/kernel/config/target/sbp/test/unit_0/enable

Please note that you can't then disable a unit until all the targets are 
logged-out. For Linux this usually means 'rmmod firewire_sbp2'. This is 
one of the first things I'd like to fix but I'm not entirely sure how to 
go about it yet.

Thanks,
Chris

-- 
Chris Boot
bootc@bootc.net
