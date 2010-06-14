Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0FNMhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:37:04 -0400
Received: from bar.sig21.net ([80.81.252.164]:34900 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab0FNMhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:37:02 -0400
Date: Mon, 14 Jun 2010 14:36:52 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: FIGETBSZ ioctl conflict
Message-ID: <20100614123652.GA312@sig21.net>
References: <20100614110252.GB32224@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614110252.GB32224@sig21.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.7 (---)
X-Spam-21-Report: No, score=-3.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.713,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(forgot to add lkml to Cc)

On Mon, Jun 14, 2010 at 01:02:52PM +0200, Johannes Stezenbach wrote:
> Hi,
> 
> in commit 19ba0559 the FIGETBSZ (and FS_IOC_FIEMAP) ioctl was moved
> from file_ioctl() to do_vfs_ioctl(), so it also works for directories.
> The problem I'm seeing is that FIGETBSZ is defined as _IO(0x00,2)
> which is simply 2.  so there is some potential for conflicts
> with character devices which do not use the _IO macros for numbering
> their ioctls.
> Just doing a web search for "FIGETBSZ ioctl conflict" shows
> that a few people already ran into this problem.
> 
> Would you mind adding a check for S_ISDIR | S_ISREG,
> or maybe !S_ISCHR?
> 
> 
> Thanks,
> Johannes
