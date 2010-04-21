Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0DUJCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:02:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:62130 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab0DUJCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:02:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=lkbxZy9HG9vT43Oas0OkrjmioYW0TX2qIg3dtuN7SfkBQ8qYfGB22jOhy/V/Pmcs1
	jqG76z1S4hXQfEAD9wFlw==
MIME-Version: 1.0
In-Reply-To: <20100421084700.GU11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <1271190201-25705-12-git-send-email-robert.richter@amd.com>
	 <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
	 <20100420160557.GT11907@erda.amd.com>
	 <20100421084700.GU11907@erda.amd.com>
Date: Wed, 21 Apr 2010 11:02:42 +0200
Message-ID: <o2ibd4cb8901004210202i1ba91c3dlc775a9f7759ece68@mail.gmail.com>
Subject: Re: [PATCH 11/12] perf, x86: implement AMD IBS event configuration
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 10:47 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 20.04.10 18:05:57, Robert Richter wrote:
>> > What is the problem with directly using the period here, rejecting
>> > any value that is off range or with bottom 4 bits set?
>>
>> Yes, I will create an updated version of this patch.
>
> Stephane, do you think having the lower 4 bits set is worth an EINVAL?
> I would rather ignore them since the accuracy is not really necessary
> compared to a range lets say from 100000 cycles? Otherwise this will
> make the setup of ibs much more complicated. The check could be moved
> to userland and generate a waring or so.

Explain why you think it would be more complicated?
If I recall there is already a function to validate the attrs:
amd_pmu_hw_config().
But may be you are talking about userland setup.

Here is one argument why this might be important. Some people like to
know exactly
the sampling period because they use a particular value, like a prime
number. You
chopping off the bottom 4 bits could break this logic silently.
