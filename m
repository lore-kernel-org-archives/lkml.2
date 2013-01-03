Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab3ACSTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 13:19:40 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33454
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575Ab3ACSTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 13:19:38 -0500
Date: Thu, 3 Jan 2013 13:19:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Sergei Trofimovich <slyfox@gentoo.org>
Cc: xfs@oss.sgi.com, Alex Elder <elder@kernel.org>,
        Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Ben Myers <bpm@sgi.com>, Phil White <pwhite@sgi.com>
Subject: Re: [PATCH] xfs: return -EINVAL instead of -EUCLEAN when mounting
 non-xfs
Message-ID: <20130103181929.GA23049@infradead.org>
References: <20121230015615.6cc9e03c@sf>
 <1356823010-29768-1-git-send-email-slyfox@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356823010-29768-1-git-send-email-slyfox@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2012 at 02:16:50AM +0300, Sergei Trofimovich wrote:
> It fixes boot panic when trying to boot from btrfs filesystem.
> kernel tries to mount as xfs and gets fatal -EUCLEAN:
> 
> [    0.170000] VFS: Cannot open root device "ubda" or unknown-block(98,0): error -117
> [    0.170000] Please append a correct "root=" boot option; here are the available partitions:
> [    0.170000] 6200         1048576 ubda  driver: uml-blkdev
> [    0.170000] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(98,0)
> 
> init/do_mounts.c expects only -EINVAL as 'retry another' option.
> Fixes regression introduced by commit 98021821a502db347bd9c7671beeee6e8ce07ea6

Looks reasonable, but  think xfs_readsb should simply be changed to
turn all EFSCORRUPTED returns into EINVAL if loud is not set.  The
place that changes the errno value would also be a perfect place to
comment why we are doing this in the code so that this knowledge doesn't
get lost.

