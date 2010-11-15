Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab0KOSi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:38:27 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:33665 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757885Ab0KOSi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:38:26 -0500
X-ASG-Debug-ID: 1289846304-08b796290001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CE17E1B.7000307@fusionio.com>
Date: Mon, 15 Nov 2010 19:38:19 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Nauman Rafique <nauman@google.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [RFC] blk-cgroup: Allow creation of hierarchical cgroups
References: <20101102222030.GI7198@redhat.com> <20101115152832.GH30792@redhat.com>
X-ASG-Orig-Subj: Re: [RFC] blk-cgroup: Allow creation of hierarchical cgroups
In-Reply-To: <20101115152832.GH30792@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1289846304
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.46721
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-15 16:28, Vivek Goyal wrote:
> On Tue, Nov 02, 2010 at 06:20:30PM -0400, Vivek Goyal wrote:
>> o Allow hierarchical cgroup creation for blkio controller
>>
>> o Currently we disallow it as both the io controller policies (throttling
>>   as well as proportion bandwidth) do not support hierarhical accounting
>>   and control. But the flip side is that blkio controller can not be used with
>>   libvirt as libvirt creates a cgroup hierarchy deeper than 1 level.
>>
>>   <top-level-cgroup-dir>/<controller>/libvirt/qemu/<virtual-machine-groups>
>>
>> o So this patch will allow creation of cgroup hierarhcy but at the backend
>>   everything will be treated as flat. So if somebody created a an hierarchy
>>   like as follows.
>>
>> 			root	
>> 			/  \
>> 		     test1 test2
>> 			|
>> 		     test3
>>
>>   CFQ and throttling will practically treat all groups at same level.
>> 			
>> 				pivot
>> 			     /  |   \  \
>> 			root  test1 test2  test3
>>
>> o Once we have actual support for hierarchical accounting and control
>>   then we can introduce another cgroup tunable file "blkio.use_hierarchy"
>>   which will be 0 by default but if user wants to enforce hierarhical
>>   control then it can be set to 1. This way there should not be any
>>   ABI problems down the line.
>>
>> o The only not so pretty part is introduction of extra file "use_hierarchy"
>>   down the line. Kame-san had mentioned that hierarhical accounting is
>>   expensive in memory controller hence they keep it off by default. I
>>   suspect same will be the case for IO controller also as for each IO
>>   completion we shall have to account IO through hierarchy up to the root..
>>   if yes, then it probably is not a very bad idea to introduce this extra
>>   file so that it will be used only when somebody needs it and some people
>>   might enable hierarchy only in part of the hierarchy. 
>>
>> o This is how basically memory controller also uses "use_hierarhcy" and
>>   they also allowed creation of hierarchies when actual backend support
>>   was not available.
>>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> ---
> 
> Hi Jens,
> 
> Do you have any concerns about this patch? If not, can you please apply
> it.

Applied to for-2.6.38/rc2-holder, it'll be merged into for-2.6.38/core
once -rc2 has been tagged (and I can pull in the conflicting bits).

-- 
Jens Axboe

