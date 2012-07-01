Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab2GAF1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 01:27:49 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:32819 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2GAF1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 01:27:47 -0400
Message-ID: <4FEFDFB5.9070404@us.ibm.com>
Date: Sat, 30 Jun 2012 22:27:17 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Richard Cochran <richardcochran@gmail.com>,
        Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
References: <4FDB8563.3030805@us.ibm.com> <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk> <20120617164751.GJ12429@burratino> <20120617173456.GA3684@netboy.at.omicron.at> <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk> <1341106098.4852.64.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1341106098.4852.64.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12070105-5930-0000-0000-00000970996D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2012 06:28 PM, Ben Hutchings wrote:
> On Mon, 2012-06-18 at 14:55 +0100, Ben Hutchings wrote:
>> On Sun, 2012-06-17 at 19:34 +0200, Richard Cochran wrote:
>>> On Sun, Jun 17, 2012 at 11:47:51AM -0500, Jonathan Nieder wrote:
>>>> Ben Hutchings wrote:
>>>>> On Fri, 2012-06-15 at 11:56 -0700, John Stultz wrote:
>>>>>> commit dd48d708ff3e917f6d6b6c2b696c3f18c019feed upstream.
>>>> [...]
>>>>> This doesn't apply to 3.2.y, unsurprisingly.  Let me know if there are
>>>>> any urgent leap second fixes that will be needed there.
>>>> 6b43ae8a619d (ntp: Fix leap-second hrtimer livelock) sounds important,
>>>> but the patch depends on bd3312681f69 (ntp: Add ntp_lock to replace
>>>> xtime_locking) which does not have a commit message explaining its
>>>> purpose (and that patch in turn depends on ea7cf49a7633).
>> If I understand the commit message for 6b43ae8a619d correctly, the
>> livelock results from ntp_lock and xtime_lock being acquired in opposite
>> orders in two threads.  Which means it wasn't possible before ntp_lock
>> was introduced in bd3312681f69.
> [...]
>
> Apparently some other livelock was possible, though I was unable to
> reproduce it myself.  Some proportion of systems running 2.6.32 or 3.2
> (not sure about the intermediate stable-supported versions) are reported
> to have locked up, either in adjtimex or during the leap second.

Ugh. That sucks.  Any more details as they come in would be helpful, 
specifically around the exact kernel versions affected.

> I understand that we might not have so long to wait for the next leap
> second, so if anyone understands what fixes are still needed in stable
> updates I would really appreciate that.

Yea. I'm digging now to try to see what could be happening.

thanks
-john

