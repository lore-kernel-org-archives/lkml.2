Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1KCA6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:58:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47269 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1KCA6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:58:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH pm] freezer: fix wait_event_freezable/__thaw_task races
Date: Thu, 3 Nov 2011 02:01:27 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org
References: <20111101021511.GP18855@google.com> <201111030120.42102.rjw@sisk.pl> <20111103004350.GA4417@google.com>
In-Reply-To: <20111103004350.GA4417@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111030201.27551.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 03, 2011, Tejun Heo wrote:
> On Thu, Nov 03, 2011 at 01:20:41AM +0100, Rafael J. Wysocki wrote:
> > On Tuesday, November 01, 2011, Tejun Heo wrote:
> > > From: Oleg Nesterov <oleg@redhat.com>
> > > 
> > > wait_event_freezable() and friends stop the waiting if try_to_freeze()
> > > fails. This is not right, we can race with __thaw_task() and in this
> > > case
> > > 
> > > 	- wait_event_freezable() returns the wrong ERESTARTSYS
> > > 
> > > 	- wait_event_freezable_timeout() can return the positive
> > > 	  value while condition == F
> > > 
> > > Change the code to always check __retval/condition before return.
> > > 
> > > Note: with or without this patch the timeout logic looks strange,
> > > probably we should recalc timeout if try_to_freeze() returns T.
> > > 
> > > tj: Updated to apply to wait_event_freezekillable() too.
> > > 
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > > Acked-by: Tejun Heo <tj@kernel.org>
> > 
> > Applied to linux-pm/linux-next.
> 
> Just in case, this patch isn't correct with preceding patches (the
> freezer update patchset), so should only be applied after them.

OK, so I guess I should drop it from my linux-next branch?

Rafael
