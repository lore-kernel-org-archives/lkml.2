Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1EaUVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:21:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35348 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758396Ab1EaUVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:21:38 -0400
Date: Tue, 31 May 2011 21:21:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        chris.mason@oracle.com, josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write v2
Message-ID: <20110531202135.GP11521@ZenIV.linux.org.uk>
References: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
 <1306849896.2816.22.camel@menhir>
 <20110531180643.GB9261@alboin.amr.corp.intel.com>
 <1306867346.2816.49.camel@menhir>
 <20110531200750.GO11521@ZenIV.linux.org.uk>
 <20110531201834.GB27166@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531201834.GB27166@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 10:18:34PM +0200, Andi Kleen wrote:
> On Tue, May 31, 2011 at 09:07:50PM +0100, Al Viro wrote:
> > On Tue, May 31, 2011 at 07:42:26PM +0100, Steven Whitehouse wrote:
> > 
> > > Yes, it should test for xattr too,
> > 
> > Frankly, I suspect that the sanest way to handle that is this:
> > 	* new superblock flag - MS_NOSEC
> > 	* S_NOSEC is never set unless we have MS_NOSEC
> > 	* mount_bdev() sets it before calling fill_super callback.
> > 	* ocfs2 and fuse *clear* it in their fill_super
> 
> gfs2 needs to clear it too (unless Steven's updated patch goes in too)
> Steven?

gfs2 doesn't use mount_bdev(), so there's nothing that would set it (we
never pass it set in flags - mount(2) clears all but user-settable bits).
