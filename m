Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705Ab2C3Ump (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:42:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48002 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934656Ab2C3Umk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:42:40 -0400
Date: Fri, 30 Mar 2012 13:42:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sasha Levin <levinsasha928@gmail.com>, arnd@arndb.de,
        viro@zeniv.linux.org.uk, davej@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
Message-ID: <20120330204235.GA883@kroah.com>
References: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com>
 <20120330153013.GC18488@kroah.com>
 <CA+1xoqdZnxcWNpL-03xsR+RDcz3=aRbx2LbR6mTJ_gCmwp-0Rw@mail.gmail.com>
 <20120330164913.GA19946@kroah.com>
 <alpine.LFD.2.02.1203302225420.2542@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.02.1203302225420.2542@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 10:35:46PM +0200, Thomas Gleixner wrote:
> On Fri, 30 Mar 2012, Greg KH wrote:
> > On Fri, Mar 30, 2012 at 07:37:37PM +0300, Sasha Levin wrote:
> > > On Fri, Mar 30, 2012 at 6:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > On Fri, Mar 30, 2012 at 01:04:27PM -0400, Sasha Levin wrote:
> > > >> There are no size checks in kmsg_write(), and we try allocating enough
> > > >> memory to store everything userspace gave us, which may be too much for
> > > >> kmalloc to allocate.
> > > >
> > > > Really?  Have you seen this fail?  As only root can do this, is this
> > > > really a problem?
> > > 
> > > Only root, and a whole bunch of management software that dumps data
> > > into /dev/kmsg (systemd and friends).
> > 
> > Running as root, do any of these cause problems by asking for too much
> > memory here? 
> 
> Running as root is not a guarantee for correctness. So the syscall
> should cope with bogus requests from user space and not rely on the
> sanity of anything. Looking at the main users which polute dmesg I'm
> inclined to assume insanity in the first place.
> 
> As Sasha pointed out there is either the variant to use vmalloc and
> grant any write size or limit the size to something sensible. Though
> given the users of this, coming up with something sensible might be a
> problem.
> 
> > Is this something that needs to be addressed now, and in
> > stable kernels, or can it wait for 3.5?
> 
> Yes, it want's to be addressed now and it want's to be in stable as
> well. syscalls which have no bound checking are evil, no matter what.

So, should we cap the size at something "super large" then as well?

thanks,

greg k-h
