Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1BPIkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:40:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54926 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1BPIj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D50mOnX2YXSBy2hc9UuMEKxLdJm9zQkAmXkcY3drI0CSMve937/WUlrQVajItMuQco
         bv1VGmVk9VbV9H1iB520dwbMQuXItB41G+SE4TqejroqYYOB8YRbAW7x48/LghoWxrgy
         J9aSmC+B33svr1po5dd2qXqqpxJanfyGbgws0=
Date: Wed, 16 Feb 2011 09:39:51 +0100
From: Tejun Heo <tj@kernel.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>,
        device-mapper development <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
 read-write for read-only mappings
Message-ID: <20110216083951.GC19830@htj.dyndns.org>
References: <4D5A6EF4.3030905@redhat.com>
 <20110215124629.GF5825@agk-dp.fab.redhat.com>
 <20110215152033.GK3160@htj.dyndns.org>
 <20110215154625.GG5825@agk-dp.fab.redhat.com>
 <20110215155018.GM3160@htj.dyndns.org>
 <4D5AA45C.7050600@redhat.com>
 <20110215161228.GN3160@htj.dyndns.org>
 <4D5AAB8F.50901@redhat.com>
 <20110215164128.GQ3160@htj.dyndns.org>
 <4D5AB0C5.9030304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5AB0C5.9030304@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 05:58:45PM +0100, Milan Broz wrote:
> # blockdev --setrw /dev/sd[bcde]
> # mdadm -A /dev/md0 /dev/sd[bcde]
> mdadm: /dev/md0 has been started with 4 drives.
> # mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
> # blockdev --setro /dev/sd[bcde]
> # mdadm -A /dev/md0 /dev/sd[bcde]
> mdadm: cannot re-read metadata from /dev/sdb - aborting
> 
> Works on 2.6.36.

Isn't failing to assemble rw array from ro devices the expected
behavior?  I think I'd want that to fail.  Neil, what do you think?

-- 
tejun
