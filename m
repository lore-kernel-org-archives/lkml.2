Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1KNKeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 05:34:14 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57219
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab1KNKeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 05:34:13 -0500
Date: Mon, 14 Nov 2011 05:34:10 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ben Myers <bpm@sgi.com>, Tejun Heo <tj@kernel.org>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20111114103410.GD31043@infradead.org>
References: <20111108085614.478431403@bombadil.infradead.org>
 <20111108085846.291838677@bombadil.infradead.org>
 <20111108231118.GP5534@dastard>
 <20111109075847.GA20604@infradead.org>
 <20111110174242.GZ20464@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110174242.GZ20464@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 11:42:42AM -0600, Ben Myers wrote:
> > +STATIC int
> > +xfs_init_mount_workqueues(
> > +	struct xfs_mount	*mp)
> > +{
> > +#define XFS_WQ_NAME_LEN		512
> > +	char			name[XFS_WQ_NAME_LEN];
> > +
> > +	snprintf(name, XFS_WQ_NAME_LEN, "xfs-data/%s", mp->m_fsname);
> > +	mp->m_data_workqueue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
> > +	if (!mp->m_data_workqueue)
> > +		goto out;
> 
> Looks to me like alloc_workqueue holds on to that name pointer in
> wq->name... won't overwriting the name below be a problem?

It applies deep magic to make sure a pattern like mine is fine for
the lockdep lock name, but just uses it directly for the workqueue name.

Oddly enough the names seem to display correctly on my test systems
anyway.

Tejun, any chance to change alloc_workqueue to use the string pasting
trick also for the normal workqueue name, or even better add a varargs
version of alloc_workqueue?

