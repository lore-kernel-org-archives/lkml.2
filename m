Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1HTBnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 21:43:17 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:52165 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751156Ab1HTBnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 21:43:14 -0400
Date: Fri, 19 Aug 2011 18:43:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>, Sylvain Rochet <gradator@gradator.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org
Subject: Re: PROBLEM: 2.6.35.7 to 3.0 Inotify events missing
Message-Id: <20110819184311.b094d6b7.rdunlap@xenotime.net>
In-Reply-To: <20110820012943.GD2203@ZenIV.linux.org.uk>
References: <20101018223540.GA20730@gradator.net>
	<20110819230344.GA24784@gradator.net>
	<20110819233756.GI11512@jl-vm1.vm.bytemark.co.uk>
	<20110820012943.GD2203@ZenIV.linux.org.uk>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Aug 2011 02:29:43 +0100 Al Viro wrote:

> On Sat, Aug 20, 2011 at 12:37:56AM +0100, Jamie Lokier wrote:
> 
> > Possible solution:
> 
> > Then this can be solved, in principle (if there's no better way), by
> > watching a "virtual directory" that gets all events for when the
> > access doesn't have a parent directory.  There needs to be some way to
> > watch it, and some way to get the appropriate file from the event (as
> > there is no real directory.  Or maybe there could be a virtual
> > filesystem (like /proc, /sys etc.) containing a magic directory that
> > receives these inode-only events, such that lookups in that directory
> > yield the affected file.  Exactly as if the directory contains a hard
> > link to every file, perhaps a text encoding of the handles passed
> > through sys_open_by_handle_at.
> 
> There is a better way - stop using idiotify...  It has always been a
> mistake, driven down our throats by filemangler and desktop crowd.
> Broken in many, _many_ respects...  Deprecate that crap, remove it
> completely in a couple of revisions, let these clowns cope.  Yeah,
> yeah, I know...  Not going to happen ;-/  One can dream, though...

What do you suggest as a functioning alternative to inotify?

---
~Randy
