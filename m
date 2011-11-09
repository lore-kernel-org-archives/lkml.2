Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab1KIVyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:54:09 -0500
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:40636
	"EHLO qmta01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751617Ab1KIVyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:54:08 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Nov 2011 16:54:08 EST
Date: Wed, 9 Nov 2011 21:48:26 +0000
From: "Adam M. Costello" <linux-kernel.amc+0+@nicemice.net>
To: linux-kernel@vger.kernel.org
Subject: Could MADV_REMOVE work with hugetlbfs?
Message-ID: <20111109212737.35z~@nicemice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

madvise(MADV_REMOVE) punches a hole in a file (via truncate_range()).
It's the only way (as far as I know) to return an arbitrary page of
shared memory to the system.  It's supported by tmpfs, but not by
hugetlbfs.

So a regular page of shared memory (from shmget() or from mmap() on
a tmpfs file) can be returned, but huge page of shared memory (from
shmget(SHM_HUGETLB) or from mmap() on a hugetlbfs file) cannot be
returned.

Has anyone thought about adding support for truncate_range and
MADV_REMOVE to hugetlbfs?  How hard would that be?

Thanks,
AMC
