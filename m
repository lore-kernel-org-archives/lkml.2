Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0J0Ekr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 00:40:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59574 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0J0Ekk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 00:40:40 -0400
Date: Wed, 27 Oct 2010 05:40:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] fs: remove inode_lock from iput_final and
 prune_icache
Message-ID: <20101027044038.GE19804@ZenIV.linux.org.uk>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
 <1288153384-8878-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288153384-8878-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 03:23:04PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that inode state changes are protected by the inode->i_lock and
> the inode LRU manipulations by the inode_lru_lock, we can remove the
> inode_lock from prune_icache and the initial part of iput_final().
> 
> instead of using the inode_lock to protect the inode during
> iput_final, use the inode->i_lock instead. This protects the inode
> against new references being taken while we change the inode state
> to I_FREEING, as well as preventing prune_icache from grabbing the
> inode while we are manipulating it. Hence we no longer need the
> i???ode_lock in iput_final prior to setting I_FREEING on the inode.
  ^^^^^^^^^^^^

... the hell?  There's more such damage elsewhere in the thread; what's
going on?
