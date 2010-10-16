Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0JPAPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:15:47 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:36066 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751714Ab0JPAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:15:46 -0400
Date: Sat, 16 Oct 2010 11:15:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] fs: rework icount to be a locked variable
Message-ID: <20101016001533.GL4681@dastard>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-8-git-send-email-david@fromorbit.com>
 <20101013113643.GD19456@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013113643.GD19456@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 07:36:43AM -0400, Christoph Hellwig wrote:
> > -		atomic_inc(&inode->i_count);
> > +		spin_lock(&inode->i_lock);
> > +		inode->i_ref++;
> > +		spin_unlock(&inode->i_lock);
> 
> Why isn't this using iref?
> 
> > +		spin_lock(&inode->i_lock);
> > +		inode->i_ref++;
> > +		spin_unlock(&inode->i_lock);
> 
> Same here and in a couple of others.
> 
> Hmm, I guess because the i_lock later covers other things around.
> But it still looks a bit weird.

Ok, I've changed them to iref() calls and convert them to open
coding later on when necessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
