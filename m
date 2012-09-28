Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab2I1IEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:04:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:22333 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab2I1IEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:04:33 -0400
X-IronPort-AV: E=Sophos;i="4.80,501,1344182400"; 
   d="scan'208";a="5933383"
Message-ID: <50655A98.3090507@cn.fujitsu.com>
Date: Fri, 28 Sep 2012 16:06:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 11/12] workqueue: add WQ_CPU_INTENSIVE to system_long_wq
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com> <1348680043-5077-12-git-send-email-laijs@cn.fujitsu.com> <20120926183833.GI12544@google.com>
In-Reply-To: <20120926183833.GI12544@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 16:04:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 16:04:42,
	Serialize complete at 2012/09/28 16:04:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Tejun

On 09/27/2012 02:38 AM, Tejun Heo wrote:
> On Thu, Sep 27, 2012 at 01:20:42AM +0800, Lai Jiangshan wrote:
>> works in system_long_wq will be running long.
>> add WQ_CPU_INTENSIVE to system_long_wq to avoid these kinds of works occupy
>> the running wokers which delay the normal works.
>>
>> if system_long_wq is designed for only sleep-long works, not running-long works,
>> this patch makes no sense.
> 
> There "long" doesn't mean it's gonna consume a lot of CPU cycles, so
> it should contribute to concurrency management.  The plan is to remove
> system_long_wq once we got rid of flushing of system_wq via
> flush_scheduled_work() and directly through flush_workqueue().  I
> think we're pretty close, so let's not add more usage of it.
> 

OK.

But does we need a stand-alone workqueue for work_on_cpu() as it is original
introduced? (2d3854a3)

Thanks,
Lai
