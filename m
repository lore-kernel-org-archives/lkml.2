Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab0FBWCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:02:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43886 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647Ab0FBWCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:02:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Thu, 3 Jun 2010 00:03:49 +0200
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
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com> <AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com> <20100602133910.GA9106@gvim.org>
In-Reply-To: <20100602133910.GA9106@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006030003.49486.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 June 2010, mark gross wrote:
> On Tue, Jun 01, 2010 at 08:50:02PM -0700, Arve Hjønnevåg wrote:
> > On Tue, Jun 1, 2010 at 7:05 AM, mark gross <640e9920@gmail.com> wrote:
> > > On Tue, Jun 01, 2010 at 09:07:37AM +0200, Florian Mickler wrote:
> > ...
> > >> +static void update_target_val(int pm_qos_class, s32 val)
> > >> +{
> > >> +     s32 extreme_value;
> > >> +     s32 new_value;
> > >> +     extreme_value = atomic_read(&pm_qos_array[pm_qos_class]->target_value);
> > >> +     new_value = pm_qos_array[pm_qos_class]->comparitor(val,extreme_value);
> > >> +     if (extreme_value != new_value)
> > >> +             atomic_set(&pm_qos_array[pm_qos_class]->target_value,new_value);
> > >> +}
> > >> +
> > >
> > > Only works 1/2 the time, but I like the idea!
> > > It fails to get the righ answer when constraints are reduced.  But, this
> > > idea is a good improvement i'll roll into the next pm_qos update!
> > >
> > 
> > I think it would be a better idea to track your constraints with a
> > sorted data structure. That way you can to better than O(n) for both
> > directions. If you have a lot of constraints with the same value, it
> > may even be worthwhile to have a two stage structure where for
> > instance you use a rbtree for the unique values and list for identical
> > constraints.
> 
> I don't agree, we went through this tree vrs list discussion a few times
> before in other areas of the kernel.  Wherever the list tended to be
> short, a simple list wins.  However; we can try it, after we have some
> metrics and stress test cases identified we can measure its effectivenes
> against.

How many different values are there to handle?

Rafael
