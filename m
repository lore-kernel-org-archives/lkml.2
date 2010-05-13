Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab0EMRkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:40:52 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48857 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab0EMRkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:40:49 -0400
Date: Thu, 13 May 2010 19:40:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
Message-ID: <20100513174047.GX25951@kernel.dk>
References: <1273766206-17402-1-git-send-email-tj@kernel.org> <1273766778.4353.200.camel@mulgrave.site> <4BEC272E.10508@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEC272E.10508@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13 2010, Tejun Heo wrote:
> Hello,
> 
> On 05/13/2010 06:06 PM, James Bottomley wrote:
> > I'm not sure this is such a good interface ... it sounds very error
> > prone for what is effectively a binary lock/unlock.
> 
> Well, the original block interface was like that.  It has been used as
> binary switch tho.  The requested capacity is always ~0ULL and return
> value smaller than the current capacity is ignored.  I'm all for
> dropping the capacity parameter and the return value from
> ->set_capacity() so that it just unlocks native capacity and directly
> sets the new capacity.  Jens?

Is there a valid case for setting the capacity less than the unlocked
capacity? I would think the unlock/lock bool api is saner.

-- 
Jens Axboe

