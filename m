Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2AaS63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 13:58:29 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34893 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522Ab2AaS60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 13:58:26 -0500
X-Sasl-enc: aCKPDt1dPF88Az6eOXz/AMFexLDI6R4aUXhTYdiLepqD 1328036306
Date: Tue, 31 Jan 2012 10:52:28 -0800
From: Greg KH <greg@kroah.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: devel@driverdev.osuosl.org,
        Christopher Lais <chris+android@zenthought.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] Staging: android: binder: Add some error checks
Message-ID: <20120131185228.GA21481@kroah.com>
References: <1327118181-3542-1-git-send-email-arve@android.com>
 <1327118181-3542-2-git-send-email-arve@android.com>
 <20120121082208.GL3294@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120121082208.GL3294@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 11:22:08AM +0300, Dan Carpenter wrote:
> On Fri, Jan 20, 2012 at 07:56:20PM -0800, Arve Hjønnevåg wrote:
> > - Add a mutex to protect against two processes mmapping the
> >   same binder_proc.
> > - After locking mmap_sem, check that the vma we want to access
> >   (still) points to the same mm_struct.
> > - Use proc->tsk instead of current to get the files struct since
> >   this is where we get the rlimit from.
> 
> This doesn't seem related to the locking change at all.  Probably
> this patch should be split into three patches, one bugfix per
> patch, unless they are very closely related.

I agree.  Arve, is this all fixing one problem, or multiple ones?  If
multiple ones, we need this split up into multiple patches.

thanks,

greg k-h
