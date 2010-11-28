Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab0K1FES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 00:04:18 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51857 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab0K1FEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 00:04:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o1tJEy+CdWlObhltH1HIlNn+Ia4fD4xWouQWFgLZsnjGBo8tbNiogoGpLmGb9j6geu
         Rwg0Y6cgDlHuBDbRtx2MPJQchF3WFyUrhiFMJr3lIHtrFsoPyX/owq5wELDNVN6IDnYC
         CTmccBuAuN1GQojWcuElWhRbAn0tZd8eveYDQ=
Date: Sat, 27 Nov 2010 23:04:07 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sage Weil <sage@newdream.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] vfs: introduce FS_IOC_SYNCFS to sync a single super
Message-ID: <20101128050407.GA16903@burratino>
References: <Pine.LNX.4.64.1008090711040.17515@cobra.newdream.net>
 <20100826170142.e029cff5.akpm@linux-foundation.org>
 <20101127223217.GA26820@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101127223217.GA26820@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder wrote:

> Since
> ancient times, that has been done with the "rename trick":
[...]
> Great.  Problem is, filesystems with delayed allocation like XFS,
> ubifs, ext4, hfs+ don't cope so well with that[1].
[...]
> [1] Yes, even after v2.6.30-rc1~416^2~15 (ext4: Automatically allocate
> delay allocated blocks on rename, 2009-02-23).
> See https://bugzilla.kernel.org/show_bug.cgi?id=18632

Sorry, wrong link.  The example meant was

	https://bugzilla.kernel.org/show_bug.cgi?id=15910

"zero-length files and performance degradation", reported against 2.6.32:

| To reproduce it:
| * install a fresh Ubuntu Lucid system on an ext4 filesystem, or Debian with
| dpkg < 1.15.6 or Ubuntu Karmic
| * install a package, wait a few seconds and simulate a crash 
| $ sudo apt-get install some-package; sleep 5; sudo echo b > /proc/sysrq-trigger
| * reboot
| $ ls -l /var/lib/dpkg/info/some-package.* will list empty maintainer's scripts.
| $ ls -l /var/cache/apt/archive/some-package.* will show the empty archive
| you've just downloaded
| At this stage, the package manager is unusable and the common user cannot
| update anything anymore.
|
| This behavior is observed with data=ordered and with or without the mount
| option auto_da_alloc.

Sorry for the confusion.
Jonathan
