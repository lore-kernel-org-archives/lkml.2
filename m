Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0LLQqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:46:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:58721 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab0LLQqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:46:30 -0500
Date: Sun, 12 Dec 2010 08:45:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Subject: Re: fsnotify & sysfs
Message-ID: <20101212164539.GB14167@suse.de>
References: <20101212124247.GA14450@gundam.enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101212124247.GA14450@gundam.enneenne.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 01:42:47PM +0100, Rodolfo Giometti wrote:
> Hello,
> 
> I know that a sysfs file may be pollable but I'm asking to myself how
> it could be difficult adding notifying support also.
> 
> Maybe adding a call to the fsnotify subsystem within the
> sysfs_notify() function as follow can do the trick?

Perhaps, does that work?

> However my problem is how to get the struct dentry pointer needed by
> fsnotify_change() related to the struct sysfs_dirent pointer passed to
> sysfs_notify(). :(

Yup, that's a problem :(

> Can you please give me any advice about to solve it?
> 
> Another question: in file linux/fs/sysfs/file.c I see:
> 
>    #include <linux/fsnotify.h>
> 
> but none of its functions are called into file.c... maybe it's a
> mistake?

Possibly, but look at the patch that added that line, perhaps it was put
there for a reason.

thanks,

greg k-h
