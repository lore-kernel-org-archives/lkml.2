Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab1DMUAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:00:10 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40125 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab1DMUAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vxaQYVGazQxUAAltl5VaB8FeUFy99Zg8wwZfjTu451k5BtXjfmXU+m2lMIirAKa81+
         y0hN8+9YtDwkFkdfpWc5jTNs5wMpML64Q7lO/AXdUYsj5dmVz26wXZ37oCfOlH9qVdMj
         CgyRAkd6F+AV2Jhl/gLubkxnKGbbRJYMKOE9U=
Date: Thu, 14 Apr 2011 05:00:00 +0900
From: Tejun Heo <tj@kernel.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110413200000.GG3987@mtj.dyndns.org>
References: <20110404211604.GB6133@sucs.org>
 <20110406130423.GE4142@mtj.dyndns.org>
 <20110406212611.GA5131@sucs.org>
 <20110406213718.GA14139@mtj.dyndns.org>
 <20110409093449.GA10016@sucs.org>
 <20110410145920.GA3408@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110410145920.GA3408@sucs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sitsofe.

Sorry about late replay.  I've been and still am travelling.  :-(

On Sun, Apr 10, 2011 at 03:59:20PM +0100, Sitsofe Wheeler wrote:
> Shortly after saying this the problem reappeared by itself. I've found a
> method to reproduce it too: by running
> for i in `seq 1 100`; do udevadm trigger --subsystem-match=block ; done
> and then waiting at the desktop for a five or so minutes (so the
> requests that are backed up drain away) then running it again etc. the
> problem will usually trigger. The warning is still here in the most
> recent 2.6.39-rc2-00120-g94c8a98 kernel too. Applying the patch to the
> first kernel that showed th problem doesn't fix the issue (although it
> appears to make the issue a lot more difficult to trigger).

Thanks a lot for finding out the test case.  I'll see whether I can
reproduce the problem in qemu.

> I will note that by EeePC's onboard "gen-0" SSD mysteriously developed
> bad blocks after all this so perhaps the above is especially stressful
> for disks...

Yeah, it probably hammers the same sector over and over again.
Earlier/cheap SSDs often lack proper wear leveling and writing
repeatedly to the same sector can easily create bad blocks.  Sorry
about that.

Thanks.

-- 
tejun
