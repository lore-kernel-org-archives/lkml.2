Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab2GEQpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:45:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880Ab2GEQpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:45:45 -0400
Date: Thu, 5 Jul 2012 13:44:47 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
Message-ID: <20120705164447.GE7533@infradead.org>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
 <87fw9blyhj.fsf@sejong.aot.lge.com>
 <20120702101518.GC967@krava.redhat.com>
 <1341234662.1476.13.camel@leonhard>
 <20120702133341.GD967@krava.redhat.com>
 <CABPqkBTKNuwJXY7jRa+Zt8rmFftZUeJiYKEsKJeRiLdoHN3KWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTKNuwJXY7jRa+Zt8rmFftZUeJiYKEsKJeRiLdoHN3KWQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 05, 2012 at 06:15:20PM +0200, Stephane Eranian escreveu:
> On Mon, Jul 2, 2012 at 3:33 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > perf, tool: Enable sampling on specified event group leader
> >
> > Adding the functionality to the group modifier event syntax.
> > Allowing user to select leader event inside the group using
> > event index (command line event position in the group).
> >
> > Following example selects e2 as leader:
> >   -e '{e1,e2,e3,e4}:2'
> >
> I don't understand why you actually need the :2 suffix. There can
> only be one leader. So assume it is the first one. Users have to
> know the first one is the leader which seems like a natural thing
> to do for me. It would make you syntax less ugly than it already
> is.

Agreed, looks like creeping featurism.
 
> I would have thought you could enable this with a simple
> cmdline option which changes the way you interpret the
> multiple -e options:
> 
> perf record --group-reads -e e1,e2,e3 -e e4,e5,e6 .....
> 
> Would setup the group leaders (e1, e4) for 2 groups.
> NO curly braces, no : needed.

Yeah, curly braces needed just when one wants to add group wide
modifiers.
 
- Arnaldo
