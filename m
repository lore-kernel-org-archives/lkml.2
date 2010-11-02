Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0KBS6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 14:58:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab0KBS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 14:58:42 -0400
Date: Tue, 2 Nov 2010 14:58:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>, Josef Bacik <jbacik@redhat.com>,
        Chris Mason <chris.mason@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC][PATCH] direct-io: btrfs: avoid splitting dio requests for
 non-btrfs filesystems
Message-ID: <20101102185833.GA7404@infradead.org>
References: <4CD001A2.4000408@linux.vnet.ibm.com>
 <20101102145717.GA2531@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101102145717.GA2531@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 10:57:18AM -0400, Josef Bacik wrote:
> (which I did anyway because of my bug).  So maybe the right idea is to rip out
> my logical offset tests altogether and fix dio so we treat buffer_boundary()
> like gospel.  That way Btrfs can get what it needs without having this weird
> special code, and then we can look at how other fs's set buffer_boundary (I'm
> pretty sure ext2/3 are the only ones) and make sure they are setting it when
> they really mean to.

That sounds pretty reasonable to me.  I really don't like the flag in
the kiocb in this patch, and handling it as part of the get_blocks
callback sounds much better to me.  I don't know enough about the
bounary blocks to know if we can reuse them - if we can it's perfect,
if not another buffer flag seems like the way to go.

