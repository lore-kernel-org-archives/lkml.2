Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326Ab2FHIA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:00:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51836 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab2FHIAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:00:25 -0400
Date: Fri, 8 Jun 2012 00:58:45 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: leonid.moiseichuk@nokia.com
Cc: kosaki.motohiro@gmail.com, penberg@kernel.org, b.zolnierkie@samsung.com,
        john.stultz@linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 2/5] vmevent: Convert from deferred timer to deferred work
Message-ID: <20120608075844.GA6362@lizard>
References: <20120601122118.GA6128@lizard>
 <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com>
 <20120608065828.GA1515@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 07:05:46AM +0000, leonid.moiseichuk@nokia.com wrote:
> > -----Original Message-----
> > From: ext Anton Vorontsov [mailto:anton.vorontsov@linaro.org]
> > Sent: 08 June, 2012 09:58
> ...
> > If you're saying that we should set up a timer in the userland and constantly
> > read /proc/vmstat, then we will cause CPU wake up every 100ms, which is
> > not acceptable. Well, we can try to introduce deferrable timers for the
> > userspace. But then it would still add a lot more overhead for our task, as this
> > solution adds other two context switches to read and parse /proc/vmstat. I
> > guess this is not a show-stopper though, so we can discuss this.
> > 
> > Leonid, Pekka, what do you think about the idea?
> 
> Seems to me not nice solution. Generating/parsing vmstat every 100ms plus wakeups it is what exactly should be avoid to have sense to API.

No, iff we implement deferred timers for userland, we would not wake
up every 100 ms. The only additional overhead comparing to vmevent
would be:

a) Two more context swtiches;
b) Serialization/deserialization of /proc/vmstat.

> It also will cause page trashing because user-space code could be pushed out from cache if VM decide. 

This can solved by moving a "watcher" to a separate (daemon) process,
and mlocking it. We do this in ulmkd.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
