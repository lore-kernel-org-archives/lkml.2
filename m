Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989Ab1FAREI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:04:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:1074 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab1FAREE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:04:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NkZ0ebNMC5hP2H2D89ZOHvEJjeJmKVVU72PBPBUdr68qAeQ94/M8+XYj9+rZApdDNM
         07Q4unm1tNtZaWePPCMA==
Date: Wed, 1 Jun 2011 10:04:00 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/14] drm/i915: adjust to new truncate_range
In-Reply-To: <20110601004314.GD4433@infradead.org>
Message-ID: <alpine.LSU.2.00.1106011002420.23468@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils> <alpine.LSU.2.00.1105301743500.5482@sister.anvils> <20110601004314.GD4433@infradead.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Christoph Hellwig wrote:

> >  	/* Our goal here is to return as much of the memory as
> >  	 * is possible back to the system as we are called from OOM.
> >  	 * To do this we must instruct the shmfs to drop all of its
> > -	 * backing pages, *now*. Here we mirror the actions taken
> > -	 * when by shmem_delete_inode() to release the backing store.
> > +	 * backing pages, *now*.
> >  	 */
> >  	inode = obj->base.filp->f_path.dentry->d_inode;
> > -	truncate_inode_pages(inode->i_mapping, 0);
> >  	if (inode->i_op->truncate_range)
> >  		inode->i_op->truncate_range(inode, 0, (loff_t)-1);
> > +	else
> > +		truncate_inode_pages(inode->i_mapping, 0);
> 
> Given that it relies on beeing on shmemfs it should just call it
> directly.

As agreed in other mail, I'll do a v2 series in a few days,
making that change - thanks.

Hugh
