Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0JNWdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:33:32 -0400
Received: from verein.lst.de ([213.95.11.210]:35173 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764Ab0JNWdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:33:31 -0400
Date: Fri, 15 Oct 2010 00:32:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com,
        lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] [PATCH -next] xfs: eliminate kconfig dependency warning
Message-ID: <20101014223245.GA20037@lst.de>
References: <20101013210142.9d524535.randy.dunlap@oracle.com> <20101014092503.GA28446@lst.de> <4CB73B5B.30108@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB73B5B.30108@oracle.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:18:19AM -0700, Randy Dunlap wrote:
> The (kconfig) warning/problem is that exportfs is in the Networking Filesystems menu,
> under the kconfig symbol NETWORK_FILESYSTEMS.

That's the culprit.  exportfs is just a helper library and should not
depend on anthing.  Looks like on of the various Kconfig patches broke
that.  Moving out of NETWORK_FILESYSTEMS will fix it.

