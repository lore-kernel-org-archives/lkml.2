Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2I1KJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:09:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3384 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757039Ab2I1KJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:09:09 -0400
X-IronPort-AV: E=Sophos;i="4.80,501,1344182400"; 
   d="scan'208";a="5934500"
Message-ID: <506577CB.1050401@cn.fujitsu.com>
Date: Fri, 28 Sep 2012 18:11:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] workqueue: add WORKER_RESCUER
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com> <1348680043-5077-2-git-send-email-laijs@cn.fujitsu.com> <20120926180711.GB12544@google.com>
In-Reply-To: <20120926180711.GB12544@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 18:09:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 18:09:17,
	Serialize complete at 2012/09/28 18:09:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 02:07 AM, Tejun Heo wrote:
> On Thu, Sep 27, 2012 at 01:20:32AM +0800, Lai Jiangshan wrote:
>> rescuer thread must be a worker which is WORKER_NOT_RUNNING:
>> 	If it is *not* WORKER_NOT_RUNNING, it will increase the nr_running
>> 	and it disables the normal workers wrongly.
>>
>> So rescuer thread must be WORKER_NOT_RUNNING.
>>
>> Currently code implement it by always setting WORKER_PREP on rescuer thread,
>> but this kind of implement is ugly:
>> A)	It reuses WORKER_PREP which is used for a different meaning.
>> B)	It does not told us rescuer thread is WORKER_NOT_RUNNING.
>>
>> So we add WORKER_RESCUER to fix these two sematic.
> 
> Ah, right, we always have WORKER_PREP set for rescuers.  So, this
> doesn't actually change the behavior at all?  

No, this doesn't change the behavior at all.

> I'm not necessarily
> against it but the commit message seems a bit misleading.
> 

I just try my best to say" we need to add WORKER_RESCUER to told us
rescuer is WORKER_NOT_RUNNING explicity, using WORKER_PREP only will
hide this info"

Thanks,
Lai

