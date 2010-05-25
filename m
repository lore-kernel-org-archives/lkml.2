Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0EYPzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:55:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab0EYPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:55:37 -0400
Date: Tue, 25 May 2010 11:55:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>, Tejun Heo <tj@kernel.org>,
       Scott James Remnant <scott@ubuntu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Harald Hoyer <harald@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, agk@redhat.com,
       snitzer@redhat.com
Subject: Re: [PATCH 2/2] init, mount: export the name_to_dev_t symbol
Message-ID: <20100525155535.GA811@infradead.org>
References: <1274802411-26613-1-git-send-email-wad@chromium.org> <1274802411-26613-2-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274802411-26613-2-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 10:46:51AM -0500, Will Drewry wrote:
> This change only adds EXPORT_SYMBOL() for name_to_dev_t.
> 
> name_to_dev_t is in use outside of init/ but is not 'officially'
> exported.  It provides behavior that is useful for any code that may be
> need to lookup a block device by major:minor or registered kernel name,
> especially before there is a root filesystem.
> 
> Hopefully, this is the appropriate use of EXPORT_SYMBOL().  This
> specific function seems to be a stable interface and is available
> in include/linux/mount.h.

NACK.  It's really a hack for the boot code, there's no offical name to
dev_t mapping.

What are you trying to use it for?

