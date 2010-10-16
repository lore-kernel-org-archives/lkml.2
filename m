Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab0JPQMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:12:33 -0400
Received: from canuck.infradead.org ([134.117.69.58]:32940 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0JPQMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:12:32 -0400
Date: Sat, 16 Oct 2010 12:12:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] fs: icache lock s_inodes list
Message-ID: <20101016161210.GA16861@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-3-git-send-email-david@fromorbit.com>
 <20101001054909.GB32349@infradead.org>
 <20101016075411.GA19147@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016075411.GA19147@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 06:54:11PM +1100, Nick Piggin wrote:
> Because in the first part of the inode lock series, it is breaking
> locks in obvious small steps as possible, by adding global locks
> protecting bits of what inode_lock used to.

As seen by Dave's respin making it per-sb was just as easy as making
it global. And it really is the logical synchronization domain.

