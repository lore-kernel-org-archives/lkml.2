Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab2LXRg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 12:36:26 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33309 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2LXRgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 12:36:25 -0500
Date: Mon, 24 Dec 2012 09:39:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Amit Shah <amit.shah@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: correct error message on failure of
 debugfs_create_dir
Message-ID: <20121224173937.GB14754@kroah.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-13-git-send-email-sasha.levin@oracle.com>
 <20121221075909.GA15739@amit.redhat.com>
 <201212241155.46866.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212241155.46866.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 11:55:46AM +0000, Arnd Bergmann wrote:
> On Friday 21 December 2012, Amit Shah wrote:
> > On (Thu) 20 Dec 2012 [14:11:21], Sasha Levin wrote:
> > > debugfs_create_dir() returns NULL if it fails, there's little point in
> > > calling PTR_ERR on it.
> >
> > debugfs_create_dir() does return an error value if debugfs is not
> > enabled.
> > 
> > This check for !pdrvdata.debugfs_dir should infact use
> > IS_ERR_OR_NULL().  Care to submit a patch for that?
> 
> How about we fix the stub instead to return NULL when debugfs is disabled?

No, please read debugfs.h for why I decided to not do this (i.e. we try
to learn from our mistakes...)

thanks,

greg k-h
