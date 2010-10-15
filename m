Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab0JOQjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:39:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:37959 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab0JOQjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:39:42 -0400
Message-ID: <4CB883C9.6050104@kernel.org>
Date: Fri, 15 Oct 2010 18:39:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Linux Wireless List <linux-wireless@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] mac80211: cancel restart_work explicitly
 instead of depending on flush_scheduled_work()
References: <4CB874C0.8090003@kernel.org> <1287159715.1870.11.camel@Nokia-N900-51-1>
In-Reply-To: <1287159715.1870.11.camel@Nokia-N900-51-1>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 16:39:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/15/2010 06:21 PM, Johannes Berg wrote:
>> -        create_singlethread_workqueue(wiphy_name(local->hw.wiphy));
>> +        alloc_ordered_workqueue(wiphy_name(local->hw.wiphy), 0);
> 
> no description for this change?

Oops, right.  create_*workqueue() interfaces are being replaced by
alloc_*workqueue().  It's part of the workqueue interface update.

>> -    /*
>> -     * For key todo, it'll be empty by now but the work
>> -     * might still be scheduled.
>> -     */
>> -    flush_scheduled_work();
> 
> oops, todo work no longer exists...
> 
> Anyway, ACK.

Are you going to route this through wireless tree?  Shall I repost
with update patch description?

Thank you.

-- 
tejun
