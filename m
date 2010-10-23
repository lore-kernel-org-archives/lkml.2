Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0JWLWG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:22:06 -0400
Received: from verein.lst.de ([213.95.11.210]:55141 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab0JWLWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:22:05 -0400
Date: Sat, 23 Oct 2010 13:21:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] convert DRBD to REQ_FLUSH/FUA
Message-ID: <20101023112159.GA23540@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010231318.33517.philipp.reisner@linbit.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 01:18:33PM +0200, Philipp Reisner wrote:
> Hi Jens,
> 
> Christoph Hellwig pointed out that drbd is the only driver
> that still uses/supports barriers instead of FUE in linux-next.
> 
> I revitalized three patches that remove the barrier bits from DRBD...

This looks good.  You probably don't actually need the MD_NO_FUA flag -
REQ_FUA writes will always work - they just ignored by drivers not
implementing cache control.

