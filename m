Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1HOOt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:49:57 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44229
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002Ab1HOOtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:49:55 -0400
Date: Mon, 15 Aug 2011 10:49:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: build failure after merge of the final tree (xfs
 tree related)
Message-ID: <20110815144946.GA8256@infradead.org>
References: <20110815161023.6227665ab11f8a35fd649e3a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815161023.6227665ab11f8a35fd649e3a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 04:10:23PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (a powerpc server
> config) failed like this:

You'll need the patch below.  Can you keep is as a fix-up for now until
Alex returns from his vacation?

---
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: fix tracing builds inside the source tree

The code really requires the current source directory to be in the
header search path.  We already do this if building with an object
tree separate from the source, but it needs to be added manually
if building inside the source.  The cflags addition for it accidentally
got removed when collapsing the xfs directory structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/Makefile
===================================================================
--- xfs.orig/fs/xfs/Makefile	2011-08-13 06:41:29.586063467 -0700
+++ xfs/fs/xfs/Makefile	2011-08-13 06:41:58.245908204 -0700
@@ -16,6 +16,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
+ccflags-y += -I$(src)			# needed for trace events
+
 ccflags-$(CONFIG_XFS_DEBUG) += -g
 
 obj-$(CONFIG_XFS_FS)		+= xfs.o
