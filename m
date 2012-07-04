Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733Ab2GDID4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:03:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54619 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab2GDIDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:03:50 -0400
Date: Wed, 4 Jul 2012 12:03:45 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [rfc 2/7] procfs: Convert /proc/pid/fdinfo/ handling routines to
 seq-file
Message-ID: <20120704080345.GD1999@moon>
References: <20120627110116.201735815@openvz.org>
 <20120627110512.485189390@openvz.org>
 <4FF3F2B6.5040909@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF3F2B6.5040909@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 11:37:26AM +0400, Pavel Emelyanov wrote:
> >  
> > -static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
> > -				size_t len, loff_t *ppos)
> > -{
> > -	char tmp[PROC_FDINFO_MAX];
> > -	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, tmp);
> > -	if (!err)
> > -		err = simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
> > -	return err;
> > -}
> > -
> 
> I believe we can still have the proc_fdinfo_read and proc_fd_link code non-splitted.
> Just push a callback pointer ino the proc_fd_info (as usual -- we an opaque void *argument).

Thanks! Will try.

	Cyrill
