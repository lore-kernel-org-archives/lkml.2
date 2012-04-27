Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab2D0QJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:09:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53266 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2D0QJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:09:07 -0400
Date: Fri, 27 Apr 2012 09:09:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
Message-ID: <20120427160902.GO27486@google.com>
References: <20120426221753.GF27486@google.com>
 <Pine.LNX.4.44L0.1204271147330.1690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204271147330.1690-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 27, 2012 at 11:57:02AM -0400, Alan Stern wrote:
> By the way, do you know why attribute structures allow for dynamic keys 
> as well as static keys?  I see dynamic keys are used by attribute 
> containers, but I don't understand why.

I have no idea.  Eric?

> > > Another idea is to have A's method temporarily drop the sysfs readlock.  
> > > Of course that would put the onus on the USB core of guaranteeing that
> > > A cannot be removed while this happens, but we can handle that.
> > 
> > Yeah, that's an easier way out.  Please make it a proper sysfs API
> > call tho so that people working on sysfs later can know of the special
> > case.
> 
> I will.
> 
> Would it be better to release just the lockdep annotation while
> continuing to hold the actual lock, or to really drop the lock?

Just the lockdep annotation, I think.

Thanks.

-- 
tejun
