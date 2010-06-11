Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0FKG4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:56:47 -0400
Received: from verein.lst.de ([213.95.11.210]:37250 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0FKG4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:56:46 -0400
Date: Fri, 11 Jun 2010 08:56:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joel Becker <joel.becker@oracle.com>, Christoph Hellwig <hch@lst.de>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH v4] ocfs2: Let ocfs2_setattr use new truncate sequence.
Message-ID: <20100611065635.GA19692@lst.de>
References: <1276226869-11123-1-git-send-email-tao.ma@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276226869-11123-1-git-send-email-tao.ma@oracle.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks correct, but still has the second if ATTR_SIZE block that
I commented on last time.  I'd really prefer if the filesystems could
move the truncate handling into a single conditional to simplify
auditing for it and possibly splitting it out into a separate method
later.

And btw, the S_ISREG check which you only have on the first ATTR_SIZE
check is superflous, the VFS only does ATTR_SIZE calls on regular files.

