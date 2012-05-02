Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab2EBDdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:33:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56385 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab2EBDc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:32:59 -0400
Date: Tue, 1 May 2012 20:31:37 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Glauber Costa <glommer@parallels.com>, kamezawa.hiroyu@jp.fujitsu.com,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v4] vmevent: Implement greater-than attribute state and
 one-shot mode
Message-ID: <20120502033136.GA14740@lizard>
References: <20120418083208.GA24904@lizard>
 <20120418083523.GB31556@lizard>
 <alpine.LFD.2.02.1204182259580.11868@tux.localdomain>
 <20120418224629.GA22150@lizard>
 <alpine.LFD.2.02.1204190841290.1704@tux.localdomain>
 <20120419162923.GA26630@lizard>
 <20120501131806.GA22249@lizard>
 <4FA04FD5.6010900@redhat.com>
 <20120502002026.GA3334@lizard>
 <4FA08BDB.1070009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FA08BDB.1070009@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello KOSAKI,

On Tue, May 01, 2012 at 09:20:27PM -0400, KOSAKI Motohiro wrote:
[...]
> >It would be great indeed, but so far I don't see much that
> >vmevent could share. Plus, sharing the code at this point is not
> >that interesting; it's mere 500 lines of code (comparing to
> >more than 10K lines for cgroups, and it's not including memcg_
> >hooks and logic that is spread all over mm/).
> >
> >Today vmevent code is mostly an ABI implementation, there is
> >very little memory management logic (in contrast to the memcg).
> 
> But, if it doesn't work desktop/server area, it shouldn't be merged.

What makes you think that vmevent won't work for desktop or servers?
:-)

E.g. for some servers you don't always want memcg, really. Suppose,
a kvm farm or a database server. Sometimes there's really no need for
the memcg, but there's still a demand for low memory notifications.

Current Linux desktops don't use any notifications at all, I think.
So nothing to say about, neither on cgroup's nor on vmevent's behalf.
I hardly imagine why desktop would use the whole memcg thing, but
still have a use case for memory notifications.

> We have to consider the best design before kernel inclusion. They cann't
> be separeted to discuss.

Of course, no objections here. But I somewhat disagree with the
"best design" term. Which design is better, reading a file via
read() or mmap()? It depends. Same here.

So far, I see that memcg has its own cons, some are "by design"
and some because of incomplete features (e.g. slab accounting,
which, if accepted as is, seem to have its own design flaws).

memcg has many pros as well, the main goodness of memcg (for
memory notifications case) is rate limited events, which is a very
cool feature, and memcg has the feature because it's so much
tied with the mm subsystem.

But, as I said in my previus email, making memcg backend for
vmevents seems doable. We'd only need to place a vmevents hook
into mm/memcontrol.c:memcg_check_events() and export
mem_cgroup_usage() call.

So vmevent makes it possible for things to work with cgroups and
without cgroups, everybody's happy.

Thanks,

p.s. I'm not the vmevents author, plus I use both memcg and
vmevents. That makes me think that I'm pretty unbiased here. ;-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
