Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab2KNC7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:59:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:26116 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426Ab2KNC7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:59:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,247,1352102400"; 
   d="scan'208";a="246658915"
Message-ID: <50A308FA.40001@linux.intel.com>
Date: Tue, 13 Nov 2012 18:59:06 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com> <1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com> <20121113211602.GA30150@linux.vnet.ibm.com> <20121113133922.47144a50@chromoly> <20121113222350.GH2489@linux.vnet.ibm.com> <50A2CD77.7000403@linux.intel.com> <20121114000259.GK2489@linux.vnet.ibm.com> <50A2E116.8000400@linux.intel.com> <20121113171450.3657290c@chromoly> <20121114013459.GS2489@linux.vnet.ibm.com>
In-Reply-To: <20121114013459.GS2489@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 5:34 PM, Paul E. McKenney wrote:
> On Tue, Nov 13, 2012 at 05:14:50PM -0800, Jacob Pan wrote:
>> On Tue, 13 Nov 2012 16:08:54 -0800
>> Arjan van de Ven <arjan@linux.intel.com> wrote:
>>
>>>> I think I know, but I feel the need to ask anyway.  Why not tell
>>>> RCU about the clamping?  
>>>
>>> I don't mind telling RCU, but what cannot happen is a bunch of CPU
>>> time suddenly getting used (since that is the opposite of what is
>>> needed at the specific point in time of going idle)
> 
> Another round of RCU_FAST_NO_HZ rework, you are asking for?  ;-)

well
we can tell you we're about to mwait
and we can tell you when we're done being idle.
you could just do the actual work at that point, we don't care anymore ;-)
just at the start of the mandated idle period we can't afford to have more
jitter than we already have (which is more than I'd like, but it's manageable.
More jitter means more performance hit, since during the time of the jitter, some cpus
are forced idle, e.g. costing performance, without the actual big-step power savings
kicking in yet....)

> If you are only having the system take 6-millisecond "vacations", probably

it's not all that different from running a while (1) loop for 6 msec inside
a kernel thread.... other than the power level of course...

