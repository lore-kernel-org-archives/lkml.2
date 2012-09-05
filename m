Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab2IEBqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 21:46:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26247 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758028Ab2IEBqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 21:46:38 -0400
X-IronPort-AV: E=Sophos;i="4.80,371,1344182400"; 
   d="scan'208";a="5784273"
Message-ID: <5046AF68.1060900@cn.fujitsu.com>
Date: Wed, 05 Sep 2012 09:48:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10 V4] workqueue: merge the role of rebind_hold to
 idle_done
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com> <1346516916-1991-11-git-send-email-laijs@cn.fujitsu.com> <20120905011516.GD2836@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120905011516.GD2836@dhcp-172-17-108-109.mtv.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 09:46:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 09:46:15,
	Serialize complete at 2012/09/05 09:46:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 09:15 AM, Tejun Heo wrote:
> On Sun, Sep 02, 2012 at 12:28:28AM +0800, Lai Jiangshan wrote:
>> Currently is single pass, we can wait on idle_done instead wait on rebind_hold.
>> So we can remove rebind_hold and make the code simpler.
> 
> As I wrote before, in general, I do like this approach; however, the
> implementation in this series seems to make the code longer, which
> kinda defeats its purpose of simplifying the implementation.  It could
> be because the series is mixing fixes with restructuring.  

> Can you
> please re-spin the restructuring part once fixes are settled?  Let's
> see if that actually makes things simpler.

OK for me.

Patch 5:  -4
Patch 6:  -9		Patch 5,6 simplify idle rebind(benefit from Patch 2)
Patch 7:  +31
Patch 8:  +14		Patch 7,8 make busy worker wait idle worker's rebinding
Patch 9:  -7
Patch 10: -13		Patch 9,10 single pass

total:  +11		single pass allows us clean up more, example narrow the critical
			critical section of manage_mutex. I will add it in next round.

thank,
Lai

> 
> Thanks!
> 

