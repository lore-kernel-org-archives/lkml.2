Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1KDAWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 20:22:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49969 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1KDAV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 20:21:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH pm-for-3.2 2/2] freezer: revert 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Fri, 4 Nov 2011 01:24:33 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@redhat.com>
References: <20111103230749.GS4417@google.com> <201111040113.21514.rjw@sisk.pl> <20111104001759.GU4417@google.com>
In-Reply-To: <20111104001759.GU4417@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111040124.34015.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 04, 2011, Tejun Heo wrote:
> Hello, Rafael.
> 
> On Fri, Nov 04, 2011 at 01:13:21AM +0100, Rafael J. Wysocki wrote:
> > On Friday, November 04, 2011, Tejun Heo wrote:
> > > Commit 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake
> > > TASK_KILLABLE tasks too" updated fake_signal_wake_up() used by freezer
> > > to wake up KILLABLE tasks.  Sending unsolicited wakeups to tasks in
> > > killable sleep is dangerous as there are code paths which depend on
> > > tasks not waking up spuriously from KILLABLE sleep.
> > > 
> > > For example. sys_read() or page can sleep in TASK_KILLABLE assuming
> > > that wait/down/whatever _killable can only fail if we can not return
> > > to the usermode.  TASK_TRACED is another obvious example.
> > > 
> > > The previous patch updated wait_event_freezekillable() such that it
> > > doesn't depend on the spurious wakeup.  This patch reverts the
> > > offending commit.
> > > 
> > > Note that the spurious KILLABLE wakeup had other implicit effects in
> > > KILLABLE sleeps in nfs and cifs and those will need further updates to
> > > regain freezekillable behavior.
> > > 
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Jeff Layton <jlayton@redhat.com>
> > > LKML-Reference: <20111031221743.GA18855@google.com>
> > 
> > Applied to linux-pm/linux-next.
> 
> Just to be sure, as the commit which changed fake_signal_wake_up() to
> use KILLABLE wakeup is already mainline, these two will have to be
> pushed as fixes after some time in this devel cycle.

Yes, they are 3.2 material and I'm going to push them in the next few days
along with a number of other PM-related fixes/cleanups.  Is that OK?

Rafael
