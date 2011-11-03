Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab1KCQAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:00:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46185 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933689Ab1KCQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:00:03 -0400
Date: Thu, 3 Nov 2011 08:59:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Watts <akwatts@ymail.com>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111103155956.GG4417@google.com>
References: <20111101124759.GA1326@zeus>
 <20111102054658.GA29035@core.coreip.homeip.net>
 <20111102160208.GA6657@zeus>
 <20111102163109.GA29430@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102163109.GA29430@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 02, 2011 at 09:31:09AM -0700, Dmitry Torokhov wrote:
> On Wed, Nov 02, 2011 at 11:02:09AM -0500, Andrew Watts wrote:
> > On Tue, Nov 01, 2011 at 10:46:58PM -0700, Dmitry Torokhov wrote:
> > > 
> > > Are you hibernating from text console or X? Can you try plugging in USB
> > > keyboard and see if you are getting input? What about ssh into the box?
> > 
> > Forgot to answer a few of your questions. Plugging in a USB keyboard does
> > not help.
> 
> OK, it looks like you do have input, what you do not have is X
> functioning.
> 
> I am not sure why radeon reports lockup with that patch; serio uses
> system_long_wq to schedule its long-playing works and the only other
> user of system_long_wq seems to be sata, but then concurrency management
> should take care of them sharing the workqueue.
> 
> Tejun, do you have any ideas here?

Not at all.  Dang, I was feeling pretty sure that it was some missing
queue_work somewhere.  So, input is working fine but X locks up
because of that change?  That's just odd.

Andrew, just in case, can you please double check that you're
reverting only that single commit (not all the ones afterwards) and
the test results?  If they're all okay, can you please trigger the
problem, wait a while, trigger sysrq-t and attach the kernel log?

Thank you.

-- 
tejun
