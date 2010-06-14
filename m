Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0FNNm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 09:42:59 -0400
Received: from thunk.org ([69.25.196.29]:60694 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab0FNNm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 09:42:58 -0400
Date: Mon, 14 Jun 2010 09:42:52 -0400
From: tytso@mit.edu
To: Johannes Stezenbach <js@sig21.net>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FIGETBSZ ioctl conflict
Message-ID: <20100614134252.GA22163@thunk.org>
Mail-Followup-To: tytso@mit.edu, Johannes Stezenbach <js@sig21.net>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20100614110252.GB32224@sig21.net>
 <20100614123652.GA312@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614123652.GA312@sig21.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 02:36:52PM +0200, Johannes Stezenbach wrote:
> (forgot to add lkml to Cc)
> 
> On Mon, Jun 14, 2010 at 01:02:52PM +0200, Johannes Stezenbach wrote:
> > Hi,
> > 
> > in commit 19ba0559 the FIGETBSZ (and FS_IOC_FIEMAP) ioctl was moved
> > from file_ioctl() to do_vfs_ioctl(), so it also works for directories.
> > The problem I'm seeing is that FIGETBSZ is defined as _IO(0x00,2)
> > which is simply 2.  so there is some potential for conflicts
> > with character devices which do not use the _IO macros for numbering
> > their ioctls.
> > Just doing a web search for "FIGETBSZ ioctl conflict" shows
> > that a few people already ran into this problem.
> > 
> > Would you mind adding a check for S_ISDIR | S_ISREG,
> > or maybe !S_ISCHR?

Yeah, I think the right thing to do here is a check for 
S_ISDIR | S_ISREG | S_ISLNK.

						- Ted
