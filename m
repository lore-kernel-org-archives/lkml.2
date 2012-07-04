Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2GDRec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 13:34:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab2GDReb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 13:34:31 -0400
Date: Wed, 4 Jul 2012 19:34:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCH 2/3] perf, tool: Enable grouping logic for parsed events
Message-ID: <20120704173407.GA2880@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
 <1340960907-3725-3-git-send-email-jolsa@redhat.com>
 <87bojync4b.fsf@sejong.aot.lge.com>
 <20120702101010.GB967@krava.redhat.com>
 <873959mzi3.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873959mzi3.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 09:58:44AM +0900, Namhyung Kim wrote:
> On Mon, 2 Jul 2012 12:10:10 +0200, Jiri Olsa wrote:
> > On Mon, Jul 02, 2012 at 11:13:56AM +0900, Namhyung Kim wrote:
> >> On Fri, 29 Jun 2012 11:08:26 +0200, Jiri Olsa wrote:
> >> > It's possible to use standard event modifier for a group, which spans
> >> > over all events in the group and overrides any event modifier settings,
> >> > for example:
> >> >
> >> >   # perf record -r '{faults:k,cache-references}:u'
> >> >
> >> > resulting in ':u' modifier being used for both 'faults' and 'cache-references'
> >> > events, regardless of their modifier setup (':k' for faults event).
> >> >
> >> 
> >> So the faults event would get only 'u' for the modifier not 'uk', right?
> >
> > right
> >
> 
> I was thinking about the combining the modifiers - i.e. make it 'uk'
> above. Not sure it's useful in general, but something like "adding 'p'
> to the leader (only)" looks good to have IMHO.

just hit the issue with leader 'p' during tests ;) but still not sure which
way is more usefull thought.. probably better to have both ways available

how about uppercase group modifier overwrites, lowercase means combining

or any other way.. ;) thoughts?

jirka

> 
> Thanks,
> Namhyung
