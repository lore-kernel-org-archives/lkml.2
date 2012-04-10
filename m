Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab2DJSIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:08:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757653Ab2DJSID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:08:03 -0400
Date: Tue, 10 Apr 2012 13:40:36 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        martin.petersen@oracle.com
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline
 except SATA
Message-ID: <20120410174036.GA4178@redhat.com>
References: <20120410133708.GE21801@redhat.com>
 <4F843C17.5050004@kernel.dk>
 <20120410142148.GG21801@redhat.com>
 <20120410151042.GH21801@redhat.com>
 <CAMM=eLf5qi_PL8vFh_b5V_nq_mxg0CN0asE8E9XYJn48J4mdPA@mail.gmail.com>
 <20120410172828.GI21801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410172828.GI21801@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10 2012 at  1:28pm -0400,
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Apr 10, 2012 at 12:13:07PM -0400, Mike Snitzer wrote:
> 
> [..]
> > > So we are back to the question of can scsi devices find out if a Lun
> > > is backed by single disk or multiple disks.
> > 
> > I'm not aware of any discrete attribute (comparable to 'rotational'
> > flag) that SCSI devices will advertise that indicates "I'm a raid
> > array".
> > 
> > That said, we can have a _very_ good hint that a SCSI device is a raid array if:
> > 
> > 1) optimal_io_size is not zero, minimum_io_size is not equal to
> > optimal_io_size, and optimal_io_size is a multiple of minimum_io_size
> > 
> > 2) WCE=0 (higher-end arrays with a writeback cache)
> > 
> > Determining 1 could be enough, we should probably ignore 2 as it isn't
> > an absolute indication that a device is composed of multiple devices
> > (especially not if considered independently of 1).
> 
> Umm..., somehow relying on optimal_io_size != minimum_io_size sounds odd
> to me (assuming it works).
> 
> I checked bunch of Luns exported to me and all of them have
> optimal_io_size=0.

As I said above, this would only apply if "optimal_io_size is not zero, ..."

> I have few FC Luns exported from two array vendors. I have few iscsi Luns
> exported from two separate vendors and all these luns have
> optimal_io_size=0.

Seems all those LUNs haven't exported their limits via BLOCK LIMITS VPD.
But more recent firmware could rectify that.

Anyway, there is no one size fits all here, sorry to disappoint you!
