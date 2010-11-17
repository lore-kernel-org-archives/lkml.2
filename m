Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625Ab0KQI0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:26:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57900 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933434Ab0KQI0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:26:51 -0500
Message-ID: <4CE3931D.1000403@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 16:32:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pete@jasper.es
Subject: Re: [PATCH v3 0/7] CFS Bandwidth Control
References: <20101012074910.GA9893@in.ibm.com>
In-Reply-To: <20101012074910.GA9893@in.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 16:27:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 16:27:12,
	Serialize complete at 2010-11-17 16:27:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 03:49 PM, Bharata B Rao wrote:
> Hi,
> 
> Its been a while since we posted CPS hard limits (aka CFS bandwidth control
> now) patches, hence a quick recap first:
> 
> - I have been working on CFS hard limits since last year and have posted
>   a few versions of the same (last post: http://lkml.org/lkml/2010/1/5/44)
> - Paul Turner and Nikhil Rao meanwhile started working on CFS bandwidth
>   control and have posted a couple of versions.
>   (last post v2: http://lwn.net/Articles/385055/)
> 

Hi, All

	I tried it, it works very good! It adds a very useful feature.
It is very helpful for virtualization or cloud-computing I think.
I hope the next version patchset of it will be sent and get merged soon.

When I tested it, my box became dead several times, infrequently, and
I don't know how to reproduce it, but next steps may help to reproduce it:

# mount -t cgroup -o cpu xxx /mnt
# cd /mnt
# mkdir test
# cd test
# echo 5000000 > cpu.cfs_period_us
# echo 1000000 > cpu.cfs_quota_us
# cat /dev/zero > /dev/null &
# echo $! > tasks
# #make the system busy, browse websites and open many tabs in your browser etc
# #but do NOT do things important.
# #after some time, the system may dead. (can not respond even you type AltSysrqC)

Thank you all
Lai
