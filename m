Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab0GVEQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 00:16:06 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:12080 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab0GVEQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 00:16:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKJiR0x5Lc6U/2dsb2JhbACfdHLBVoUyBA
Date: Thu, 22 Jul 2010 14:15:54 +1000
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Add a dentry op to handle automounting rather
 than abusing follow_link
Message-ID: <20100722041554.GB3446@amd>
References: <27282.1279058150@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27282.1279058150@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This hasn't had much comments yet.

On Tue, Jul 13, 2010 at 10:55:50PM +0100, David Howells wrote:
> 
> Add a dentry op (d_automount) to handle automounting directories rather than
> abusing the follow_link() inode operation.
> 
> I've only changed __follow_mount() to handle automount points, but it might be
> necessary to change follow_mount() too.  The latter is only used from
> follow_dotdot(), but any automounts on ".." should be pinned whilst we're using
> a child of it.
> 
> AFS is made to use this facility so that it can be tested.  Other filesystems
> abusing the follow_mount() inode operation will also need to be modified.

How about having a .follow_mount op, and using that instead of
default follow_mount in case mounted is incremented?

Also I would prefer the patch to add this call keep basically the
same API as follow_mount, so if you are going to change that to
return an error and do the NOFOLLOW handling in there, then
could you do that first, as a more trivial patch?

Then your addition of the d_op should not touch outside
*follow_mount.

