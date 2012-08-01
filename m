Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2HAIpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 04:45:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35439 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab2HAIpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 04:45:20 -0400
Message-ID: <5018EC94.1050405@kernel.dk>
Date: Wed, 01 Aug 2012 10:45:08 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        vijay.chauhan@netapp.com
Subject: Re: [RESEND PATCH] block: do not artificially constrain max_sectors
 for stacking drivers
References: <20120710191859.GB3831@redhat.com> <1343781553-17089-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <1343781553-17089-1-git-send-email-snitzer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 02:39 AM, Mike Snitzer wrote:
> blk_set_stacking_limits is intended to allow stacking drivers to build
> up the limits of the stacked device based on the underlying devices'
> limits.  But defaulting 'max_sectors' to BLK_DEF_MAX_SECTORS (1024)
> doesn't allow the stacking driver to inherit a max_sectors larger than
> 1024 -- due to blk_stack_limits' use of min_not_zero.
> 
> It is now clear that this artificial limit is getting in the way so
> change blk_set_stacking_limits's max_sectors to UINT_MAX (which allows
> stacking drivers like dm-multipath to inherit 'max_sectors' from the
> underlying paths).

Thanks Mike (and Vijay), applied for 3.6.

-- 
Jens Axboe

