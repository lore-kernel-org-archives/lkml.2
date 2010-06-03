Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab0FCVB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:01:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47755 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab0FCVB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:01:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Thu, 3 Jun 2010 23:02:59 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>, 640e9920@gmail.com,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com> <201006030003.49486.rjw@sisk.pl> <20100603031024.GA11311@gvim.org>
In-Reply-To: <20100603031024.GA11311@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006032302.59947.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 June 2010, mark gross wrote:
> On Thu, Jun 03, 2010 at 12:03:49AM +0200, Rafael J. Wysocki wrote:
> > On Wednesday 02 June 2010, mark gross wrote:
> > > On Tue, Jun 01, 2010 at 08:50:02PM -0700, Arve Hjønnevåg wrote:
> > > > On Tue, Jun 1, 2010 at 7:05 AM, mark gross <640e9920@gmail.com> wrote:
> > > > > On Tue, Jun 01, 2010 at 09:07:37AM +0200, Florian Mickler wrote:
> > > > ...
> > > > >> +static void update_target_val(int pm_qos_class, s32 val)
> > > > >> +{
> > > > >> +     s32 extreme_value;
> > > > >> +     s32 new_value;
> > > > >> +     extreme_value = atomic_read(&pm_qos_array[pm_qos_class]->target_value);
> > > > >> +     new_value = pm_qos_array[pm_qos_class]->comparitor(val,extreme_value);
> > > > >> +     if (extreme_value != new_value)
> > > > >> +             atomic_set(&pm_qos_array[pm_qos_class]->target_value,new_value);
> > > > >> +}
> > > > >> +
> > > > >
> > > > > Only works 1/2 the time, but I like the idea!
> > > > > It fails to get the righ answer when constraints are reduced.  But, this
> > > > > idea is a good improvement i'll roll into the next pm_qos update!
> > > > >
> > > > 
> > > > I think it would be a better idea to track your constraints with a
> > > > sorted data structure. That way you can to better than O(n) for both
> > > > directions. If you have a lot of constraints with the same value, it
> > > > may even be worthwhile to have a two stage structure where for
> > > > instance you use a rbtree for the unique values and list for identical
> > > > constraints.
> > > 
> > > I don't agree, we went through this tree vrs list discussion a few times
> > > before in other areas of the kernel.  Wherever the list tended to be
> > > short, a simple list wins.  However; we can try it, after we have some
> > > metrics and stress test cases identified we can measure its effectivenes
> > > against.
> > 
> > How many different values are there to handle?
> >
> 
> for the current pm_qos users its tiny.  I've never heard of more than a
> few < 10.  However; for the new "interactive" class to provide suspend
> blocker functionality, I expect the number to be up to 20.
> 
> but realistically I bet we never get more than 10ish.
> 
> One constraint constraint request per module from isr to user mode.
> Once in user mode there would be only a few (assuming Android user
> space) I think just from the power HAL, input HAL, and the RIL.
> 
> Still a pretty small number I don't think we need to worry about scaling
> as much as we need to worry about performance.

In that case sorting the structure is rather not going to improve things, but
it might be worth using a hashtable or something similar.

Rafael
