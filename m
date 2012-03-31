Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2CaM4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:56:51 -0400
Received: from szxga04-in.huawei.com ([58.251.152.67]:45041 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752695Ab2CaM4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:56:45 -0400
Date: Sat, 31 Mar 2012 20:56:36 +0800
From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
In-reply-to: <20120330154246.GE28934@google.com>
X-Originating-IP: [10.166.88.150]
To: Tejun Heo <tj@kernel.org>
Cc: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com
Message-id: <4F76FF04.40007@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312
 Thunderbird/11.0
X-CFilter-Loop: Reflected
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
 <4F75AA1F.9020007@huawei.com> <20120330154246.GE28934@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:

> Hey, Li.
> 
> On Fri, Mar 30, 2012 at 08:42:07PM +0800, Li Zefan wrote:
>>> This patch replaces cgroup file interface with cftype based one which
>>> allows dynamic additions and removals of cftype arrays whether the
>>> target subsystem is attached or not.  This can be used to make subsys
>>> rebinding via remount work properly but I intentionally avoided doing
>>> that at the moment.
>>
>> What's the problem with remount?
> 
> Subsys can't be changed if any non-root cgroup exists.
> 


Ah, this is a long-standing defect, which is documented in Doc/../cgroups.txt.
It's not trivial to fix it, and I never heard someone request it to be fixed.

>> and is it important enough that it should be fixed even the feature
>> is marked as deprecated?
> 
> I'm not sure.  We *might* need it during multi-mount -> single-mount
> transition depending on how that's implemented, so the "at the moment"
> qualifier.  It probably won't be fixed but I'm not fully sure.
> 


fine.

>>> This makes cgroup population simpler for controllers and will be used
>>> to allow controllers to be more dynamic.  e.g. blkio subsys has
>>> sub-policies which may come and go while blkio subsys is attached and
>>> it currently uses fixed set of files which stays blank if not in use.
>>
>> Dynamic cgroup files was mentioned before. The scenario in mind was blkio
>> control files can be added/removed automatically as devices come and ago.
>>
>> So this time blkio subsystem is really going to be made more dynamic
>> soon?
> 
> Patchset already posted.
> 
>   http://thread.gmane.org/gmane.linux.kernel.cgroups/1376
> 


Thanks!
