Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab2FYQkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 12:40:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52427 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab2FYQkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 12:40:40 -0400
Date: Mon, 25 Jun 2012 09:40:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk: Revert the buffered-printk() changes for now
Message-ID: <20120625164033.GA14000@kroah.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
 <20120622145402.8047a669.akpm@linux-foundation.org>
 <20120623061313.GA21895@gmail.com>
 <1340452052.1784.40.camel@mop>
 <20120625090933.GD24512@gmail.com>
 <CAPXgP10E7HNDQ73ZFyb4EyDVBko2yXs8Rw0KOSKukGUpSBSz_g@mail.gmail.com>
 <20120625140748.GB1301@gmail.com>
 <1340635734.27036.327.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340635734.27036.327.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 10:48:54AM -0400, Steven Rostedt wrote:
> On Mon, 2012-06-25 at 16:07 +0200, Ingo Molnar wrote:
> 
> > System logging is an arguably secondary role, and it should not 
> > degrade printk()s primary role.
> 
> I would argue that printk() should not play the role of normal system
> logging. It's main role should be for boot up and crashes. If devices
> need to log information to userspace, it should really use some other
> means. What was /sys made for anyway?

Specifically not for logging.  See the very old discussions of this a
long time ago (back in the 2.5 days), if you are curious.

printk() is the best thing we have for logging as everyone uses it and
the information in it is exactly what userspace wants to know about.
Because of that, why wouldn't we use it?

Anyway, your "never buffer printk data" patch looks like the right
solution here, I'm guessing you are going to respin it based on the
feedback so far, right?

thanks,

greg k-h
