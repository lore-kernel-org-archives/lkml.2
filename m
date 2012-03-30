Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100Ab2C3QtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:49:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45419 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab2C3QtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:49:17 -0400
Date: Fri, 30 Mar 2012 09:49:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: arnd@arndb.de, viro@zeniv.linux.org.uk, davej@redhat.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
Message-ID: <20120330164913.GA19946@kroah.com>
References: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com>
 <20120330153013.GC18488@kroah.com>
 <CA+1xoqdZnxcWNpL-03xsR+RDcz3=aRbx2LbR6mTJ_gCmwp-0Rw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+1xoqdZnxcWNpL-03xsR+RDcz3=aRbx2LbR6mTJ_gCmwp-0Rw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 07:37:37PM +0300, Sasha Levin wrote:
> On Fri, Mar 30, 2012 at 6:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Mar 30, 2012 at 01:04:27PM -0400, Sasha Levin wrote:
> >> There are no size checks in kmsg_write(), and we try allocating enough
> >> memory to store everything userspace gave us, which may be too much for
> >> kmalloc to allocate.
> >
> > Really?  Have you seen this fail?  As only root can do this, is this
> > really a problem?
> 
> Only root, and a whole bunch of management software that dumps data
> into /dev/kmsg (systemd and friends).

Running as root, do any of these cause problems by asking for too much
memory here?  Is this something that needs to be addressed now, and in
stable kernels, or can it wait for 3.5?

> >> One option would be to limit it to something, but we can't come up with
> >> a number that would make sense.
> >>
> >> Instead, just use vmalloc so that nothing would break with large amounts
> >> of data.
> >
> > Are you sure this will work properly?  Have you tested it with large
> > amounts of data?
> 
> My test was dumping 800mb of data into it, if there's anything else I
> should try please let me know.

Did that fail before and now it works properly?

thanks,

greg k-h
