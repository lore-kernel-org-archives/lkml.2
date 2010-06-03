Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab0FCDSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 23:18:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51732 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933728Ab0FCDSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 23:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=eVTJX+oZZSt5N1NvFcK7CPSJEzju6eE6st8TdHuM4gdWosUHu/plBfhX8VShxR7Xpl
         /jpAn5UjOYtUDQk3FMqtzgaBTfKjf2BEA8DU+wiYcQQvZU6RtwbwbzCYArMEHJGSZ5VG
         hJiOL8WJT8e3G3rTcmKsuOBo9s1Vm6Oh2xTbk=
Date: Wed, 2 Jun 2010 20:18:42 -0700
From: mark gross <640e9920@gmail.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: markgross@thegnar.org, Florian Mickler <florian@mickler.org>,
       640e9920@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100603031842.GB11311@gvim.org>
Reply-To: markgross@thegnar.org
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
 <Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org>
 <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
 <201005312338.55109.rjw@sisk.pl>
 <20100531232617.GF31155@gvim.org>
 <20100601090737.4bc243d9@schatten.dmk.lab>
 <20100601140519.GC1281@gvim.org>
 <AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
 <20100602133910.GA9106@gvim.org>
 <AANLkTilSU79cnBODXFokzIPB1hRcZBxbwTgTQ59MeKcK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilSU79cnBODXFokzIPB1hRcZBxbwTgTQ59MeKcK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 02:58:30PM -0700, Arve Hjønnevåg wrote:
> 2010/6/2 mark gross <640e9920@gmail.com>:
> > On Tue, Jun 01, 2010 at 08:50:02PM -0700, Arve Hjønnevåg wrote:
> >> On Tue, Jun 1, 2010 at 7:05 AM, mark gross <640e9920@gmail.com> wrote:
> >> > On Tue, Jun 01, 2010 at 09:07:37AM +0200, Florian Mickler wrote:
> >> ...
> >> >> +static void update_target_val(int pm_qos_class, s32 val)
> >> >> +{
> >> >> +     s32 extreme_value;
> >> >> +     s32 new_value;
> >> >> +     extreme_value = atomic_read(&pm_qos_array[pm_qos_class]->target_value);
> >> >> +     new_value = pm_qos_array[pm_qos_class]->comparitor(val,extreme_value);
> >> >> +     if (extreme_value != new_value)
> >> >> +             atomic_set(&pm_qos_array[pm_qos_class]->target_value,new_value);
> >> >> +}
> >> >> +
> >> >
> >> > Only works 1/2 the time, but I like the idea!
> >> > It fails to get the righ answer when constraints are reduced.  But, this
> >> > idea is a good improvement i'll roll into the next pm_qos update!
> >> >
> >>
> >> I think it would be a better idea to track your constraints with a
> >> sorted data structure. That way you can to better than O(n) for both
> >> directions. If you have a lot of constraints with the same value, it
> >> may even be worthwhile to have a two stage structure where for
> >> instance you use a rbtree for the unique values and list for identical
> >> constraints.
> >
> > I don't agree, we went through this tree vrs list discussion a few times
> > before in other areas of the kernel.  Wherever the list tended to be
> > short, a simple list wins.  However; we can try it, after we have some
> > metrics and stress test cases identified we can measure its effectivenes
> > against.
> >
> 
> The list is not short. You have all the inactive and active
> constraints on the same list. If you change it to a two level list
> though, the list of unique values (which is the list you have to walk)
> may be short enough for a tree to be overkill.

what have you seen in practice from the wake-lock stats?

I'm having a hard time seeing where you could get more than just a
handfull.  However; one could go to a dual list (like the scheduler) and
move inactive nodes from an active to inactive list, or we could simply
remove them from the list uppon inactivity.  which would would well
after I change the api to have the client allocate the memory for the
nodes...  BUT, if your moving things in and out of a list a lot, I'm not
sure the break even point where changing the structure helps.

We'll need to try it.

I think we will almost never see more than 10 list elements.

--mgross

