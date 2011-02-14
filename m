Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1BNPoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:44:39 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43018 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1BNPof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:44:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lfFiNUxdx/oFOGOuCb2k9XIFCCDffEWx8GstlVGX/yCeV4iE7FPMdmPGn1kqkxv6dw
         d91cym8a+g5K3IxnUyN/I2OU4TeIQp8HNVYmq2gUC+pnfim67F6pgaLgtEbJyMsQdRkJ
         fuzSBbPogh/9XQX7IDmz+NoIr+3oXfMH0lobw=
Date: Mon, 14 Feb 2011 16:44:30 +0100
From: Tejun Heo <tj@kernel.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH][RFC] dm: Do not open log and cow device read-write for
 read-only mappings
Message-ID: <20110214154430.GR18742@htj.dyndns.org>
References: <4D573BBB.6090200@redhat.com>
 <1297594735-5593-1-git-send-email-tm@tao.ma>
 <4D57E67E.1030707@redhat.com>
 <4D57F357.6060708@tao.ma>
 <4D580A8B.5050508@redhat.com>
 <20110214103026.GA18742@htj.dyndns.org>
 <4D591664.6090203@redhat.com>
 <4D592AD1.6020500@redhat.com>
 <20110214140940.GM18742@htj.dyndns.org>
 <4D593AD8.7070901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D593AD8.7070901@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 14, 2011 at 03:23:20PM +0100, Milan Broz wrote:
> >> I am not sure if this is complete fix... note that:
> >> - what happens during mirror resync and read-only log?
> >> - for COW, it there situation we need to update header in read-oly mode? (invalidated snap?)
> > 
> > But if the underlying device is marked ro, dm shouldn't update it at
> > all.  The device should be opened ro and ro policy should be enforced.
> 
> Sure. So we need to check these situations I described.

Yeap, it seems dm folks are gonna take care of dm part.

> Btw the same pattern is in MD code in lock_rdev() ...

Indeed, cc'ing Neil.  Hi, the whole thread can be read from the
following URL.

  http://thread.gmane.org/gmane.linux.kernel/1099399/focus=1099735

blkdev_get() now rejects rw open of devices which are marked
read-only.  I think the right thing to do would be opening the member
devices ro if the array is assembled for ro access (similar to Milan's
patch for dm).  How does that sound?

Thanks.

-- 
tejun
