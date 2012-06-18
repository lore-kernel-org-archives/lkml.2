Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2FRV2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 17:28:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33133 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2FRV2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 17:28:31 -0400
Date: Mon, 18 Jun 2012 14:28:26 -0700
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Asias He <asias@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
Message-ID: <20120618212826.GB32733@google.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>
 <1340002390-3950-4-git-send-email-asias@redhat.com>
 <87hau9yse7.fsf@rustcorp.com.au>
 <4FDEE0CB.1030505@redhat.com>
 <87zk81x7dp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zk81x7dp.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Mon, Jun 18, 2012 at 07:35:22PM +0930, Rusty Russell wrote:
> On Mon, 18 Jun 2012 16:03:23 +0800, Asias He <asias@redhat.com> wrote:
> > On 06/18/2012 03:46 PM, Rusty Russell wrote:
> > > On Mon, 18 Jun 2012 14:53:10 +0800, Asias He <asias@redhat.com> wrote:
> > >> This patch introduces bio-based IO path for virtio-blk.
> > >
> > > Why make it optional?
> > 
> > request-based IO path is useful for users who do not want to bypass the 
> > IO scheduler in guest kernel, e.g. users using spinning disk. For users 
> > using fast disk device, e.g. SSD device, they can use bio-based IO path.
> 
> Users using a spinning disk still get IO scheduling in the host though.
> What benefit is there in doing it in the guest as well?

Another thing is that some of cgroup features are impelmented in IO
scheduler (cfq).  e.g. bio based driver will be able to use cgroup
based throttling but IO weights won't work.  Not sure how meaningful
this is tho.

With that said, I think this sort of feature switching is quite ugly.
The pros and cons of each choice aren't obvious unless one is familiar
with implementation details.  IMHO, if the benefits of ioscheds aren't
critical, it would be better to just go with bio based implementation.

Thanks.

-- 
tejun
