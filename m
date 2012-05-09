Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638Ab2EIRrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:47:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35053 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754924Ab2EIRrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:47:35 -0400
Date: Wed, 9 May 2012 13:47:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
In-Reply-To: <20120509174114.GE24636@google.com>
Message-ID: <Pine.LNX.4.44L0.1205091346070.1658-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Tejun Heo wrote:

> Hello,
> 
> On Tue, May 08, 2012 at 02:53:11PM -0400, Alan Stern wrote:
> > On Mon, 7 May 2012, Tejun Heo wrote:
> > 
> > > On Mon, May 07, 2012 at 05:51:52PM -0400, Alan Stern wrote:
> > > > I guess in the end it's a question of balance.  Which has more 
> > > > overhead, adding a few function calls here and there, or adding a new 
> > > > flags field to every struct attribute?
> > > 
> > > Yes, and there are different types of overheads.  I'm happy to trade
> > > some runtime memory overhead under debugging mode for lower code
> > > complexity.  Lock proving is pretty expensive anyway.  I don't think
> > > there's much point in trying to optimize some bytes from struct
> > > attributes.
> > 
> > Okay, then what do you think about this approach?  It does seem smaller 
> > and simpler than the previous attempt.
> > 
> > And I did try to avoid unnecessary bloat; if lockdep isn't being used
> > then the extra attribute flag isn't present.
> 
> Yeap, looks good to me.

Unless there are any objections from Eric or Peter in the next few
days, I'll submit it.  Can I add your Acked-by?

Alan Stern

