Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0ECRBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:01:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54335 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0ECRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 13:01:54 -0400
To: Jonathan Corbet <corbet@lwn.net>
Cc: mgross@linux.intel.com, aili@codeaurora.org, dwalker@codeaurora.org,
       tiwai@suse.de, bruce.w.allan@intel.com, davidb@quicinc.com,
       mcgrof@gmail.com, pavel@ucw.cz,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]PM QOS refresh against next-20100430
References: <20100430212043.GA30315@linux.intel.com>
	<20100503103300.6330e522@bike.lwn.net>
	<87y6g1547o.fsf@deeprootsystems.com>
	<20100503104250.7605d2bc@bike.lwn.net>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 03 May 2010 10:01:50 -0700
In-Reply-To: <20100503104250.7605d2bc@bike.lwn.net> (Jonathan Corbet's message of "Mon\, 3 May 2010 10\:42\:50 -0600")
Message-ID: <87tyqo537l.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> writes:

> On Mon, 03 May 2010 09:40:11 -0700
> Kevin Hilman <khilman@deeprootsystems.com> wrote:
>
>> > One question, though...  one clear use of this API is for drivers to
>> > say "don't go into C3 or deeper because things go wrong"; I'm about to
>> > add another one of those.  It works, but the use of a
>> > PM_QOS_CPU_DMA_LATENCY requirement with a hard-coded number that one
>> > hopes is small enough seems a bit...indirect.  I wonder if it would be
>> > clearer and more robust to add a new requirement^Wrequest type saying
>> > "the quality of service I need is shallow sleeps only"?  
>> 
>> The problem with that is portability.
>> 
>> What does "shallow" mean?  
>
> Well, shallow could mean that the state lacks the CPUIDLE_FLAG_DEEP
> flag; that should be relatively portable.  In any case, it seems
> more so than "if I put in a 55us latency requirement, I'll stay out
> of C3".

I guess it depends on your goal.  Do you just want to stay out of C3
on your current platform?  or do you want to stay out of any low-power
state (on any platform) where you'll have a latency of > 55 usecs?

The former is not portable (as C-states don't have the same meanings
across arches/SoCs) where as using a real-world number in usecs will
have meaning on any platform.

> Just a thought, anyway; it's not like I've really worked through a
> plausible alternative API.

My main concern is that drivers not be written with latency
constraints that assume an Intel-centric set of power states.  There
are other SoCs out there with different sets of states and
corresponding latencies, so keeping things in real-world numbers
(latency, throughput, etc.) seems to me to be the only portable way.

Kevin

