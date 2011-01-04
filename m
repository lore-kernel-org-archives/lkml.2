Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab1ADQSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:18:55 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61695 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1ADQSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:18:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=FyKBp6uV0VktW9oh7ts9zVJm1y+kjszgyENLpwdKvXHmVDL0JBTwqzJ3knyrSck2sg
         6pUpGumlkwCP9ipenDEfV99ZSgBiXOVVKoA0KPWpFsrC8eJUZzCdFxWwHLpwcD13YgRM
         MZX7vetAO5kueZh40nmCGBheWtgl8+5QxmVZM=
MIME-Version: 1.0
In-Reply-To: <1294156524.6169.147.camel@Palantir>
References: <1294156524.6169.147.camel@Palantir>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 4 Jan 2011 14:18:33 -0200
Message-ID: <AANLkTiks650aGw+SZzTYbKvMcn4w56XwQ+h+qT5V5hGD@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] Refactoring sched_entity and sched_rt_entity.
To: Dario Faggioli <raistlin@linux.it>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Darren Hart <darren@dvhart.com>, oleg <oleg@redhat.com>,
        paulmck <paulmck@linux.vnet.ibm.com>, pjt@google.com,
        bharata@linux.vnet.ibm.co
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dario

On Tue, Jan 4, 2011 at 13:55, Dario Faggioli <raistlin@linux.it> wrote:
> Hi everybody,
>
> After having heard Peter talking about it many times, I finally decided
> to give this thing a spin. It is basically the idea of putting the
> current sched_entity and sched_rt_entity together in an union, contained
> in a more general structure which hosts the common fields of the twos.
> For example, it came out here: http://lkml.org/lkml/2009/7/9/153
>
> Therefore, this patchset _DOES_NOT_ do that! :-O
>
> In fact, this is some preliminary refactoring which I think it's needed
> before union-ify the two data structure, and on which I would like to
> get some preliminary comments, before going ahead with the wrong
> approach.
>
> Basically, I renamed struct sched_entity to struct sched_cfs_entity and
> put it and sched_rt_entity inside a more general struct sched_entity...
> Is that clear? :-)
> The patches just cope with that. Yes, there's some work done by a patch
> and undone by the next one. I now it's annoying, and I'm sorry, but I
> did such for the sake of reviewability and for making each patch compile
> cleanly.
> As for the name of CFS's scheduling entities, sched_fair_entity would
> probably have been better, but it's longer, and "_cfs" is already
> present in many places, so I went for it... No big deal in changing
> that, apart from stay-within-80-characters-per-line issues! :-P
>
> They're not inside an union yet, because I'm not sure on how to treat
> the task group case. In fact, tasks can only have _just_one_ scheduling
> policy at a time, and thus, for example, they need the run_list _or_ the
> rb_node for queueing (if the task is RT or fair, respectively), which is
> perfect with respect to using an union.
> OTOH, groups are always considered both fair _and_ RT entities, for
> example they're always queued in _both_ an RT run_list and a fair
> rb-tree. So I can't put them in an union, because I need both at the
> same time!
> Suggestions on how to deal with that will be appreciated.
>

In fact I created the patchset but I didn't have time to finish,
polish, test and send. There are several corner cases that must be
treated that made me think if it was really worth the work.

In this repo you can find a greatly outdated branch that treats some
of the troubles you'll need to think about:

git://git.profusion.mobi/users/lucas/linux-2.6.git schedentity

And this was a rebase I did, but irc it was not working well:

git://git.profusion.mobi/users/lucas/linux-2.6.git schedentity-rebased




Lucas De Marchi
