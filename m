Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0IGIqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 04:46:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60928 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab0IGIqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 04:46:43 -0400
Date: Tue, 7 Sep 2010 10:46:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim\@gmail.com" <minchan.kim@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>,
        "kosaki.motohiro\@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] big continuous memory allocator v2
Message-ID: <20100907104635.2a02a1ca@basil.nowhere.org>
In-Reply-To: <20100907172559.496554d8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100907114505.fc40ea3d.kamezawa.hiroyu@jp.fujitsu.com>
	<87occa9fla.fsf@basil.nowhere.org>
	<20100907172559.496554d8.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010 17:25:59 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 07 Sep 2010 09:29:21 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> > 
> > > This is a page allcoator based on memory migration/hotplug code.
> > > passed some small tests, and maybe easier to read than previous
> > > one.
> > 
> > Maybe I'm missing context here, but what is the use case for this?
> > 
> 
> I hear some drivers want to allocate xxMB of continuous area.(camera?)
> Maybe embeded guys can answer the question.

Ok what I wanted to say -- assuming you can make this work
nicely, and the delays (swap storms?) likely caused by this are not
too severe, it would be interesting for improving the 1GB pages on x86.

This would be a major use case and probably be enough
to keep the code around.

But it depends on how well it works.

e.g. when the zone is already fully filled how long
does the allocation of 1GB take?

How about when parallel programs are allocating/freeing
in it too?

What's the worst case delay under stress?

Does it cause swap storms?

One issue is also that it would be good to be able to decide
in advance if the OOM killer is likely triggered (and if yes
reject the allocation in the first place). 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
