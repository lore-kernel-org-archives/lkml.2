Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2FSBjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:39:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:53648 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab2FSBjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:39:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="155156185"
Message-ID: <4FDFD866.4080602@intel.com>
Date: Tue, 19 Jun 2012 09:39:50 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 06/13] perf: Add Nehalem and Sandy Bridge uncore support
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com> <1339741902-8449-7-git-send-email-zheng.z.yan@intel.com> <1339780730.2559.92.camel@twins> <CABPqkBTuBnFWo0wpcmg_YR_C0Q_BAMBqs7nrFTHnag=_RMPddA@mail.gmail.com> <1339850780.15222.8.camel@twins> <CABPqkBQYRs9F2U3LVWcxip3-2ijxAE8+szj2TY8MKwO2w7se1A@mail.gmail.com>
In-Reply-To: <CABPqkBQYRs9F2U3LVWcxip3-2ijxAE8+szj2TY8MKwO2w7se1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 05:23 PM, Stephane Eranian wrote:
> On Sat, Jun 16, 2012 at 2:46 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> >
>> > On Fri, 2012-06-15 at 20:46 +0200, Stephane Eranian wrote:
>>> > > Yes, and let the parser be case insensitive.
>> >
>> > Right, I did the below on top..
>> >
>> > ---
>> > --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> > +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> > @@ -179,22 +179,17 @@ static struct attribute *snbep_uncore_pc
>> >  };
>> >
>> >  static struct uncore_event_desc snbep_uncore_imc_events[] = {
>> > -       INTEL_UNCORE_EVENT_DESC(CLOCKTICKS, "config=0xffff"),
>> > -       /* read */
>> > -       INTEL_UNCORE_EVENT_DESC(CAS_COUNT_RD, "event=0x4,umask=0x3"),
>> > -       /* write */
>> > -       INTEL_UNCORE_EVENT_DESC(CAS_COUNT_WR, "event=0x4,umask=0xc"),
>> > +       INTEL_UNCORE_EVENT_DESC(clockticks,      "event=0xff,umask=0xff");
> Just like for core, I would pick 0xff as the pseudo event code for
> fixed uncore events
> and use the umask value to determine which of the fixed events we want
> to map to. There
> is only one fixed counter so far. But more could be added later on, so
> why not start with
> umask=0x00 or umask=0x1 instead of umask=0xff?
> 

Good idea. I think changing the definition of UNCORE_FIXED_EVENT to 0xff and
changing configure for the clockticks events to config=0xff are enough for now.

Regards
Yan, Zheng
