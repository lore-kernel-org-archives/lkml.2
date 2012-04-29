Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2D2CAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 22:00:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38881 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753016Ab2D2CAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 22:00:03 -0400
Date: Sat, 28 Apr 2012 22:00:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
In-Reply-To: <878vhg3mrh.fsf@xmission.com>
Message-ID: <Pine.LNX.4.44L0.1204282153520.6752-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012, Eric W. Biederman wrote:

> However it would be nice if we could sort out the locking so that it
> isn't so tricky that neither lockdep nor sparse can figure it out.
> 
> I have the sneaking suspicion that idioms that tangle up our automatic
> tools are also idioms that are likely to result in maintenance problems
> at some point.

That may well be true, but it won't be easy to avoid them.  At the
least, it would require a careful analysis of the device tree usage.

> Another possibility to to look at the situation and realize that pci has
> a maxium depth of 256 (bus numbers). And that usb also has a maxium
> depth of I believe 256 ( If I read it right usb hubs are transparent to
> usb enumeration so the maximum depth is the maximum number of usb ids
> and I think the usb id is a 8 bit number).

USB has a maximum depth of 7 or so.  It's limited by the number of hubs 
allowed on the path between the host and a device.

>  I don't think anything else
> even nests so deeply.  So it may be reasonable to declare an array of
> 256 or perhaps 1024 lockdep keys and limit the device tree when lockdep
> is enabled to 1024 layers deep.
> 
> At which point we are at a point where lockdep can actually analyze the
> behavior.

Unfortunately, we are not.  As I mentioned earlier, the device "tree" 
is really a forest.  Locks are sometimes acquired in orders that are 
not strictly downward.

> I don't mind the attitude we are clever careful programmers we can
> handle the complexity and we can get away without the tool help us, but
> I would much rather see the attitude that we are clever careful
> programmers and we can figure out how to make the tool help us instead
> of just ignoring it.

I'm certainly open to suggestions as to how to improve the situation, 
but the simple-minded "keep track of the depth in the tree" approach 
doesn't work.

Alan Stern

