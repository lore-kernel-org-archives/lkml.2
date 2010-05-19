Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0ESTAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:00:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34948 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0ESTAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:00:23 -0400
Message-ID: <4BF43535.3090908@ti.com>
Date: Wed, 19 May 2010 14:00:05 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Mike Chan <mike@android.com>, Kevin Hilman <khilman@deeprootsystems.com>
CC: Thomas Renninger <trenn@suse.de>, "menage@google.com" <menage@google.com>,
       "balbir@in.ibm.com" <balbir@in.ibm.com>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 4/4] omap: cpu: Power tracking support for cgroup cpuacct
References: <1274232620-23003-1-git-send-email-mike@android.com>	 <1274232620-23003-5-git-send-email-mike@android.com>	 <4BF3E367.5080906@ti.com> <201005191734.27887.trenn@suse.de> <AANLkTikcBxjyOMtdt60Kov9kpD-rscC_1aOJ2ueHD5qD@mail.gmail.com>
In-Reply-To: <AANLkTikcBxjyOMtdt60Kov9kpD-rscC_1aOJ2ueHD5qD@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Chan had written, on 05/19/2010 01:56 PM, the following:
> On Wed, May 19, 2010 at 8:34 AM, Thomas Renninger <trenn@suse.de> wrote:
>> On Wednesday 19 May 2010 15:11:03 Nishanth Menon wrote:
>>> Mike Chan had written, on 05/18/2010 08:30 PM, the following:
>>>> Specify new power field in struct omap_opp, which is
>>>> power exported in milliWatt.
>> ...
>>>> +           totalpower += cpuacct_freq[i] * mpu_opps[i + 1].power;
>> ...
>>>> +   unsigned long power; /* power consumed running at OPP in
>> milliWatts */
>>> this conflicts with the OPP layer implementation. this structure will
>>> disappear for good.
> 
> Okay, I wasn't sure what to use. The omap-pm branch uses omap_opp for
> the mpu frequencies. However it looks like struct prcm_config is used
> in linux-next for mpu frequencies, but there are deprecated comments
> around this struct definition so I'm not sure where what struct I
> should be using.

Kevin can probably comment on opp upstream plans.

> 
>> Ah yes, another question:
>> The power variable in struct omap_opp never gets initialized
>> with a sane value, something is wrong...
>>
> 
> You're right, this last patch won't work on linux-next, it seems quite
> a bit has changed in the omap specific. Previously board files can
> register their OPP table which is an array of struct omp_opp, which is
> exactly what I do for Droid in our android-omap branch.
> 
> I'm hoping some omap folks can offer some suggestions for what needs
> to be changed.
> 
> -- Mike
> 
>>     Thomas
>>


-- 
Regards,
Nishanth Menon
