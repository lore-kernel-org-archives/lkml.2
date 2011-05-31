Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab1EaUSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:18:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57275 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1EaUSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:18:38 -0400
Date: Tue, 31 May 2011 22:18:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Steven Whitehouse <swhiteho@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
        josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write v2
Message-ID: <20110531201834.GB27166@one.firstfloor.org>
References: <1306596354-18453-1-git-send-email-andi@firstfloor.org> <1306849896.2816.22.camel@menhir> <20110531180643.GB9261@alboin.amr.corp.intel.com> <1306867346.2816.49.camel@menhir> <20110531200750.GO11521@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531200750.GO11521@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 09:07:50PM +0100, Al Viro wrote:
> On Tue, May 31, 2011 at 07:42:26PM +0100, Steven Whitehouse wrote:
> 
> > Yes, it should test for xattr too,
> 
> Frankly, I suspect that the sanest way to handle that is this:
> 	* new superblock flag - MS_NOSEC
> 	* S_NOSEC is never set unless we have MS_NOSEC
> 	* mount_bdev() sets it before calling fill_super callback.
> 	* ocfs2 and fuse *clear* it in their fill_super

gfs2 needs to clear it too (unless Steven's updated patch goes in too)
Steven?

> 	* btrfs manually sets it in its ->mount()

Looks good. I haven't test it so far though.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi

