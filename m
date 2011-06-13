Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1FMBes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 21:34:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:30964 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab1FMBeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 21:34:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,356,1304319600"; 
   d="scan'208";a="15442200"
Message-ID: <4DF56934.9000705@intel.com>
Date: Mon, 13 Jun 2011 09:34:44 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Andi Kleen <ak@linux.intel.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
References: <4DCF7413.4070704@gmail.com> <4DD07959.4030608@intel.com> <20110516190310.GH31888@redhat.com> <4DD20A2F.604@intel.com> <20110517142427.GL31888@redhat.com> <20110517163847.GF24805@tassilo.jf.intel.com> <20110517175707.GP31888@redhat.com> <20110517181859.GA25937@tassilo.jf.intel.com> <20110517190738.GH29881@redhat.com> <4DD622A5.9030902@intel.com> <20110609120928.GR8162@redhat.com>
In-Reply-To: <20110609120928.GR8162@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 08:09 PM, Don Zickus wrote:
> On Fri, May 20, 2011 at 04:13:25PM +0800, Huang Ying wrote:
>> Hi, Don,
>>
>> On 05/18/2011 03:07 AM, Don Zickus wrote:
>>> On Tue, May 17, 2011 at 11:18:59AM -0700, Andi Kleen wrote:
>>>>> Random thought, in the Firmware first mode of HEST (which is the only way
>>>>> GHES records get produced??), does an SCI happen first to jump into the
>>>>> firmware for processing, then an NMI?
>>>>
>>>> Either that or there is a separate service processor which handles it.
>>>> Presumably it depends a lot on the particular system.
>>>
>>> Ah interesting.  I was going to suggest somehow setting a bit when an SCI
>>> comes in and check that bit in the unknown NMI path as a possible hint
>>> that the NMI might be related to HEST (sorta how we flag unknown NMIs in
>>> the perf code).
>>>
>>> It was just an idea.  Obviously a service processor will make that more
>>> difficult. :-)
>>
>> Hmm, what's the conclusion?  Do you think unknown NMI should be seen as
>> hardware error?  At least on some white listed machines?
> 
> I still sorta have the opinion that a hardware error should be able be
> recognizable either through a GHES record or a bit in the southbridge.
> Whereas an unknown NMI is something lost and has no owner as the result of
> either a buggy NMI handler or an unimplemented NMI handler.
> 
> Yeah, I can see hardware errors coming in through an unknown NMI but to me
> (from what I am reading about with APEI/GHES) is those should be trapped
> by the firmware and if they aren't then the firmware is broken.  In those
> cases it should be up to the OEM to provide proper firmware (even certify
> them) to allow the proper experience, which includes being properly
> trapped by an NMI handler.
> 
> Perhaps I am a bit naive in my belief but I am a little nervous panicing
> all the time on unknown NMIs when we are still chasing missed perf NMIs on
> a loaded box.

I think things SHOULD go this way too.  This just is not the reality.

Best Regards,
Huang Ying
