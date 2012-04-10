Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab2DJSxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:53:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758353Ab2DJSxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:53:21 -0400
Date: Tue, 10 Apr 2012 14:53:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline
 except SATA
Message-ID: <20120410185318.GL21801@redhat.com>
References: <20120410133708.GE21801@redhat.com>
 <4F843C17.5050004@kernel.dk>
 <20120410142148.GG21801@redhat.com>
 <20120410151042.GH21801@redhat.com>
 <4F847EC4.7040604@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F847EC4.7040604@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 08:41:08PM +0200, Jens Axboe wrote:

[..]
> > So we are back to the question of can scsi devices find out if a Lun
> > is backed by single disk or multiple disks.
> 
> The cleanest would be to have the driver signal these attributes at
> probe time. You could even adjust CFQ properties based on this, driving
> the queue depth harder etc. Realistically, going forward, most fast
> flash devices will be driven by a noop-like scheduler on multiqueue. So
> CPU cost of the IO scheduler can mostly be ignored, since CFQ cost on
> even big RAIDs isn't an issue due to the low IOPS rates.

Agreed that on RAID CPU cost is not a problem. Just that idling and low
queue depth kills the performance.

So apart from "rotational" if driver can give some hints about underlying
devices being RAID (or multi device), it will help. Just that it looks
like scsi does not have a way to determine that.

Thanks
Vivek
