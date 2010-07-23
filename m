Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0GWLNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:13:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:34265 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab0GWLNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:13:40 -0400
Message-ID: <4C49794F.6010400@kernel.org>
Date: Fri, 23 Jul 2010 13:13:19 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, airlied@linux.ie, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 5/7] gfs2: use workqueue instead of slow-work
References: <1279658102-20069-1-git-send-email-tj@kernel.org>	 <1279658102-20069-6-git-send-email-tj@kernel.org> <1279880457.2465.15.camel@localhost>
In-Reply-To: <1279880457.2465.15.camel@localhost>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Jul 2010 11:13:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 12:20 PM, Steven Whitehouse wrote:
> Hi,
> 
> On Tue, 2010-07-20 at 22:35 +0200, Tejun Heo wrote:
>> Workqueue can now handle high concurrency.  Convert gfs to use
>> workqueue instead of slow-work.
>>
>> * Steven pointed out that recovery path might be run from allocation
>>   path and thus requires forward progress guarantee without memory
>>   allocation.  Create and use gfs_recovery_wq with rescuer.  Please
>>   note that forward progress wasn't guaranteed with slow-work.
>>
>> * Updated to use non-reentrant workqueue.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Acked-by: Steven Whitehouse <swhiteho@redhat.com>
> 
> I'm assuming that you'll push this along with the workqueue changes?
> Probably easier than pushing it through my tree,

Yeah, I'll route this through the wq tree with all other workqueue
related changes.

Thank you.

-- 
tejun
