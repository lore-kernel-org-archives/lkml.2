Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab1LERiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:38:50 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:54378 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab1LERis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:38:48 -0500
Message-ID: <4EDD019E.9010009@linux.vnet.ibm.com>
Date: Mon, 05 Dec 2011 23:08:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, ebiederm@xmission.com,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/3] PM / Docs: Recommend the use of [un]lock_system_sleep()
 over mutex_[un]lock(&pm_mutex)
References: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com> <20111204200332.25620.53610.stgit@srivatsabhat.in.ibm.com> <20111205171508.GC627@google.com>
In-Reply-To: <20111205171508.GC627@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120517-8878-0000-0000-0000007780B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 10:45 PM, Tejun Heo wrote:

> Hello,
> 
> On Mon, Dec 05, 2011 at 01:33:42AM +0530, Srivatsa S. Bhat wrote:
>> Update the documentation to explain the perils of directly using
>> mutex_[un]lock(&pm_mutex) and recommend the usage of the safe
>> APIs [un]lock_system_sleep() instead.
> 
> Maybe just make it pm internal?
> 


Sorry, I didn't get what you meant here. Are you talking about what
needs to be added/changed in the documentation or, are you referring
to the code itself and are saying that we must make these APIs
internal to the PM alone?

If it is the latter, please note that memory hotplug is one of the
outside-of-PM user of these APIs, and hence we really can't make
these APIs internal to the PM alone without substantially needing to
change the memory hotplug code to mutually exclude itself from PM
somehow without using these APIs.
And moreover, since these APIs avoid task freezing failures when
some out-of-PM user like memory hotplug code uses them, I don't see
much benefit by making them internal to the PM. IOW, I don't see
much use left of them, if we do that.

IMHO, we should leave these APIs as they are, until we have a better
solution for out-of-PM users to mutex themselves from PM. (For one,
currently it is not always possible to hook onto PM notifiers to
achieve that, in which case these APIs will come in handy, and these
aren't that ugly anyway, so no harm using them when necessary.)

Regards,
Srivatsa S. Bhat

