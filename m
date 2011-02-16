Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1BPIqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:46:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35466 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab1BPIqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:46:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dwR2FRJD3ecm8QqaMjlSPX8qUraXGhjBfhd1FtnfRqmrJcWHjowHdIIvFCiRSp1zvF
         ojBkmmJenzJVooCJd5imBL2rytqjEFL2W2RGM/aPllepbTGRZSYMKvma7Xv3pgfxDLO/
         ia/uYHzqMy9gVsk/baCqnH1dG1oCsPmTyFkNM=
Date: Wed, 16 Feb 2011 09:46:15 +0100
From: Tejun Heo <tj@kernel.org>
To: Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>,
        linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
 read-write for read-only mappings
Message-ID: <20110216084615.GD19830@htj.dyndns.org>
References: <4D5A6EF4.3030905@redhat.com>
 <20110215124629.GF5825@agk-dp.fab.redhat.com>
 <20110215152033.GK3160@htj.dyndns.org>
 <20110215154625.GG5825@agk-dp.fab.redhat.com>
 <20110215155018.GM3160@htj.dyndns.org>
 <4D5AA45C.7050600@redhat.com>
 <20110215161228.GN3160@htj.dyndns.org>
 <4D5AAB8F.50901@redhat.com>
 <20110215164128.GQ3160@htj.dyndns.org>
 <20110215165618.GA28164@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215165618.GA28164@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alasdair.

On Tue, Feb 15, 2011 at 04:56:18PM +0000, Alasdair G Kergon wrote:
> On Tue, Feb 15, 2011 at 05:41:28PM +0100, Tejun Heo wrote:
> > That said, maybe -EROFS is the better fit.  I really have no idea.
> > Maybe we should just revert and leave rw accesses to ro block devices
> > alone.
>  
> I'd agree that the change to enforce readonly devs is a desirable change
> to make.  But we're still discovering exactly what things it breaks and
> as well as further kernel patches some userspace changes seem
> unavoidable.  Personally I'd prefer it if this change went back into
> linux-next to give us more time to prepare for it cleanly.  It's
> unfortunate none of us picked up on these problems sooner.

Yeah, yeah, I think we need revert.  It's a bit too late to sort this
out in this cycle, but, then again, can we ever change this?  Given
that the 'ro' part is hardly used with md, I think dm probably is the
only one which has noticeable problem with this change.

No matter when we change it, it's gonna be visible to userland.  To
me, most of the changes seem like bug fixes and pretty important ones
at that.  As it currently stands, the kernel goes behind the user's
back and issues writes to devices which the user believes to have
allowed only ro access.

So, if dm can figure out how to deal with this, it would be great.

Thanks.

-- 
tejun
