Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2GNPTL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 11:19:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38353 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2GNPTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 11:19:06 -0400
Date: Sat, 14 Jul 2012 16:19:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel boot hangs on commit "switch fput to task_work_add"
Message-ID: <20120714151903.GE31729@ZenIV.linux.org.uk>
References: <20120710141830.GA5385@localhost>
 <20120714130510.GC31729@ZenIV.linux.org.uk>
 <20120714134849.GA1175@localhost>
 <20120714135849.GA1257@localhost>
 <20120714141415.GD31729@ZenIV.linux.org.uk>
 <20120714143459.GA1544@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120714143459.GA1544@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 10:34:59PM +0800, Fengguang Wu wrote:
> On Sat, Jul 14, 2012 at 03:14:15PM +0100, Al Viro wrote:
> > On Sat, Jul 14, 2012 at 09:58:49PM +0800, Fengguang Wu wrote:
> > > > Hi Al, here I got the output for
> > > > 
> > > > (qemu) sendkey alt-sysrq-l
> > > > (qemu) sendkey alt-sysrq-t
> > > 
> > > I repeated that several times and here are the results.
> > > 
> > > (qemu) sendkey alt-sysrq-l
> > > (qemu) sendkey alt-sysrq-l
> > > (qemu) sendkey alt-sysrq-l
> > > (qemu) sendkey alt-sysrq-t
> > > (qemu) sendkey alt-sysrq-t
> > > (qemu) quit
> > > 
> > > The user space shutdown is polling on something, which prevents the
> > > system from reboot..
> > 
> > Which userland it is?
> 
> It's a customized ubuntu core. The original tgz image is downloaded
> here, however it's not directly usable as initrd.. Should I send my
> hacked one?

Sigh...  FWIW, with your config neither the mainline nor the tree you'd
been testing manage to boot with .deb produced by squeeze make-kpkg.
Both in the same way - they get to busybox, mount(8) in there keeps
failing wiht -ENODEV all the time and the damn thing ends up in
busybox shell.  Fsck knows what's going on - apparently the damn thing
also redirects all printks someplace invisible as soon as it gets to
userland, so the obvious ways to see what's going on do not work.
RTFS(busybox) time, I guess...

With reasonably sane config both trees work fine.  I'll grab your image
and see what happens with it.
