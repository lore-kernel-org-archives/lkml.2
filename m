Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1KPTFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:05:44 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:32822 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1KPTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:05:42 -0500
Message-ID: <4EC40980.90207@linux.vnet.ibm.com>
Date: Thu, 17 Nov 2011 00:35:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, lenb@kernel.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] PM/Memory-hotplug: Avoid task freezing failures
References: <20111116115515.25945.35368.stgit@srivatsabhat.in.ibm.com> <20111116162601.GB18919@google.com> <4EC3F146.7050801@linux.vnet.ibm.com> <20111116174302.GD18919@google.com> <4EC3FFC4.2010904@linux.vnet.ibm.com> <20111116184157.GA25497@google.com>
In-Reply-To: <20111116184157.GA25497@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11111619-2000-0000-0000-0000015200D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 12:11 AM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 16, 2011 at 11:54:04PM +0530, Srivatsa S. Bhat wrote:
>> Ok, so by "proper solution", are you referring to a totally different
>> method (than grabbing pm_mutex) to implement mutual exclusion between
>> subsystems and suspend/hibernation, something like the suspend blockers
>> stuff and friends?
>> Or are you hinting at just the existing code itself being fixed more
>> properly than what this patch does, to avoid having side effects like
>> you pointed out?
> 
> Oh, nothing fancy.  Just something w/o busy looping would be fine.
> The stinking thing is we don't have mutex_lock_freezable().  Lack of
> proper freezable interface seems to be a continuing problem and I'm
> not sure what the proper solution should be at this point.  Maybe we
> should promote freezable to a proper task state.  Maybe freezable
> kthread is a bad idea to begin with.  Maybe instead of removing
> freezable_with_signal() we should make that default, that way,
> freezable can hitch on the pending signal handling (this creates
> another set of problems tho - ie. who's responsible for clearing
> TIF_SIGPENDING?).  I don't know.
> 

Thanks a lot for the explanation! I now get an idea about your thoughts
on the fundamental issues with the freezer that are causing a broad range
of problems... Hmm, definitely something to ponder over...

> Maybe just throw in msleep(10) there with fat ugly comment explaining
> why the hack is necessary?
> 

Hehe, that surely sounds like the simplest of all the approaches you
suggested ;-) I'll add this to the while loop in the patch and repost
it, hoping we can solve the fundamental issues effectively at a later time.

Thanks,
Srivatsa S. Bhat

