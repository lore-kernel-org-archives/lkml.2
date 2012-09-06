Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab2IFBCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:02:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1770 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760134Ab2IFBCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:02:23 -0400
X-IronPort-AV: E=Sophos;i="4.80,377,1344182400"; 
   d="scan'208";a="5791085"
Message-ID: <5047F686.5010207@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 09:04:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11 V5] workqueue: Add @bind arguement back without
 change any thing
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com> <1346841475-4422-6-git-send-email-laijs@cn.fujitsu.com> <20120905194908.GC13737@google.com>
In-Reply-To: <20120905194908.GC13737@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 09:01:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 09:01:56,
	Serialize complete at 2012/09/06 09:01:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 03:49 AM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 05, 2012 at 06:37:42PM +0800, Lai Jiangshan wrote:
>> Ensure the gcwq->flags is only accessed with gcwq->lock held.
>> And make the code more easier to understand.
>>
>> In all current callsite of create_worker(), DISASSOCIATED can't
>> be flipped while create_worker().
>> So the whole behavior is unchanged with this patch.
> 
> This doesn't change anything.  You're just moving the test to the
> caller with comments there explaining how it won't change even if
> gcwq->lock is released.  It seems more confusing to me.  The flag is
> still protected by manager_mutex.  How is this an improvement?
> 

Some other bit of gcwq->flags is accessed(modified) without manager_mutex.
making gcwq->flags be accessed only form gcwq->lock C.S. will help the reviewer.

I don't like adding special things/code when not-absolutely-required.

