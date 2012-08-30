Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2H3ChJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 22:37:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53721 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab2H3ChH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 22:37:07 -0400
X-IronPort-AV: E=Sophos;i="4.80,337,1344182400"; 
   d="scan'208";a="5750390"
Message-ID: <503ED232.3010501@cn.fujitsu.com>
Date: Thu, 30 Aug 2012 10:38:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9 V3] workqueue: add POOL_MANAGING_WORKERS
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com> <1346259120-6216-4-git-send-email-laijs@cn.fujitsu.com> <20120829182102.GA2258@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120829182102.GA2258@dhcp-172-17-108-109.mtv.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 10:36:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 10:36:52,
	Serialize complete at 2012/08/30 10:36:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 02:21 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Thu, Aug 30, 2012 at 12:51:54AM +0800, Lai Jiangshan wrote:
>> When hotplug happens, the plug code will also grab the manager_mutex,
>> it will break too_many_workers()'s assumption, and make too_many_workers()
>> ugly(kick the timer wrongly, no found bug).
>>
>> To avoid assumption-coruption, we add the original POOL_MANAGING_WORKERS back.
> 
> I don't think we're gaining anything with this and I'd like to confine
> management state within the mutex only.  If too_many_workers() firing
> spuriously while CPU up/down is in progress, just add a comment
> explaining why it's a non-problem

OK, I drop this patch, Could you add the comment, I'm not good at English.

> (actual worker management never
> happens while cpu up/down holds manager positions).
> 

I don't agree this claim. It happens "rarely", not "never", otherwise I missed something.


Thanks,
Lai
