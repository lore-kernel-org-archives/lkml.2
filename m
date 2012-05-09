Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab2EIRl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:41:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60767 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab2EIRlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:41:20 -0400
Date: Wed, 9 May 2012 10:41:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
Message-ID: <20120509174114.GE24636@google.com>
References: <20120507215518.GN19417@google.com>
 <Pine.LNX.4.44L0.1205081448590.1164-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1205081448590.1164-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 08, 2012 at 02:53:11PM -0400, Alan Stern wrote:
> On Mon, 7 May 2012, Tejun Heo wrote:
> 
> > On Mon, May 07, 2012 at 05:51:52PM -0400, Alan Stern wrote:
> > > I guess in the end it's a question of balance.  Which has more 
> > > overhead, adding a few function calls here and there, or adding a new 
> > > flags field to every struct attribute?
> > 
> > Yes, and there are different types of overheads.  I'm happy to trade
> > some runtime memory overhead under debugging mode for lower code
> > complexity.  Lock proving is pretty expensive anyway.  I don't think
> > there's much point in trying to optimize some bytes from struct
> > attributes.
> 
> Okay, then what do you think about this approach?  It does seem smaller 
> and simpler than the previous attempt.
> 
> And I did try to avoid unnecessary bloat; if lockdep isn't being used
> then the extra attribute flag isn't present.

Yeap, looks good to me.

Thanks.

-- 
tejun
