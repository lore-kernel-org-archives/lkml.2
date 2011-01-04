Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab1ADQhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:37:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58332 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1ADQhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:37:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=U5W1Kjqr8iLoc93alM0C3fwqnDILCKMBXJU+fOSW7jDDKY1QElULRyz6nQHbZmeggH
         9YG65aHgiBV4KcDzAbJ9GDx0QHxQoTnFrj5Kl7WFMR8lxn6BZg0IOv0a0Myys2WL/WGR
         zbAyP0UASdd7DgClaWWtK9o9y4HY+Q5W8K5fE=
MIME-Version: 1.0
In-Reply-To: <1294156524.6169.147.camel@Palantir>
References: <1294156524.6169.147.camel@Palantir>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 4 Jan 2011 14:37:16 -0200
Message-ID: <AANLkTi=wCmetef0tjfvdHtZMS9x4eswhL_xAM5Ybdwq+@mail.gmail.com>
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

On Tue, Jan 4, 2011 at 13:55, Dario Faggioli <raistlin@linux.it> wrote:
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

Don't forget the PI case too. You will need to change
rt_mutex_setprio() to keep a copy of sched_cfs_entity in struct
rt_mutex_waiter.

Peter, isn't sched_fair_entity a better name?



Lucas De Marchi
