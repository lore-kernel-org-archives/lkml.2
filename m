Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab0ECQkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:40:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46076 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab0ECQkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:40:15 -0400
To: Jonathan Corbet <corbet@lwn.net>
Cc: mgross@linux.intel.com, aili@codeaurora.org, dwalker@codeaurora.org,
       tiwai@suse.de, bruce.w.allan@intel.com, davidb@quicinc.com,
       mcgrof@gmail.com, pavel@ucw.cz,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]PM QOS refresh against next-20100430
References: <20100430212043.GA30315@linux.intel.com>
	<20100503103300.6330e522@bike.lwn.net>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 03 May 2010 09:40:11 -0700
In-Reply-To: <20100503103300.6330e522@bike.lwn.net> (Jonathan Corbet's message of "Mon\, 3 May 2010 10\:33\:00 -0600")
Message-ID: <87y6g1547o.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> writes:

> On Fri, 30 Apr 2010 14:20:43 -0700
> mark gross <mgross@linux.intel.com> wrote:
>
>> This patch changes the string based list management to a handle base
>> implementation to help with the hot path use of pm-qos
>
> Having taken a quick look, I think the API change makes a lot of
> sense.  Hot paths are one thing; avoidance of accidental conflicts
> would be another.
>
> One question, though...  one clear use of this API is for drivers to
> say "don't go into C3 or deeper because things go wrong"; I'm about to
> add another one of those.  It works, but the use of a
> PM_QOS_CPU_DMA_LATENCY requirement with a hard-coded number that one
> hopes is small enough seems a bit...indirect.  I wonder if it would be
> clearer and more robust to add a new requirement^Wrequest type saying
> "the quality of service I need is shallow sleeps only"?

The problem with that is portability.

What does "shallow" mean?  

Even between different SoCs in the same family, shallow might have
different meaning, but across architectures, this certainly would not
be portable.

Kevin
