Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2GBBro (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 21:47:44 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41906 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2GBBrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 21:47:42 -0400
Message-ID: <1341193591.2249.3.camel@falcor>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Sun, 01 Jul 2012 21:46:31 -0400
In-Reply-To: <20120701205722.GD22927@ZenIV.linux.org.uk>
References: <20120627183721.GA23086@redhat.com>
	 <20120628043836.GW14083@ZenIV.linux.org.uk>
	 <1340947838.2293.2.camel@falcor>
	 <20120629083311.GX14083@ZenIV.linux.org.uk>
	 <1340974925.2309.13.camel@falcor>
	 <20120629174130.GY14083@ZenIV.linux.org.uk>
	 <1341005929.2194.9.camel@falcor.watson.ibm.com>
	 <1341014197.2342.7.camel@falcor.watson.ibm.com>
	 <20120630050238.GZ14083@ZenIV.linux.org.uk>
	 <1341172202.2556.13.camel@falcor>
	 <20120701205722.GD22927@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070201-5518-0000-0000-000005AF0E15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-01 at 21:57 +0100, Al Viro wrote:
> On Sun, Jul 01, 2012 at 03:50:02PM -0400, Mimi Zohar wrote:
> > Replacing it with a call to __fput(), the system boots.
> 
> "it" being just the part under that if (unlikely(...)))?  Very interesting...  If so, we
> have some kernel thread ending up with delayed __fput() which somehow makes dracut (assuimg
> you are using fedora initramfs to go with fedora config) unhappy.  With your own patch,
> doing async __fput() in a lot of cases when this one doesn't delay past the return to
> userland managing to survive the boot...  I wonder which files end up triggering that fun
> and which kernel thread is responsible...  Could you slap a printk() in there, showing
> file->f_dentry->d_inode->i_mode (octal) and at least file->f_dentry->d_name.name?
> Along with the current->comm[], all under that inner if ().  And see which ones end up
> going that way by the time execve() of /sbin/init fails.

pid=1 uid=0 d_name=init comm=swapper/0 dev="rootfs" mode=100775
pid=1 uid=0 d_name=bash comm=swapper/0 dev="rootfs" mode=100755

> It would be nice to see which sys_mount() calls are made and which (if any) fail, BTW.
> I wonder if it even gets to mounting the right root...


