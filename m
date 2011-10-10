Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1JJRcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:32:08 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:56792 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1JJRcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:32:05 -0400
Message-ID: <4E932BBA.9090501@linux.vnet.ibm.com>
Date: Mon, 10 Oct 2011 23:00:34 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Alan Stern <stern@rowland.harvard.edu>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "tj@kernel.org" <tj@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
References: <Pine.LNX.4.44L0.1110101119550.18069-100000@netrider.rowland.org> <4E931018.8030904@linux.vnet.ibm.com> <20111010165343.GA29261@aftab>
In-Reply-To: <20111010165343.GA29261@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 10:23 PM, Borislav Petkov wrote:
> On Mon, Oct 10, 2011 at 11:32:40AM -0400, Srivatsa S. Bhat wrote:
>>> The seems like entirely the wrong way to go about solving this problem.
>>>
>>> The kernel shouldn't be responsible for making hotplug stress tests 
>>> exclusive with system sleep.  Whoever is running those tests should be 
>>> smart enough to realize what's wrong if system sleep interferes with a 
>>> test.
> 
> Yes, agreed. And more: I'm still trying to understand why a test case
> like that is relevant and needs to be fixed at all. Let me re-formulate
> the question: what real world scenario(s) does the case of hibernating
> _while_ off- and onlining cores cover? Or are you simply doing kernel
> resiliency testing and thought that offlining cores while hibernating
> might make sense?
> 

Actually, my whole intention while coming up with this test case was to
test the stability/correct operation of the entire suspend/resume call
path. And since I found that cpu hotplug is used in that call path I
thought of giving it a whirl and finding out if there were any cases that
lead to freezing failures and the like. And I did uncover a couple of cases,
one after the other.
But I do agree that offlining and onlining CPUs while suspending might
not seem all that useful or even wise, but like I said, it was designed to
bring out such problematic race conditions.

So, in the interest of making the important components involved in
suspend/resume call path (namely cpu hotplug) more robust and stable,
I think it makes sense to fix any issue we hit (atleast when we
practically hit it and it is proved that such a scenario is no longer
hypothetical).

For that, we can either go with the simple one-line fix that I posted
earlier (which has got another motivation now, thanks to Borislav) or
with this elaborate solution, whichever seems better/worthwhile.

If it is still strongly felt that this "bug" is not worth fixing with such
mutual exclusion schemes, it will still get solved anyway by applying that
one-line patch.

> IOW, I still fail to see a strong reason for this needing fixing.
> 
> Thanks.
> 


-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
