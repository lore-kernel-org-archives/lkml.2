Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0LMTIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:08:39 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36556 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab0LMTIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=v6OBYJ95by306mI5HfyunEFRNx+rNGRJSdxdwra4AsZYAwVrC/UrKwV3QlGFvLJYeB
         rT3kD77CW7V+DVgEwZPNGhi5ogxbDg//6eWvPnDGL3Twe5aYBwr+VuquyTHq/TJad3XW
         OTPve+R7F/DjLnh3RdGltU1B3FKIYsqtoSeuc=
Date: Mon, 13 Dec 2010 17:08:31 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: "David S. Ahern" <daahern@cisco.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
Message-ID: <20101213190831.GA7984@ghostprotocols.net>
References: <20101213170923.GB1691@nowhere>
 <1292260289.6803.297.camel@twins>
 <20101213171537.GC1691@nowhere>
 <1292260699.6803.305.camel@twins>
 <20101213172216.GB7417@ghostprotocols.net>
 <1292261716.6803.332.camel@twins>
 <1292262433.6803.351.camel@twins>
 <4D065CB2.7050104@cisco.com>
 <1292263024.6803.370.camel@twins>
 <4D065F69.7080707@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D065F69.7080707@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 13, 2010 at 11:01:13AM -0700, David S. Ahern escreveu:
> On 12/13/10 10:57, Peter Zijlstra wrote:
> >> What about creating a PERF_RECORD_TIME and generate an event when the
> >> counter is opened? It contains a PERF_SAMPLE_TIME and say
> >> PERF_SAMPLE_TOD (time-of-day)? We're not sending rockets to saturn; we
> >> just need the timestamps to match other log files.

> > That's similar to the first thing I proposed. The problem is with long
> > record sessions your drift can become quite significant, then when you
> > merge sort your other log events stuff can get out of order. Which can
> > lead to some serious head-scratching..

> Gotcha. Missed that in the flury of emails.

> Arnaldo: Are you ok with this option? This should append mode as well.

What option, this one:

-----------------------------------------------------------------------
Peter Zijlstra wrote:

> In fact, the only sane way to do that is by creating a software counter
> that represents CLOCK_MONOTONIC and sample that say once a minute (or
> more often if you want smaller drift).
-----------------------------------------------------------------------

?

Yes, that looks the best option. I.e. no changes on headers, no new
user fake events, a new software event that may be useful for other
usecases.

We have:

[acme@mica linux]$ perf list | grep -- -clock
  cpu-clock                                  [Software event]
  task-clock                                 [Software event]
[acme@mica linux]$ 

So we would have a new one:

  monotonic-clock

Peter, agreed? I'll try to implement it now, good opportunity to learn a
bit more about soft pmus, I'd have to do that anyway for NIC stats, etc.

- Arnaldo
