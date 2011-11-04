Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab1KDASH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 20:18:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57861 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1KDASF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 20:18:05 -0400
Date: Thu, 3 Nov 2011 17:17:59 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH pm-for-3.2 2/2] freezer: revert 27920651fe "PM /
 Freezer: Make fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Message-ID: <20111104001759.GU4417@google.com>
References: <20111103230749.GS4417@google.com>
 <20111103230910.GT4417@google.com>
 <201111040113.21514.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111040113.21514.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Fri, Nov 04, 2011 at 01:13:21AM +0100, Rafael J. Wysocki wrote:
> On Friday, November 04, 2011, Tejun Heo wrote:
> > Commit 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake
> > TASK_KILLABLE tasks too" updated fake_signal_wake_up() used by freezer
> > to wake up KILLABLE tasks.  Sending unsolicited wakeups to tasks in
> > killable sleep is dangerous as there are code paths which depend on
> > tasks not waking up spuriously from KILLABLE sleep.
> > 
> > For example. sys_read() or page can sleep in TASK_KILLABLE assuming
> > that wait/down/whatever _killable can only fail if we can not return
> > to the usermode.  TASK_TRACED is another obvious example.
> > 
> > The previous patch updated wait_event_freezekillable() such that it
> > doesn't depend on the spurious wakeup.  This patch reverts the
> > offending commit.
> > 
> > Note that the spurious KILLABLE wakeup had other implicit effects in
> > KILLABLE sleeps in nfs and cifs and those will need further updates to
> > regain freezekillable behavior.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Jeff Layton <jlayton@redhat.com>
> > LKML-Reference: <20111031221743.GA18855@google.com>
> 
> Applied to linux-pm/linux-next.

Just to be sure, as the commit which changed fake_signal_wake_up() to
use KILLABLE wakeup is already mainline, these two will have to be
pushed as fixes after some time in this devel cycle.

Thanks.

-- 
tejun
