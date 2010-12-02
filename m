Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab0LBORj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:17:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50523 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716Ab0LBORi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:17:38 -0500
Date: Thu, 2 Dec 2010 09:17:37 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Spelic <spelic@shiftmail.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, linux-lvm@redhat.com
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
Message-ID: <20101202141737.GA29799@infradead.org>
References: <4CF7A539.1050206@shiftmail.org>
 <20101202141134.GA22012@infradead.org>
 <4CF7A9C4.2040607@shiftmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF7A9C4.2040607@shiftmail.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 03:14:28PM +0100, Spelic wrote:
> On 12/02/2010 03:11 PM, Christoph Hellwig wrote:
> >I'm pretty sure you have CONFIG_DEBUG_BLOCK_EXT_DEVT enabled.  This
> >option must never be enabled, as it causes block devices to be
> >randomly renumered.  Together with the ramdisk driver overloading
> >the BLKFLSBUF ioctl to discard all data it guarantees you to get
> >data loss like yours.
> 
> Nope...
> 
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set

Hmm, I suspect dm-linear's dumb forwarding of ioctls has the same
effect.

