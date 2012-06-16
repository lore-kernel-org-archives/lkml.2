Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2FPP10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 11:27:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39932 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2FPP1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 11:27:25 -0400
Date: Sat, 16 Jun 2012 08:27:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: Kay Sievers <kay@vrfy.org>, David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Reducing the noise level of build error notifications to 0
Message-ID: <20120616152720.GA7914@kroah.com>
References: <4fdbcd2f.Ta8kRp58FRzqrqaL%wfg@linux.intel.com>
 <20120616011646.GA7847@localhost>
 <20120616014732.GA2981@kroah.com>
 <20120616025031.GA8182@localhost>
 <20120616034420.GA3748@kroah.com>
 <20120616041144.GA8666@localhost>
 <20120616042010.GA8979@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616042010.GA8979@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 12:20:10PM +0800, Fengguang Wu wrote:
> > > How about also cc: not only the author where you mention it above, but
> > > everyone who signed-off on the patch?  That would provide a bit of peer
> > > pressure to ensure that the problems get fixed.
> > 
> > That's (interesting and) good point. If me understand you right:
> > 
> > - TO: author, CC: Signed-off-by, CC: (sub-)subsystem mailing list
> >   for build errors
> > 
> > - TO: author, CC: Signed-off-by (but sure, remove the top level busy maintainers)
> >   for gcc warnings

Well, if I sign-off on a patch, I want to know about gcc warnings that
were added by it, don't not email me just because you think I'm busy.

> Or, just remove the committer from CC: and add Reviewed-by to CC: 
> By reviewing, one should already be familiar with the patch.

I don't think you should drop the committer, but maybe that's just me.

> > - TO: author
> >   for sparse warnings (however I'm still too afraid to enable sparse checks)

This might get tougher in some areas of the kernel like the
drivers/staging/ tree where people incrementally fix things up, like fix
trailing space issues on one patch, which doesn't change the rest of the
line that might have had coding style or sparse issues in it.  That's
why I can't always run checkpatch.pl on patches sent to me, and why
sparse might not help out.

But, I'd love to see sparse run on other areas of the kernel (i.e.
anything not in drivers/staging/) hopefully it would get those areas
fixed up properly.

thanks,

greg k-h
