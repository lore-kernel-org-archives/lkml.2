Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab1LER4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:56:33 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:59440 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab1LER4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:56:32 -0500
Message-ID: <4EDD05C6.8080809@linux.vnet.ibm.com>
Date: Mon, 05 Dec 2011 23:26:22 +0530
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
References: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com> <20111204200332.25620.53610.stgit@srivatsabhat.in.ibm.com> <20111205171508.GC627@google.com> <4EDD019E.9010009@linux.vnet.ibm.com> <20111205174349.GG627@google.com>
In-Reply-To: <20111205174349.GG627@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120517-8256-0000-0000-00000063B328
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 11:13 PM, Tejun Heo wrote:

> Hello,
> 
> On Mon, Dec 05, 2011 at 11:08:38PM +0530, Srivatsa S. Bhat wrote:
>> Sorry, I didn't get what you meant here. Are you talking about what
>> needs to be added/changed in the documentation or, are you referring
>> to the code itself and are saying that we must make these APIs
>> internal to the PM alone?
> 
> Ooh, sorry about not being clear.  I meant pm_mutex itself.  There's
> no reason to expose that outside of pm, right?  And in the
> documentation, we can just require use of the APIs instead of pm_mutex
> itself.
> 


Yes, that sounds good. No need for giving unnecessary choices :-)
But I had worded the documentation that way with the intention of
explaining why calling mutex_lock() over pm_mutex can be disastrous (which
I mentioned in the commit message as one of the goals of the patch).
I didn't mean it to give the user 2 choices and say please use
[un]lock_system_sleep() preferably.

Although, we have to notice that unless somebody is acquainted with
these APIs, the first instinct would probably be to directly use
mutex_lock(), until they look up the documentation (hopefully).
So, IMHO, it would do good to keep the explanation in the docs as
it is, in this patch. What do you think?

Regards,
Srivatsa S. Bhat

