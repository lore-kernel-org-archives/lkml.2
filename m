Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab2E3Fxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 01:53:31 -0400
Received: from matrix.voodoobox.net ([75.127.97.206]:54965 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2E3Fwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 01:52:47 -0400
X-Greylist: delayed 2580 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2012 01:52:47 EDT
Message-ID: <1338354377.2361.13.camel@obelisk.thedillows.org>
Subject: Re: [PATCH 1/1] ib_srp: Infiniband srp fast failover patch.
From: David Dillow <dillowda@ornl.gov>
To: Karandeep Chahal <kchahal@ddn.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        roland@kernel.org, sean.hefty@intel.com
Date: Wed, 30 May 2012 01:06:17 -0400
In-Reply-To: <4FC53AAA.3060203@ddn.com>
References: <4FC53AAA.3060203@ddn.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 17:07 -0400, Karandeep Chahal wrote:
> Subject: [PATCH] Infiniband srp fast failover patch.

This conflicts with Bart's patches to improve failover; it will be much
better to use his approach to block the target rather than remove it
wholesale -- we could have lost connectivity as a transient and may get
it back quickly if someone grabbed the wrong cable, etc.

Also, we should only kill the one target on DREQ, and we already have a
pointer to it from the CM context -- no need to search.

It is a good idea to hook into the event mechanism; this is something
I've long wanted to incorporate (as Vu did in OFED). I'm looking at
getting Bart's series to a point I can merge it, and I'll pull in your
ideas -- with credit -- there.

Thanks,
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

