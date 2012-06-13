Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2FMN3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:29:35 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47669 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab2FMN3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:29:32 -0400
MIME-Version: 1.0
In-Reply-To: <1339591666.8980.26.camel@twins>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	<1339502524-10265-4-git-send-email-vincent.guittot@linaro.org>
	<CAORVsuWqWt0pJfewymh_ydAH61-uPsO0M7m7Gs4N3zJY=Vo9ZA@mail.gmail.com>
	<CAKfTPtBc-KuDg_1qe04TfYS4+66qQoiHCJQbCF9gnhga5ociow@mail.gmail.com>
	<CAP245DXEOGLe1jq2Wj0rNW5qea63UyJu2jOvwV65Y4B9LLoQtg@mail.gmail.com>
	<1339591666.8980.26.camel@twins>
Date: Wed, 13 Jun 2012 15:29:31 +0200
Message-ID: <CAKfTPtCyV389OTrun5Oyn8RCsDagza95wdmWr=r9poMiYrU0Mg@mail.gmail.com>
Subject: Re: [RFC 3/4] ARM: topology: Update cpu_power according to DT information
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>,
        Jean Pihet <jean.pihet@newoldbits.com>, linux@arm.linux.org.uk,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, linaro-dev@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2012 14:47, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-06-13 at 18:14 +0530, Amit Kucheria wrote:
>> Various discussions around power-aware scheduling have amplified the
>> need for the scheduler to have some knowledge of DVFS. This would then
>> require the scheduler to track 'cpu_power' ( = max power) and perhaps
>> a new variable 'current_power' that is changed by the DVFS framework.
>
> Note that capacity is in fact a better term -- not to be confused with
> the capacity as currently in use within the load-balancer. Luckily
> there's no way to read that an not be confused.. uhmm :-)
>>
>> The first goal, though, is to make sure that the scheduler can handle
>> different cpu_power values due to asymmetric cores.
>
> I would think the very first goal was to do a simple packing balancer
> before doing silly things with asymmetric setups.. but what do I know.

In fact, there is 2 tracks, one for a power aware scheduler and one
for setting the capacity of each core of a big.LITTLE system. This
patch is for the latter and is not directly link to the power because
the default/performance mode of the scheduler should also take
advantage of this information
