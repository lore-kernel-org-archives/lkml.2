Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1KURMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:12:41 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:33217 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab1KURMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:12:40 -0500
Message-ID: <4ECA867D.4050901@linux.vnet.ibm.com>
Date: Mon, 21 Nov 2011 22:42:29 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, lenb@kernel.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] PM/Memory-hotplug: Avoid task freezing failures
References: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com> <201111192257.19763.rjw@sisk.pl> <20111121164758.GC15314@google.com>
In-Reply-To: <20111121164758.GC15314@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112117-5816-0000-0000-000000228C31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 10:17 PM, Tejun Heo wrote:
> Hello, Rafael.
> 
> On Sat, Nov 19, 2011 at 10:57:19PM +0100, Rafael J. Wysocki wrote:
>>> +	while (!mutex_trylock(&pm_mutex)) {
>>> +		try_to_freeze();
>>> +		msleep(10);
>>
>> The number here seems to be somewhat arbitrary.  Is there any reason not to
>> use 100 or any other number?
> 
> This is a bit moot at this point but, at least for me, yeah, it's a
> number I pulled out of my ass.  That said, I think it's a good number
> to pull out of ass for userland visible retry delays for the following
> reasons.
> 
> * It's a good number - 10! which happens to match the number of
>   fingers I have!  Isn't that just weird? @.@
> 
> * For modern hardware of most classes, repeating not-so-complex stuff
>   every 10ms for a while isn't taxing (or even noticeable) at all.
> 
> * Sub 10ms delays usually aren't noticeable to human beings even when
>   several of them are staggered.  This is very different when you get
>   to 100ms range.
> 
> ie. going from 1ms to 10ms doesn't cost you too much in terms of human
> noticeable latency (for this type of situations anyway) but going from
> 10ms to 100ms does.  In terms of computational cost, the reverse is
> somewhat true too.  So, yeah, I think 10ms is a good out-of-ass number
> for this type of delays.
> 

My God! I had absolutely no idea you had cooked up that number just like
that ;-) Look at how creative I was when defending that number :P
Your justification is not bad either ;-)

[ Well, seriously, I had given a fair amount of thought before incorporating
that number in my patch, by looking at the freezer re-try latency and so on,
which I explained in my reply earlier.]

Anyways, nice one :-)

Thanks,
Srivatsa S. Bhat

