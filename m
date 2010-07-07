Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab0GGQI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:08:57 -0400
Received: from verein.lst.de ([213.95.11.210]:56003 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088Ab0GGQIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:08:55 -0400
Date: Wed, 7 Jul 2010 18:08:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 2/2] tty fix fu_list abuse
Message-ID: <20100707160835.GA9681@lst.de>
References: <20100707122406.GL11732@laptop> <20100707122510.GM11732@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707122510.GM11732@laptop>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 10:25:10PM +1000, Nick Piggin wrote:
> tty: fix fu_list abuse
> 
> tty code abuses fu_list, which causes a bug in remount,ro handling.
> 
> If a tty device node is opened on a filesystem, then the name unlinked, the
> filesystem will be allowed to be remounted readonly. This is because
> fs_may_remount_ro does not find the 0 link tty inode on the file sb list
> (because the tty code incorrectly removed it to use for its own purpose). This
> can result in a filesystem with errors after it is marked "clean".  So add a
> new private list for ttys and leave tty files on the sb list so they are caught
> by this check. This makes tty nodes behave the same way as other device nodes.
> 
> The next step is to allocate a tty private structure at private_data and get
> rid of f_ttyonly_list, but the error handling is not trivial in the tty code.
> Hence this intermediate step.

Growing struct file by two pointers for the tty special case simply
isn't acceptable.  

