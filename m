Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1EPBJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 21:09:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:60053 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab1EPBJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 21:09:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,371,1301900400"; 
   d="scan'208";a="2053077"
Message-ID: <4DD07959.4030608@intel.com>
Date: Mon, 16 May 2011 09:09:45 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Iceowl/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>	<4DCD4B85.3040702@gmail.com>	<BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com>	<4DCE3493.4090404@gmail.com> <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com> <4DCF7413.4070704@gmail.com>
In-Reply-To: <4DCF7413.4070704@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2011 02:34 PM, Cyrill Gorcunov wrote:
> On 05/15/2011 04:06 AM, huang ying wrote:
> ...
>>>
>>> yes, is not good. But at least we *must* provide a way to turn this new feature off
>>> via command line I think. One of a reason for me is perf unknown nmis (at moment we seems
>>> to have captured and cured all parasite NMIs sources but there is no guarantee we wont
>>> meet them in future due to some code change or whatever). And bloating trap.c with
>>> new if()'s is not that good I guess, that is why I asked if there a way to do all the
>>> work via notifiers ;)
>>
>> Yes.  We should consider about perf unknown NMI issues.  But compared
>> with pushing all magic to user, I think the better way is to have a
>> better default behavior in kernel.  For example, we can turn off
>> unknown NMI as hwerr logic temporarily if there are more than 1 perf
>> NMI events in action.  Is that reasonable?
> 
>   I'm personally fine even if it's enabled by default, only worried to have
> an option to disable hwerr from boot line.

The white list mechanism is not sufficient?  Spurious unknown NMI can
occur on white list machines?  People don't want to protect their data?

>> And, I am not a big fan of notifiers, that makes code hard to be
>> understood.  If you have concerns about the size of traps.c, we can
>> move all NMI logic to a new file.
> 
>   Ying, the concern is rather related to the code scheme in general. Since
> we have notifiers I think the better way to be consistent here and use
> hwerr notifier too. But it's IMHO ;)

As for go notifiers or not.  IMHO, a rule can be:

- If it is something like a driver, than it should go notifier
- If it is architectural/PC defacto standard, it can sit outside of
notifier.

I think that seeing unknown NMI as hardware error should be part of PC
defacto standard.  Do you think so?

Best Regards,
Huang Ying
