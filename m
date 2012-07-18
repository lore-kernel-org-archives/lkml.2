Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab2GRUHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 16:07:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab2GRUHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 16:07:30 -0400
Date: Wed, 18 Jul 2012 22:06:20 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, Namhyung Kim <namhyung@gmail.com>,
        acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
Message-ID: <20120718200619.GC5627@krava.redhat.com>
References: <20120702101518.GC967@krava.redhat.com>
 <1341234662.1476.13.camel@leonhard>
 <20120702133341.GD967@krava.redhat.com>
 <CABPqkBTKNuwJXY7jRa+Zt8rmFftZUeJiYKEsKJeRiLdoHN3KWQ@mail.gmail.com>
 <CAOPLpQfWtyRHYT1ZfcdmshYoapBgF=FO7yFacYe8pyL0MBeebA@mail.gmail.com>
 <CABPqkBTTZaCVTtwJZbjXGwAihKAW_PMFK0+TZUTvbOn4pnfzvA@mail.gmail.com>
 <20120709110528.GA965@krava.redhat.com>
 <CABPqkBTGOvSuCfOUt=gnpfViVn8Whg0Mf7_3dUUim-iXA+8gjA@mail.gmail.com>
 <20120718102152.GA2587@krava.redhat.com>
 <CAOPLpQcYiHP7oppUOQx8S5kmy15rKxA-bS=oO-3Ms-KYu3D9Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOPLpQcYiHP7oppUOQx8S5kmy15rKxA-bS=oO-3Ms-KYu3D9Bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 08:34:10AM -0400, Ulrich Drepper wrote:
> On Wed, Jul 18, 2012 at 6:21 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> > Well, I personally like the '{}' syntax more than '--group-events or --group-reads
> > option in front', it feels more user friendly.. anyway, we can easily have both ways.
> 
> I like the actual visual grouping better, too.
> 
> Also, it doesn't require us to define what
> 
>    -e E1,E2 --group-events -e E3,E4
> 
> means.  Does --group-events also apply to the first parameter?
> 
> 
> > As for the group attributes and group leader sampling, I don't mind omitting
> > them at this point and get back to that if we find it useful in future.
> 
> Just define the first event the leader.  What reason is there which
> prevents this?

yep, no problem.. first one is the leader

The group sampling is just another feature where you enable sampling
only for the leader and the rest of the events in the group are only
being read on leader's sample - they don't sample by themselves.

But this feature needs more testing, and event modifier syntax rethinking ;)
I'll send it later..

> I can only second what Andi wrote: just get it done quickly.  This is
> functionality that is desperately needed.

I have new patchset ready with group modifiers adding modifiers
to events in the group, like:

 {cycles:u,instructions:u}:p

adds 'p' to both events in the group
(in current patchset group modifier overwrites events modifiers)

if there's strong opinion/reasons against it, I can simply remove
it, but it looks helpful

jirka
