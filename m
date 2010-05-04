Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0EDElv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 00:41:51 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:42588 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0EDElt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 00:41:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lEtYp5siqVXXpIWfbLYIJWKYOiT/XiBxicyVsXY8Q75zZrOIs1icZfzNqrUZgjvHoc
         /A8ziycOdMBq6yo6bVkPWyYRdnYzBTFnVxkERqiQ+VV9E4VMRcUOyT9uz1UoSXD/fbML
         kWoZfBkImtZ5UIKYSW7fI0rqub8fn1C2lZC9E=
Date: Mon, 3 May 2010 21:41:51 -0700
From: mark gross <640e9920@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: mgross@linux.intel.com, davidb@quicinc.com, dwalker@codeaurora.org,
       bruce.w.allan@intel.com, lkml <linux-kernel@vger.kernel.org>,
       tiwai@suse.de, mcgrof@gmail.com,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH]PM QOS refresh against next-20100430
Message-ID: <20100504044151.GB3043@thegnar.org>
Reply-To: markgross@thegnar.org
References: <20100430212043.GA30315@linux.intel.com>
 <20100503103300.6330e522@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503103300.6330e522@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 10:33:00AM -0600, Jonathan Corbet wrote:
> On Fri, 30 Apr 2010 14:20:43 -0700
> mark gross <mgross@linux.intel.com> wrote:
> 
> > This patch changes the string based list management to a handle base
> > implementation to help with the hot path use of pm-qos
> 
> Having taken a quick look, I think the API change makes a lot of
> sense.  Hot paths are one thing; avoidance of accidental conflicts
> would be another.

Conflicts? say more please.
 
> One question, though...  one clear use of this API is for drivers to
> say "don't go into C3 or deeper because things go wrong"; I'm about to
> add another one of those.  It works, but the use of a
> PM_QOS_CPU_DMA_LATENCY requirement with a hard-coded number that one
> hopes is small enough seems a bit...indirect.  I wonder if it would be
> clearer and more robust to add a new requirement^Wrequest type saying
> "the quality of service I need is shallow sleeps only"?

Well, adding such an api to cpuidle could do this for you.  "shallow" is
hard to define, but one could do what google did and define a
cpu_wake_lock type of API to block entry into any low power halt/mwait
type of state.  i.e. shallow would be C0, or just halt in idle.

If such a thing fits a "hotpath" API extention to pm_qos basically
implementing a low overhead disable lowpower behavior without having to
walk the pm_qos lists to get an agrigate value.  But, if such an api
belongs in cpu_idle thats fine too, as the only user of such and API
really is devices (like spi devices hangining of a clock that goes down
in the deeper idle states) wanting to block low power idle states, so be
it.

--mgross

> 
> jon
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
