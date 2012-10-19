Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab2JSB3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:29:52 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43126 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2JSB3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:29:50 -0400
Date: Thu, 18 Oct 2012 18:29:45 -0700
From: Matt Helsley <matthltc@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Matt Helsley <matthltc@linux.vnet.ibm.com>, rjw@sisk.pl, oleg@redhat.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Message-ID: <20121019012945.GD6223@us.ibm.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <20121017191606.GA6223@us.ibm.com>
 <20121018211434.GI13370@google.com>
 <20121018222155.GB6223@us.ibm.com>
 <20121018223517.GQ13370@google.com>
 <20121018234726.GC6223@us.ibm.com>
 <20121019000153.GZ13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019000153.GZ13370@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101901-7606-0000-0000-0000049F7ECE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 05:01:53PM -0700, Tejun Heo wrote:

<snip>
> I probably have chosen the wrong word.  I mean that it's a hierarchy
> management feature implemented at the wrong layer.  If we want to
> provide cgroup migration locking, it should be implemented at the
> cgroup core layer as a controller independent feature.  It's kinda
> interesting the incorrect layering here almost directly caused messy
> locking problem too.  I hope we don't need it with (the imaginary)
> proper userland arbitration but even if we do implementing it in
> cgroup proper as a separate feature would be a lot less messy.

Yeah, that would be a nice cleanup too. I guess the ultra-careful way to
remove this feature would be something like:

	Add an internal migration restriction (which may or may not be
		exported as a userspace interface in a subsequent
		patch).

	Make the cgroup freezer use it.

	Make the cgroup freezer WARN_ONCE() when the subsystem is first
		mounted. Indicates that the behavior is going to
		change.

	... time passes ...

	Remove the use of the migration "lock" from the cgroup freezer
		and the WARN_ONCE().

Which would also make the feature more obvious.

Cheers,
	-Matt

