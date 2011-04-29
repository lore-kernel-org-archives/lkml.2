Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab1D2IQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:16:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56635 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab1D2IP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=roId6CkKEjye8CBcCmTBW+J/HLtds5iZuhQCzPUJKXoFMuVreC2p+fKhA5X4DiYWVX
         uzU+HwVQgjSpkm0dfjUHM2I8h1a1HdboNoZf4tIWj/itwdLmSaIAbV/N4uvTZpvmGIX/
         pB4Mu4mtCChVkINadfxNHKvZEMSZ/1fiV6ZKI=
Date: Fri, 29 Apr 2011 10:15:49 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Amit Shah <amit.shah@redhat.com>
Cc: David Zeuthen <zeuthen@gmail.com>, Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cdrom: always check_disk_change() on open
Message-ID: <20110429081549.GH16552@htj.dyndns.org>
References: <20110406121920.GC4142@mtj.dyndns.org>
 <20110429060200.GA5107@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429060200.GA5107@amit-x200.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 12:27:18PM +0530, Amit Shah wrote:
> On (Wed) 06 Apr 2011 [05:20:09], Tejun Heo wrote:
> > cdrom_open() called check_disk_change() after the rest of open path
> > succeeded which leads to the following bizarre behavior.
> > 
> > * After media change, if the device opened without O_NONBLOCK,
> >   open_for_data() naturally fails with -ENOMEDIA and
> >   check_disk_change() is never called.  The media is known to be gone
> >   and the open failure makes it obvious to the userland but device
> >   invalidation never happens.
> > 
> > * But if the device is opened with O_NONBLOCK, all the checks are
> >   bypassed and cdrom_open() doesn't notice that the media is not there
> >   and check_disk_change() is called and invalidation happens.
> > 
> > There's nothing to be gained by avoiding calling check_disk_change()
> > on open failure.  Common cases end up calling check_disk_change()
> > anyway.  All we get is inconsistent behavior.
> > 
> > Fix it by moving check_disk_change() invocation to the top of
> > cdrom_open() so that it always gets called regardless of how the rest
> > of open proceeds.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Amit Shah <amit.shah@redhat.com>
> > Tested-by: Amit Shah <amit.shah@redhat.com>
> 
> Ping?
> 
> Also, please mark this for stable-2.6.38.

Jens?

-- 
tejun
