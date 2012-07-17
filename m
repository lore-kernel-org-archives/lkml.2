Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab2GQHP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:15:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37914 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2GQHPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120709110528.GA965@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
	<87fw9blyhj.fsf@sejong.aot.lge.com>
	<20120702101518.GC967@krava.redhat.com>
	<1341234662.1476.13.camel@leonhard>
	<20120702133341.GD967@krava.redhat.com>
	<CABPqkBTKNuwJXY7jRa+Zt8rmFftZUeJiYKEsKJeRiLdoHN3KWQ@mail.gmail.com>
	<CAOPLpQfWtyRHYT1ZfcdmshYoapBgF=FO7yFacYe8pyL0MBeebA@mail.gmail.com>
	<CABPqkBTTZaCVTtwJZbjXGwAihKAW_PMFK0+TZUTvbOn4pnfzvA@mail.gmail.com>
	<20120709110528.GA965@krava.redhat.com>
Date: Tue, 17 Jul 2012 09:15:23 +0200
Message-ID: <CABPqkBTGOvSuCfOUt=gnpfViVn8Whg0Mf7_3dUUim-iXA+8gjA@mail.gmail.com>
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ulrich Drepper <drepper@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 1:05 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Jul 06, 2012 at 03:42:54AM +0200, Stephane Eranian wrote:
> > On Fri, Jul 6, 2012 at 3:32 AM, Ulrich Drepper <drepper@gmail.com> wrote:
> > > On Thu, Jul 5, 2012 at 12:15 PM, Stephane Eranian <eranian@google.com> wrote:
> > >> I don't understand why you actually need the :2 suffix. There can
> > >> only be one leader. So assume it is the first one. Users have to
> > >> know the first one is the leader which seems like a natural thing
> > >> to do for me. It would make you syntax less ugly than it already
> > >> is.
> > >
> > > In a blue sky world I would have done this.  In fact, this is what I
> > > tried before reading the sources to find out there is no group support
> > > so far.  But given that multiple -e options already have a meaning I
> > > would be hesitant to change this.
> >
> > That's why I said you activate grouping via -e only when you have
> > the --group-events or --group-reads option in front. That would
> > not change the meaning of the multiple -e when none of those
> > group options are specified.
>
> I discussed this with peter..
>
> <peterz> the {} thing allows: 1) multiple groups in a single -e, 2) group attributes
>
And what's the value of 1) exactly? What's wrong with passing multiple -e ?
The only group attribute I can think of would be :u, :k. Not so much typing.

> as for the leader sampling, we can have the first event to become the leader
> by default (omit the leader index modifier) and enable the leader sampling by
> another modifier:
>
I don't understand this sentence.

> <peterz> right, just make it a single 'l' (el not one) to indicate 'leader' sampling
>
To me ,this looks a bit of an over-engineered design and it is not based on
any actual user requests. Don't get me wrong, grouping is useful and required
but nobody has ever asked for that level of flexibility. The syntax you have
now is already very rich for my taste.




>
> jirka
