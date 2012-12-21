Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2LUW5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:57:08 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:48198 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2LUW5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:57:06 -0500
MIME-Version: 1.0
In-Reply-To: <50D2A7DA.5050907@nvidia.com>
References: <1355370586-6600-1-git-send-email-pgaikwad@nvidia.com>
 <CAPtuhThBigSQMkNDf16Fo1tddTKo=rPEydHmzep0DqtgLrB+HA@mail.gmail.com>
 <50CA17FB.9060606@wwwdotorg.org> <50D2A7DA.5050907@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Fri, 21 Dec 2012 16:56:44 -0600
Message-ID: <CAPtuhTgytOHGpVQ+vXQMpgFhuUo+y0H-QqpLg5cff2cdC-Rkzg@mail.gmail.com>
Subject: Re: [PATCH] clk: debug clock tree
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 11:53 PM, Prashant Gaikwad <pgaikwad@nvidia.com> wrote:
> On Thursday 13 December 2012 11:31 PM, Stephen Warren wrote:
>>
>> On 12/13/2012 09:27 AM, Mike Turquette wrote:
>>>
>>> On Wed, Dec 12, 2012 at 7:49 PM, Prashant Gaikwad <pgaikwad@nvidia.com>
>>> wrote:
>>>>
>>>> Adds debug file "clock_tree" in /sys/kernel/debug/clk dir.
>>>> It helps to view all the clock registered in tree format.
>>>>
>>> Prashant,
>>>
>>> Thanks for submitting this.  We've been talking about having a single
>>> file for representing the tree for some time.
>>>
>>> Regarding the output format had you considered using a well known
>>> format which can be parsed using well known parsing libs?  This avoids
>>> needing a custom parser just for this one file.  JSON springs to mind
>>> as something lightweight and well-understood.
>>
>> One advantage of the format below is that it's very easily
>> human-readable, and it's not too hard to parse (although I guess you'd
>> have to parse the indent level to get parent/child relation, which would
>> suck a bit). Is there room to provide both? Otherwise, I guess the
>> kernel could include a script to convert from JSON/whatever into the
>> format below.
>>
>>>> For example:
>>>>     clock                        enable_cnt  prepare_cnt  rate
>>>> ---------------------------------------------------------------------
>>>>   i2s0_sync                      0           0            24000000
>>>>   spdif_in_sync                  0           0            24000000
>>>>      spdif_mux                   0           0            24000000
>>>>         spdif                    0           0            24000000
>>>>            spdif_doubler         0           0            48000000
>>>>               spdif_div          0           0            48000000
>>>>                  spdif_2x        0           0            48000000
>>
>>
>
> Even I think that output must be easily human-readable. How about adding
> sysfs to switch between human-readable and machine-readable format?
> I will try come up with a implementation.
>

Do you mean a sysfs file which controls the output format?  How about
just two different files?  One can be clk-dump (machine readable) and
the other is clk-summary (human readable).

Regards,
Mike
