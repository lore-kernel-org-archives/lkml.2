Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab1HRRia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:38:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab1HRRi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:38:28 -0400
Date: Thu, 18 Aug 2011 19:35:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] apm-emulation: use wait_event_freezable() instead of
	freezer_[do_not_]count()
Message-ID: <20110818173511.GB6910@redhat.com>
References: <20110818080653.GF13572@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818080653.GF13572@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

The patch looks fine even if I know nothing about this code.

But I have a bit off-topic question,

On 08/18, Tejun Heo wrote:
>
> vfork is moving away from freezer_[do_not_]count() one way or the
> other

Yes, I think we should do this in any case.

> Use wait_event_freezable() instead.
>
> The only annoyance is that wait_event_freezable() wakes up with
> -ERESTART if there are pending signals

IOW, we do not have wait_event_freezable_uninterruptible/etc.

Perhaps we can introduce TASK_FREEZABLE ? It should be used along
with TASK_UNINTERRUPTIBLE (like TASK_WAKEKILL). freeze_task() can
use TASK_INTERRUPTIBLE | FREEZABLE for wake_up.

vfork() can use FREEZABLE too (although this is not needed in the
long term, we should teach it to sleep in TASK_INTERRUPTIBLE).



But I feel you are going to reimplement freezer completely, in this
case please ignore.

Oleg.

