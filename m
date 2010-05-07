Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0EGFPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:15:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62030 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0EGFPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <20100507100729.a6589d8a.kamezawa.hiroyu@jp.fujitsu.com>
References: <1273058509-16625-1-git-send-email-ext-phil.2.carmody@nokia.com>
	 <1273058509-16625-2-git-send-email-ext-phil.2.carmody@nokia.com>
	 <20100506142417.6d317068.akpm@linux-foundation.org>
	 <20100507100729.a6589d8a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 7 May 2010 08:15:22 +0300
Message-ID: <t2ucc557aab1005062215p41f6086p21a19710d528d034@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: memcontrol - uninitialised return value
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>, balbir@linux.vnet.ibm.com,
       nishimura@mxp.nes.nec.co.jp, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 4:07 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 6 May 2010 14:24:17 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Wed,  5 May 2010 14:21:49 +0300
>> Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:
>>
>> > From: Phil Carmody <ext-phil.2.carmody@nokia.com>
>> >
>> > Only an out of memory error will cause ret to be set.
>> >
>> > Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
>> > Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
>> > ---
>> >  mm/memcontrol.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> > index 90e32b2..09af773 100644
>> > --- a/mm/memcontrol.c
>> > +++ b/mm/memcontrol.c
>> > @@ -3464,7 +3464,7 @@ static int mem_cgroup_unregister_event(struct cgroup *cgrp, struct cftype *cft,
>> >     int type = MEMFILE_TYPE(cft->private);
>> >     u64 usage;
>> >     int size = 0;
>> > -   int i, j, ret;
>> > +   int i, j, ret = 0;
>> >
>> >     mutex_lock(&memcg->thresholds_lock);
>> >     if (type == _MEM)
>>
>> afacit the return value of cftype.unregister_event() is always ignored
>> anyway.  Perhaps it should be changed to void-returning, or fixed.
>>
>>
> Ah, it's now "TODO". But hmm...."unregister_event()" is called by workqueue.
> (for avoiding race?)

Because it can be called from atomic context.

> I think unregister_event should be "void" and mem_cgroup_unregister_event()
> should be implemented as "never fail" function.
>
> I'll try by myself....but if someone knows this event notifier implementation well,
> please.

Ok, better if I'll do it.
