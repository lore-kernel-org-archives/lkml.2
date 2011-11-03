Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1KCAn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:43:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44037 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1KCAn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:43:56 -0400
Date: Wed, 2 Nov 2011 17:43:50 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH pm] freezer: fix wait_event_freezable/__thaw_task races
Message-ID: <20111103004350.GA4417@google.com>
References: <20111101021511.GP18855@google.com>
 <201111030120.42102.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111030120.42102.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 01:20:41AM +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 01, 2011, Tejun Heo wrote:
> > From: Oleg Nesterov <oleg@redhat.com>
> > 
> > wait_event_freezable() and friends stop the waiting if try_to_freeze()
> > fails. This is not right, we can race with __thaw_task() and in this
> > case
> > 
> > 	- wait_event_freezable() returns the wrong ERESTARTSYS
> > 
> > 	- wait_event_freezable_timeout() can return the positive
> > 	  value while condition == F
> > 
> > Change the code to always check __retval/condition before return.
> > 
> > Note: with or without this patch the timeout logic looks strange,
> > probably we should recalc timeout if try_to_freeze() returns T.
> > 
> > tj: Updated to apply to wait_event_freezekillable() too.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > Acked-by: Tejun Heo <tj@kernel.org>
> 
> Applied to linux-pm/linux-next.

Just in case, this patch isn't correct with preceding patches (the
freezer update patchset), so should only be applied after them.

Thanks.

-- 
tejun
