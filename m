Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab0J1W0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:26:14 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:47936 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752062Ab0J1W0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:26:13 -0400
Date: Fri, 29 Oct 2010 09:24:04 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, warthog9@kernel.org,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, eparis@redhat.com, viro@zeniv.linux.org.uk,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
Message-ID: <20101028222404.GG2715@dastard>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 06:02:01PM -0400, Mimi Zohar wrote:
> On Mon, 2010-10-25 at 14:41 -0400, Eric Paris wrote:
> 
> <snip>
> 
> > I believe that IBM is going to look into making i_readcount a first
> > class citizen which can be used by both IMA and generic_setlease().
> > Then people could say IMA had 0 per inode overhead   :)
> 
> This patchset separates the incrementing/decrementing of the i_readcount,
> in the VFS layer, from other IMA functionality, by replacing the current
> ima_counts_get() call with iget_readcount(). Its unclear whether this
> call to increment i_readcount should be made earlier. 

Why the wrapper functions and locking? Why not an atomic variable like
i_writecount?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
