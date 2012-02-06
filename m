Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2BFWla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:41:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab2BFWlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:41:18 -0500
Date: Mon, 6 Feb 2012 23:41:16 +0100
From: Jan Kara <jack@suse.cz>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] fs: filesystem specific options and remount
Message-ID: <20120206224116.GE24840@quack.suse.cz>
References: <4F2BFBAF.5020703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2BFBAF.5020703@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 03-02-12 16:22:23, Jerome Marchand wrote:
> 
> When remounted without option specified, some filesystems keep the
> options that are already set (e.g. procfs, fat) and some reset them to
> default (e.g. devpts).
> Regarding options that are specified at remount, behavior of
> filesystems also differ: some apply them (procfs, devpts), some
> silently disregard them (e.g. fat) and some have a more elaborate
> behavior (e.g. xfs apparently allows a subset of options to be changed
> and issues warning if someone tries to change any other option).
> 
> Is there any policy regarding what the correct behavior should be?
> This variety of behaviors tends to confuse mount utility which often
> does not show the correct option actually set after a remount and
> most certainly confuses the users as well.
> 
> Here is a example of discrepancy between mount (/etc/mtab) and
> /proc/mounts:
> 
> $ grep proc /proc/mounts
> /proc /proc proc rw,relatime 0 0
> $ mount | grep proc
> proc on /proc type proc (rw)
> 
> $ mount -o remount,hidepid=2 /proc/
> $ grep proc /proc/mounts
> /proc /proc proc rw,relatime,hidepid=2 0 0
> $ mount | grep proc
> proc on /proc type proc (rw,hidepid=2)
> 
> $ mount -o remount /proc/
> $ grep proc /proc/mounts
> /proc /proc proc rw,relatime,hidepid=2 0 0
> $ mount | grep proc
> proc on /proc type proc (rw)
> 
> And here is the discrepancy: mount does not show "hidepid=2" option
> that is actually still set and enforced. Note that mount also missed
> the relatime option to begin with.
  I don't mind the discrepancy between /etc/mtab and /proc/mounts that much
(/proc/mounts is a fine replacement of /etc/mtab for me) but I agree that
handling of mount options on remount is a mess and IMHO it's made even
worse by mount(8) adding options from /etc/mtab to mount(2) syscall when
-o remount is specified. But realistically I can hardly imagine how to fix
all this mess because I'd almost bet userspace depends on the behavior.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
