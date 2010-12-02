Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab0LBOLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:11:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45904 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766Ab0LBOLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:11:35 -0500
Date: Thu, 2 Dec 2010 09:11:34 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Spelic <spelic@shiftmail.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, linux-lvm@redhat.com
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
Message-ID: <20101202141134.GA22012@infradead.org>
References: <4CF7A539.1050206@shiftmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF7A539.1050206@shiftmail.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pretty sure you have CONFIG_DEBUG_BLOCK_EXT_DEVT enabled.  This
option must never be enabled, as it causes block devices to be
randomly renumered.  Together with the ramdisk driver overloading
the BLKFLSBUF ioctl to discard all data it guarantees you to get
data loss like yours.

