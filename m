Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2CHR5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:57:36 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:46562 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273Ab2CHR5f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:57:35 -0500
Subject: Re: [RFC] Scheduler recorder and playback
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CAKew6eVZCPovNwEbYAE5zEpdZVq0A9nteTtbDOVWLMZ40W0jhQ@mail.gmail.com>
Date: Thu, 8 Mar 2012 19:57:29 +0200
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-dev@lists.linaro.org, Steven Goss <steve.goss@ti.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Kumar Gala <galak@ti.com>, Robin Randhawa <robin.randhawa@arm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <DBEAC4EA-AB36-4CAE-A34E-DB78380511F9@antoniou-consulting.com>
References: <85A3EFC3-FAE0-4B3A-AAA0-85FA435A9F7B@antoniou-consulting.com> <CAKew6eVZCPovNwEbYAE5zEpdZVq0A9nteTtbDOVWLMZ40W0jhQ@mail.gmail.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yadi,

On Mar 8, 2012, at 7:40 PM, Yadwinder Singh Brar wrote:

> On Thu, Mar 8, 2012 at 6:50 PM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
>> 
>> Hi there,
>> 
>> There's considerable activity in the subject of the scheduler lately and how to
>> adapt it to the peculiarities of the new class of hardware coming out lately,
>> like the big.LITTLE class of devices from a number of manufacturers.
>> 
>> The platforms that Linux runs are very diverse, and run differing workloads.
>> For example most consumer devices will very likely run something like Android,
>> with common use cases such as audio and/or video playback. Methods to achieve
>> lower power consumption using a power aware scheduler are under investigation.
>> 
>> Similarly for server applications, or VM hosting, the behavior of the scheduler
>> shouldn't have adverse performance implications; any power saving on top of that
>> would be a welcome improvement.
>> 
>> The current issue is that scheduler development is not easily shared between
>> developers. Each developer has their own 'itch', be it Android use cases, server
>> workloads, VM, etc. The risk is high of optimizing for one's own use case and
>> causing severe degradation on most other use cases.
>> 
>> One way to fix this problem would be the development of a method with which one
>> could perform a given use-case workload in a host, record the activity in a
>> interchangeable portable trace format file, and then play it back on another
>> host via a playback application that will generate an approximately similar load
>> which was observed during recording.
>> 
> I believe many people would have had this simple idea, but I don't know why,
> or if, it's bad. So I am going to ask.
> 
> Why not have much coarser, but deterministic, load patterns using user
> space apps
> (perhaps modified to log important characteristics of execution) ?
> 
> We could have, say, three sets of stress patterns one each for Server, Desktop
> and Mobile. Only deterministic would be top-level usage pattern (say by having
> some app-spawning script running from init, with least or none
> external influence)
> 
> Say the 'Mobile-profile' script could spawn multimedia playback,
> encoding/decoding,
> 3d game playback, storage access and suspend/resume cycles in some parallel
> and serial manner. Each task at the end tells how it was treated
> during its lifetime
> (total dropped frames, average latency, overall power consumed etc). From which
> we calculate a 'GPA'.
> For any modification in the scheduler, we could see how it affects the
> current score
> for each profile running on respective reference platforms.
> 
> Kind Regards
> Yadi
> 
> ps: I had to drop Amit Kucheria <<amit.kucheria@li>, otherwise my post
> wouldn't fire.
> 

The problem is defining that characteristic load pattern. Which is it?
It might one set of things today, something different tomorrow.
Not only the kernel is evolving, media application evolve too.
In the end you will end up with some workloads that are treated as
benchmarks, and manufacturers will start tweaking for them.

On top of that, the most common consumer linux platform is Android.
I bet that most kernel developers do not run Android as their main 
platform; but they do care to test if their changes affect Android
performance.

There is value however in recording these characteristic use-cases, 
and keeping them in a repository of traces, so when one hacks on the
scheduler can compare results.

Regards

-- Pantelis
> 
> ---------------------
> Jo darr gaya, so marr gaya!

