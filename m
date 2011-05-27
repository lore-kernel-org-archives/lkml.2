Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1E0ND6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:03:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab1E0ND5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:03:57 -0400
Date: Fri, 27 May 2011 09:03:48 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, msb@chromium.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH 1/3] block: Introduce blk_set_stacking_limits function
Message-ID: <20110527130348.GB17219@redhat.com>
References: <4DDEA689.2090004@fusionio.com>
 <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
 <1306464169-4291-2-git-send-email-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306464169-4291-2-git-send-email-martin.petersen@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26 2011 at 10:42pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> Stacking driver queue limits are typically bounded exclusively by the
> capabilities of the low level devices, not by the stacking driver
> itself.
> 
> Stacking drivers are typically permissive. A feature is supported unless
> an incompatible bottom device causes it to be disabled. Low-level
> drivers on the other hand are restrictive and want features disabled by
> default. Low-level drivers explicitly enable features as part of their
> device discovery process.
> 
> This patch introduces blk_set_stacking_limits() which has more liberal
> metrics than the default queue limits function. This allows us to
> inherit topology parameters from bottom devices without manually
> tweaking the default limits in each driver prior to calling the stacking
> function.
> 
> Since there is now a clear distinction between stacking and low-level
> devices, blk_set_default_limits() has been modified to carry the more
> conservative values that we used to manually set in
> blk_queue_make_request().
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
