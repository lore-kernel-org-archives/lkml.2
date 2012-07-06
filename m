Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2GFBGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 21:06:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38082 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2GFBGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 21:06:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120705164447.GE7533@infradead.org>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
	<87fw9blyhj.fsf@sejong.aot.lge.com>
	<20120702101518.GC967@krava.redhat.com>
	<1341234662.1476.13.camel@leonhard>
	<20120702133341.GD967@krava.redhat.com>
	<CABPqkBTKNuwJXY7jRa+Zt8rmFftZUeJiYKEsKJeRiLdoHN3KWQ@mail.gmail.com>
	<20120705164447.GE7533@infradead.org>
Date: Fri, 6 Jul 2012 03:06:41 +0200
Message-ID: <CABPqkBSS82X2Dt46jwLzbvC4WxkbewA8DhrMYjGmpAtugV2HNQ@mail.gmail.com>
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 6:44 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Thu, Jul 05, 2012 at 06:15:20PM +0200, Stephane Eranian escreveu:
>> On Mon, Jul 2, 2012 at 3:33 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> > perf, tool: Enable sampling on specified event group leader
>> >
>> > Adding the functionality to the group modifier event syntax.
>> > Allowing user to select leader event inside the group using
>> > event index (command line event position in the group).
>> >
>> > Following example selects e2 as leader:
>> >   -e '{e1,e2,e3,e4}:2'
>> >
>> I don't understand why you actually need the :2 suffix. There can
>> only be one leader. So assume it is the first one. Users have to
>> know the first one is the leader which seems like a natural thing
>> to do for me. It would make you syntax less ugly than it already
>> is.
>
> Agreed, looks like creeping featurism.
>
>> I would have thought you could enable this with a simple
>> cmdline option which changes the way you interpret the
>> multiple -e options:
>>
>> perf record --group-reads -e e1,e2,e3 -e e4,e5,e6 .....
>>
>> Would setup the group leaders (e1, e4) for 2 groups.
>> NO curly braces, no : needed.
>
> Yeah, curly braces needed just when one wants to add group wide
> modifiers.
And even, in that case that seems overkill too.
You can simply repeat the modifier on each event. A group cannot
big that big. It is limited in size by the number of physical counters
plus the events constraints.
