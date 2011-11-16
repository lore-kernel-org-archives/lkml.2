Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab1KPSYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:24:16 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41829 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab1KPSYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:24:14 -0500
Message-ID: <4EC3FFC4.2010904@linux.vnet.ibm.com>
Date: Wed, 16 Nov 2011 23:54:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, lenb@kernel.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] PM/Memory-hotplug: Avoid task freezing failures
References: <20111116115515.25945.35368.stgit@srivatsabhat.in.ibm.com> <20111116162601.GB18919@google.com> <4EC3F146.7050801@linux.vnet.ibm.com> <20111116174302.GD18919@google.com>
In-Reply-To: <20111116174302.GD18919@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11111618-3864-0000-0000-0000001BE324
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 11:13 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 16, 2011 at 10:52:14PM +0530, Srivatsa S. Bhat wrote:
>> So, honestly I didn't understand what is wrong with the approach of this
>> patch. And as a consequence, I don't see why we should wait to fix this
>> issue. 
>>
>> [And by the way recently I happened to see yet another proposed patch
>> trying to make use of this API. So wouldn't it be better to fix this
>> ASAP, especially when we have a fix readily available?]
> 
> It just doesn't look like a proper solution.  Nothing guarantees
> freezing will happen soonish.  Not all pm operations involve freezer.
> The exclusion is against mem hotplug at this point, right?  I don't
> think it's a good idea to add such hack to fix a mostly theoretical
> problem and it's actually quite likely someone would be scratching
> head trying to figure out why the hell the CPU was hot spinning while
> the system is trying to enter one of powersaving mode (we had similar
> behavior in freezer code a while back and it was ugly).
> 
> So, let's either fix it properly or leave it alone.
> 

Ok, so by "proper solution", are you referring to a totally different
method (than grabbing pm_mutex) to implement mutual exclusion between
subsystems and suspend/hibernation, something like the suspend blockers
stuff and friends? 
Or are you hinting at just the existing code itself being fixed more
properly than what this patch does, to avoid having side effects like
you pointed out?

I am just trying to figure out what would be the best way to proceed here.
By the way I consider it lucky that we have spotted this bug before we
actually hit it.. So I would really love to get this fixed before it
comes back to haunt us in the future ;-)

Thanks,
Srivatsa S. Bhat

