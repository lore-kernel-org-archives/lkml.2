Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab1KAAzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:55:12 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41803 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab1KAAzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:55:10 -0400
Date: Mon, 31 Oct 2011 17:55:05 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org, linux-cifs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Message-ID: <20111101005505.GO18855@google.com>
References: <20111031221743.GA18855@google.com>
 <201111010024.16659.rjw@sisk.pl>
 <20111031233059.GI18855@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031233059.GI18855@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

On Mon, Oct 31, 2011 at 04:30:59PM -0700, Tejun Heo wrote:
> I can't remember one off the top of my head but I'm pretty sure there
> at least are few which expect tight inter-locking between sleeps and
> wakeups.  I'll look for examples and post reply.  ISTR them being
> kernel threads so this might not apply directly but it's still a
> dangerous game to play.

Hmm... I couldn't find KILLABLE used like that but here are two
UNINTERRUPTIBLE sleep examples.

* kthread_start() depends on the fact that a kthread won't be woken up
  from UNINTERRUPTIBLE sleep spuriously.

* jfs_flush_journal() doesn't check whether the wakeup was spurious
  after waiting if !tblkGC_COMMITTED.

Maybe we can re-define KILLABLE as killable && freezable but IMHO that
requires pretty strong rationales.  If at all possible, let's not
diddle with that if it can be worked around some other way.

Thank you.

-- 
tejun
