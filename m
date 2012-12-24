Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2LXSkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 13:40:04 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:51319 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2LXSj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 13:39:59 -0500
Date: Mon, 24 Dec 2012 10:43:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Amit Shah <amit.shah@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: correct error message on failure of
 debugfs_create_dir
Message-ID: <20121224184312.GA15597@kroah.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-13-git-send-email-sasha.levin@oracle.com>
 <20121221075909.GA15739@amit.redhat.com>
 <201212241155.46866.arnd@arndb.de>
 <20121224173937.GB14754@kroah.com>
 <CA+1xoqdd3DN6ApCnQh=8fQBvFh40O2BJPf4mAA_L17cRH8kShQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqdd3DN6ApCnQh=8fQBvFh40O2BJPf4mAA_L17cRH8kShQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 01:24:52PM -0500, Sasha Levin wrote:
> On Mon, Dec 24, 2012 at 12:39 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Mon, Dec 24, 2012 at 11:55:46AM +0000, Arnd Bergmann wrote:
> >> On Friday 21 December 2012, Amit Shah wrote:
> >> > On (Thu) 20 Dec 2012 [14:11:21], Sasha Levin wrote:
> >> > > debugfs_create_dir() returns NULL if it fails, there's little point in
> >> > > calling PTR_ERR on it.
> >> >
> >> > debugfs_create_dir() does return an error value if debugfs is not
> >> > enabled.
> >> >
> >> > This check for !pdrvdata.debugfs_dir should infact use
> >> > IS_ERR_OR_NULL().  Care to submit a patch for that?
> >>
> >> How about we fix the stub instead to return NULL when debugfs is disabled?
> >
> > No, please read debugfs.h for why I decided to not do this (i.e. we try
> > to learn from our mistakes...)
> 
> Why won't we fix it the other way around and return an actual error
> code instead of a NULL on failure?

Again, no, that doesn't make your code simpler/faster.  You really don't
need to check the return value of debugfs, just handle it as if it
always works, and look, the code handles it all properly, no matter if
debugfs is enabled or not.  It's only debugging code, you shouldn't
really care if it is present or not, right?

If you do, perhaps you shouldn't be using debugfs?

greg k-h
