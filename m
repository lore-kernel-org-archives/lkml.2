Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1HSO2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:28:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35692 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1HSO2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:28:44 -0400
Date: Fri, 19 Aug 2011 16:28:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] apm-emulation: use wait_event_freezable() instead of
 freezer_[do_not_]count()
Message-ID: <20110819142839.GH20085@htj.dyndns.org>
References: <20110818080653.GF13572@htj.dyndns.org>
 <20110818173511.GB6910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818173511.GB6910@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 18, 2011 at 07:35:11PM +0200, Oleg Nesterov wrote:
> > Use wait_event_freezable() instead.
> >
> > The only annoyance is that wait_event_freezable() wakes up with
> > -ERESTART if there are pending signals
> 
> IOW, we do not have wait_event_freezable_uninterruptible/etc.

Yeap, we can add it but let's leave it alone for now.

> Perhaps we can introduce TASK_FREEZABLE ? It should be used along
> with TASK_UNINTERRUPTIBLE (like TASK_WAKEKILL). freeze_task() can
> use TASK_INTERRUPTIBLE | FREEZABLE for wake_up.
> 
> vfork() can use FREEZABLE too (although this is not needed in the
> long term, we should teach it to sleep in TASK_INTERRUPTIBLE).
> 
> But I feel you are going to reimplement freezer completely, in this
> case please ignore.

Hmmm... yeah, I just posted preparation patches for the freezer and
will now try to integrate with the rest of job control stuff.  Not
quite sure how it would turn out yet.  Let's see.

Thank you.

-- 
tejun
