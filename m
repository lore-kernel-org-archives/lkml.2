Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab0E2XdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 19:33:08 -0400
Received: from t21.t-2.net ([84.255.209.100]:39118 "EHLO t21.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab0E2XdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 19:33:06 -0400
Subject: Re: [PATCH] detour TTY driver
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <20100529235402.296406d9@lxorguk.ukuu.org.uk>
References: <1273918658.2341.17.camel@itpsd6lap>
	 <1275171436.2122.29.camel@itpsd6lap>
	 <20100529235402.296406d9@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sun, 30 May 2010 01:33:03 +0200
Message-Id: <1275175983.2122.42.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SGG-UMAMSID: 20100529233304Z22116t21.t-2.net 1OIVWa-0005ki-KS
X-SGG-RESULT: 20100529233304Z22116t21.t-2.net C1:OK E1:OK MX1:OK BL:OK SPF:off  CT:Unknown CM: SIP:84.255.254.67 SMF:samo_pogacnik@t-2.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static void initial_console_redirect(void)
> > +{
> > +	long ret;
> > +
> > +	/* re-register our fops write function */
> > +	detour_fops.write = detour_write;
> > +
> > +	detour_file.f_dentry = &detour_dentry;
> > +	detour_file.f_dentry->d_inode = &detour_inode;
> > +	detour_file.f_op = &detour_fops;
> > +	detour_file.f_mode |= FMODE_WRITE;
> > +	security_file_alloc(&detour_file);
> > +	INIT_LIST_HEAD(&detour_file.f_u.fu_list);
> > +
> > +	detour_inode.i_rdev = MKDEV(TTYAUX_MAJOR, 3);
> > +	security_inode_alloc(&detour_inode);
> > +	INIT_LIST_HEAD(&detour_inode.inotify_watches);
> > +
> > +	ret = detour_fops.open(&detour_inode, &detour_file);
> > +	printk(KERN_INFO "detour_fops.open() returned %ld\n", ret);
> > +	ret = detour_fops.unlocked_ioctl(&detour_file, TIOCCONS, 0);
> > +	printk(KERN_INFO "detour_fops.ioctl() returned %ld\n", ret);
> > +}
> 
> Bletch.. I'm really opposed to this kind of hackery. Fix your userspace a
> tiny bit.
> 
> So
> - Write only tty that uses printk: Looks good to me, implementation
>   quibbles only
> - Magic kernel hacks to shuffle things around in the initial console
>   logic - hideous. I still really think you need to fix your userspace
> 

Thank you for all comments. I'll try to follow them (might take some
time) and i'll remove the internal console redirection magic for sure. 

regards, Samo

