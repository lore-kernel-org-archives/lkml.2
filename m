Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1HTB3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 21:29:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35828 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1HTB3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 21:29:45 -0400
Date: Sat, 20 Aug 2011 02:29:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Sylvain Rochet <gradator@gradator.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: PROBLEM: 2.6.35.7 to 3.0 Inotify events missing
Message-ID: <20110820012943.GD2203@ZenIV.linux.org.uk>
References: <20101018223540.GA20730@gradator.net>
 <20110819230344.GA24784@gradator.net>
 <20110819233756.GI11512@jl-vm1.vm.bytemark.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819233756.GI11512@jl-vm1.vm.bytemark.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 12:37:56AM +0100, Jamie Lokier wrote:

> Possible solution:

> Then this can be solved, in principle (if there's no better way), by
> watching a "virtual directory" that gets all events for when the
> access doesn't have a parent directory.  There needs to be some way to
> watch it, and some way to get the appropriate file from the event (as
> there is no real directory.  Or maybe there could be a virtual
> filesystem (like /proc, /sys etc.) containing a magic directory that
> receives these inode-only events, such that lookups in that directory
> yield the affected file.  Exactly as if the directory contains a hard
> link to every file, perhaps a text encoding of the handles passed
> through sys_open_by_handle_at.

There is a better way - stop using idiotify...  It has always been a
mistake, driven down our throats by filemangler and desktop crowd.
Broken in many, _many_ respects...  Deprecate that crap, remove it
completely in a couple of revisions, let these clowns cope.  Yeah,
yeah, I know...  Not going to happen ;-/  One can dream, though...
