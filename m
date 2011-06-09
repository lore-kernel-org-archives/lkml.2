Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1FIJOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:14:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48897 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1FIJOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r6/AfDHjXC8llG5uOylTSk0urlMmTTdnaDCFf53W0KrfpJARYLrEY5e16GKvMRxeVq
         lEOucG0CQFCXHiMBwVtz7ZQPXOwut1TK/M1XbPRYiskDw6FmHKG1viHVO3QCSpqBFkUS
         gYqulTV9kTsSEXi1rgU27DejcxAaINpi6C2rA=
Date: Thu, 9 Jun 2011 11:14:33 +0200
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mark Wu <dwu@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
Message-ID: <20110609091433.GB11773@htj.dyndns.org>
References: <1306913069-23637-1-git-send-email-dwu@redhat.com>
 <87mxi1xfz0.fsf@rustcorp.com.au>
 <4DEF744D.9040702@redhat.com>
 <87mxhrgba6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mxhrgba6.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 09, 2011 at 08:51:05AM +0930, Rusty Russell wrote:
> On Wed, 08 Jun 2011 09:08:29 -0400, Mark Wu <dwu@redhat.com> wrote:
> > Hi Rusty,
> > Yes, I can't figure out an instance of disk probing in parallel either, but as
> > per the following commit, I think we still need use lock for safety. What's your opinion?
> > 
> > commit 4034cc68157bfa0b6622efe368488d3d3e20f4e6
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Sat Feb 21 11:04:45 2009 +0900
> > 
> >     [SCSI] sd: revive sd_index_lock
> > 
> >     Commit f27bac2761cab5a2e212dea602d22457a9aa6943 which converted sd to
> >     use ida instead of idr incorrectly removed sd_index_lock around id
> >     allocation and free.  idr/ida do have internal locks but they protect
> >     their free object lists not the allocation itself.  The caller is
> >     responsible for that.  This missing synchronization led to the same id
> >     being assigned to multiple devices leading to oops.
> 
> I'm confused.  Tejun, Greg, anyone can probes happen in parallel?
> 
> If so, I'll have to review all my drivers.

Unless async is explicitly used, probe happens sequentially.  IOW, if
there's no async_schedule() call, things won't happen in parallel.
That said, I think it wouldn't be such a bad idea to protect ida with
spinlock regardless unless the probe code explicitly requires
serialization.

Thanks.

-- 
tejun
