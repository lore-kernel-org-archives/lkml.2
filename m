Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1KNSOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 13:14:00 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33061 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab1KNSN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 13:13:59 -0500
Date: Mon, 14 Nov 2011 10:13:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20111114181353.GC30922@google.com>
References: <20111108085614.478431403@bombadil.infradead.org>
 <20111108085846.291838677@bombadil.infradead.org>
 <20111108231118.GP5534@dastard>
 <20111109075847.GA20604@infradead.org>
 <20111110174242.GZ20464@sgi.com>
 <20111114103410.GD31043@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111114103410.GD31043@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Mon, Nov 14, 2011 at 05:34:10AM -0500, Christoph Hellwig wrote:
> On Thu, Nov 10, 2011 at 11:42:42AM -0600, Ben Myers wrote:
> > > +STATIC int
> > > +xfs_init_mount_workqueues(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +#define XFS_WQ_NAME_LEN		512
> > > +	char			name[XFS_WQ_NAME_LEN];
> > > +
> > > +	snprintf(name, XFS_WQ_NAME_LEN, "xfs-data/%s", mp->m_fsname);
> > > +	mp->m_data_workqueue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
> > > +	if (!mp->m_data_workqueue)
> > > +		goto out;
> > 
> > Looks to me like alloc_workqueue holds on to that name pointer in
> > wq->name... won't overwriting the name below be a problem?
> 
> It applies deep magic to make sure a pattern like mine is fine for
> the lockdep lock name, but just uses it directly for the workqueue name.

For lockdep lock name, it isn't about reusing but ensuring that same
lockdep key doesn't end up with different names which lockdep doesn't
allow.  But yeah, given that workqueue is dynamically allocated, it's
a bit silly to require the name to be constant.

> Oddly enough the names seem to display correctly on my test systems
> anyway.
> 
> Tejun, any chance to change alloc_workqueue to use the string pasting
> trick also for the normal workqueue name, or even better add a varargs
> version of alloc_workqueue?

Yeah, will whip something up.

Thanks.

-- 
tejun
