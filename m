Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab0GGQR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:17:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:45185 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab0GGQRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:17:24 -0400
Date: Thu, 8 Jul 2010 02:17:20 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Frank Mayhar <fmayhar@google.com>,
       John Stultz <johnstul@us.ibm.com>, Andi Kleen <ak@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 2/2] tty fix fu_list abuse
Message-ID: <20100707161720.GA9263@laptop>
References: <20100707122406.GL11732@laptop>
 <20100707122510.GM11732@laptop>
 <20100707160835.GA9681@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707160835.GA9681@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 06:08:35PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 07, 2010 at 10:25:10PM +1000, Nick Piggin wrote:
> > tty: fix fu_list abuse
> > 
> > tty code abuses fu_list, which causes a bug in remount,ro handling.
> > 
> > If a tty device node is opened on a filesystem, then the name unlinked, the
> > filesystem will be allowed to be remounted readonly. This is because
> > fs_may_remount_ro does not find the 0 link tty inode on the file sb list
> > (because the tty code incorrectly removed it to use for its own purpose). This
> > can result in a filesystem with errors after it is marked "clean".  So add a
> > new private list for ttys and leave tty files on the sb list so they are caught
> > by this check. This makes tty nodes behave the same way as other device nodes.
> > 
> > The next step is to allocate a tty private structure at private_data and get
> > rid of f_ttyonly_list, but the error handling is not trivial in the tty code.
> > Hence this intermediate step.
> 
> Growing struct file by two pointers for the tty special case simply
> isn't acceptable.  

I agree, so it can be removed when tty gets its act together. But tty
breaks the s_files list right now which is not acceptable either. So I
think it is better to take the simple fix that can be easily applied. I
liked your patch, but error handling was totally broken in it so that
indicates it is going to require some maturing in the tty tree.

