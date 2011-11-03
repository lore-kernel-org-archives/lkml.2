Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab1KCPHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:07:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39648 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab1KCPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:07:14 -0400
Date: Thu, 3 Nov 2011 08:07:08 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH pm] freezer: fix wait_event_freezable/__thaw_task races
Message-ID: <20111103150708.GC4417@google.com>
References: <20111101021511.GP18855@google.com>
 <201111030201.27551.rjw@sisk.pl>
 <CAOS58YN4eQ5qfGXCjciGKvv13boSKQJso2U=x5rLw8c7vNeGWQ@mail.gmail.com>
 <201111031143.13836.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111031143.13836.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Thu, Nov 03, 2011 at 11:43:13AM +0100, Rafael J. Wysocki wrote:
> On Thursday, November 03, 2011, Tejun Heo wrote:
> > Hello,
> > 
> > On Wed, Nov 2, 2011 at 6:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > OK, so I guess I should drop it from my linux-next branch?
> > 
> > Hmmm... yes, the preceding patches should be applied first and then
> > this one. Any problems with earlier ones?
> 
> The only problem I currently have is to figure out what patches to apply
> and in which order.  Care to help? ;-)

Heh, sorry about that, so to sum up the outstanding patches.

for-fixes (current merge window)

 [1] wait_event_freezekillable: use freezer_do_not_count/freezer_count
 [2] freezer: revert 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake TASK_KILLABLE tasks too"

  It would be a good idea to note that the first patch makes thes
  change made by commit 27920651fe and thus reverting is safe.

for-next

 [3] freezer: fix various bugs and simplify implementation, take#2
 [4] usb_storage: don't use set_freezable_with_signal()
 [5] freezer: kill unused set_freezable_with_signal()
 [6] freezer: fix wait_event_freezable/__thaw_task races

All the for-next patches are in the following git branch in the above
order.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-fix-wait_freezable

Thank you.

-- 
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.cifs/4823/focus=4864
[2] http://thread.gmane.org/gmane.linux.kernel.cifs/4823
[3] http://thread.gmane.org/gmane.linux.kernel/1209247
[4] http://thread.gmane.org/gmane.linux.kernel/1209416
[5] http://thread.gmane.org/gmane.linux.kernel/1209416/focus=1209417
[6] http://thread.gmane.org/gmane.linux.kernel/1209444
