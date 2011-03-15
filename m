Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1COQ5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:57:44 -0400
Received: from fieldses.org ([174.143.236.118]:60203 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab1COQ5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:57:43 -0400
Date: Tue, 15 Mar 2011 12:57:39 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: roel <roel.kluin@gmail.com>, Neil Brown <neilb@suse.de>,
        linux-nfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: svc_register error overwritten in next
 iteration
Message-ID: <20110315165739.GB32635@fieldses.org>
References: <4D7B74C7.7060506@gmail.com>
 <20110314223645.GL25442@fieldses.org>
 <13D041DB-A26D-4EC1-A585-7DBA266CF18A@oracle.com>
 <20110315161301.GA32635@fieldses.org>
 <C9DC5C29-0641-4B34-A6CD-1BD148ACB26D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C9DC5C29-0641-4B34-A6CD-1BD148ACB26D@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 12:54:01PM -0400, Chuck Lever wrote:
> 
> On Mar 15, 2011, at 12:13 PM, J. Bruce Fields wrote:
> > The current code was failing iff the last registration returns an error.
> > We list the nfs program before the acl program in this list, so nfsd
> > registration was failing iff the acl program failed, which makes no
> > sense whatsoever.
> > 
> > I think "all or none" would be cleanest.
> > 
> > If people start complaining that they don't want to run rpcbind/portmap
> > then we could give them some way of requesting that instead of just
> > depending on allowing the registration to fail.
> 
> I thought vs_hidden was set for NFSACL... but maybe I was wrong about that.

Oh, I forgot about that.

But, checking....  Actually, it looks like it's not set for NFSACL--from
a quick grep, it appears that only the callback server sets it.

> > For cleanup, we can just unregister everything, right?  (No harm in
> > possibly unregistering something who's registration just failed?)
> 
> Yes.  As a simple hard-headed approach, probably you should walk the passed-in sv_program list again and unregister each item in the list.  The downside to this is if the upcall is taking a long time (for instance, if networking is not available).  It would double the amount of time for svc_register() to return a failure.
> 
> However, be prepared: I bet such a change could expose bugs in the NFSD start up stack.

There are so many to expose.

> :-(  Maybe it deserves some soak-time in linux-next.

Sure.

--b.
