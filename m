Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab2DZWR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:17:59 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:48607 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab2DZWR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 18:17:58 -0400
Date: Thu, 26 Apr 2012 15:17:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
Message-ID: <20120426221753.GF27486@google.com>
References: <m162cmewmy.fsf@fess.ebiederm.org>
 <Pine.LNX.4.44L0.1204261153320.1530-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204261153320.1530-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 02:14:30PM -0400, Alan Stern wrote:
> > > Hmmm.... This happens because, by default, sysfs_dirents for the same
> > > attr share the same lockdep key.  This happens from
> > > sysfs_dirent_init_lockdep().  Hmm.... we can,
> > >
> > > * Somehow assign different keys to sysfs_dirents for the specific
> > >   attr.  Use array of attrs indexed by bus depth?
> > 
> > Possible with sysfs_attr_init but pretty ugly.  Especially since it
> > sounds like this is a situation that does not presuppose a maximum
> > depth.  I do remember that the lockdep keys must be statically allocated
> > which makes this a challenge.

The depth is limited by USB spec.

> I agree; this doesn't seem like a good approach.

It sure isn't pretty but probably best matches the situation in the
sense that lockdep would actually be able to know about the nesting
going on.

> Another idea is to have A's method temporarily drop the sysfs readlock.  
> Of course that would put the onus on the USB core of guaranteeing that
> A cannot be removed while this happens, but we can handle that.

Yeah, that's an easier way out.  Please make it a proper sysfs API
call tho so that people working on sysfs later can know of the special
case.

Thanks.

-- 
tejun
