Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab0DHOHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:07:00 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59441 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758597Ab0DHOGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:06:54 -0400
Date: Thu, 8 Apr 2010 16:06:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Message-ID: <20100408140653.GP10103@kernel.dk>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com> <20100408110045.GJ10103@kernel.dk> <20100408135901.GA10879@redhat.com> <x49pr2a9h3n.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49pr2a9h3n.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08 2010, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Thu, Apr 08, 2010 at 01:00:45PM +0200, Jens Axboe wrote:
> 
> >> I like the concept, it's definitely useful (and your results amply
> >> demonstrate that). I was thinking if there was a way in through the ioc
> >> itself, rather than bdi -> queue and like you are doing. But I can't
> >> think of a nice way to do it, so this is probably as good as it gets.
> >> 
> >
> > I think, one issue with ioc based approach will be that it will then call
> > yield operation on all the devices in the system where this context has ever
> > done any IO. With bdi based approach this call will remain limited to
> > a smaller set of devices.
> 
> Which actually brings up the question of whether this needs some
> knowledge of whether the journal is on the same device as the file
> system!  In such a case, we need not yield.  I think I'll stick my head
> in the sand for this one.  ;-)

Yes, that is true. But that should be relatively easy to check.

-- 
Jens Axboe

