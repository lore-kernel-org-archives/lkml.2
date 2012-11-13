Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab2KMHWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:22:10 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45279 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2KMHWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:22:08 -0500
Date: Tue, 13 Nov 2012 11:22:04 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 4/7] fs, notify: Add procfs fdinfo helper v4
Message-ID: <20121113072204.GD6511@moon>
References: <20121112101440.665694060@openvz.org>
 <20121112101845.907133141@openvz.org>
 <20121112170017.537e3c97.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121112170017.537e3c97.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 05:00:17PM -0800, Andrew Morton wrote:
> >  
> >  static const struct file_operations inotify_fops = {
> > +#ifdef CONFIG_PROC_FS
> > +	.show_fdinfo	= inotify_show_fdinfo,
> > +#endif
> >  	.poll		= inotify_poll,
> >  	.read		= inotify_read,
> >  	.fasync		= inotify_fasync,
> > @@ -427,6 +428,9 @@ static long fanotify_ioctl(struct file *
> >  }
> >  
> >  static const struct file_operations fanotify_fops = {
> > +#ifdef CONFIG_PROC_FS
> > +	.show_fdinfo	= fanotify_show_fdinfo,
> > +#endif
> >  	.poll		= fanotify_poll,
> >  	.read		= fanotify_read,
> >  	.write		= fanotify_write,
> 
> Then remove these ifdefs.
> 
> That's if you can be bothered.  It's a bit of a party trick which
> doesn't make things much clearer IMO.

Sure, i'll update.
