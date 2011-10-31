Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1JaXbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:31:07 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57748 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab1JaXbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:31:04 -0400
Date: Mon, 31 Oct 2011 16:30:59 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org, linux-cifs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Message-ID: <20111031233059.GI18855@google.com>
References: <20111031221743.GA18855@google.com>
 <201111010024.16659.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111010024.16659.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 01, 2011 at 12:24:16AM +0100, Rafael J. Wysocki wrote:
> > This is probably okay for most cases but circumventing fundamental
> > wakeup condition like this is asking for trouble.  Furthermore, I'm
> > not sure the behavior change brought on by this change - breaking
> > nfs/cifs uninterruptible operation guarantee - is correct.  If such
> > behavior is desirable, the right thing to do is using intr mount
> > option, not circumventing it from PM layer.
> 
> Do you have any specific examples of breakage, or is it just that you _think_
> it's not quite right?

I can't remember one off the top of my head but I'm pretty sure there
at least are few which expect tight inter-locking between sleeps and
wakeups.  I'll look for examples and post reply.  ISTR them being
kernel threads so this might not apply directly but it's still a
dangerous game to play.

Bugs caused by behaviors like this will be very difficult to reproduce
and diagnose.  There is no reason to play a gamble like this.  If
somebody *really* wants non-interruptible killable & freezable sleep,
we really should be adding TASK_WAKE_FREEZER or something instead of
modifying the behavior of TASK_KILLABLE.

Thanks.

-- 
tejun
