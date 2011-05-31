Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab1EaSF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:05:28 -0400
Received: from twin.jikos.cz ([89.185.236.188]:43643 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab1EaSFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:05:25 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 14:05:24 EDT
Date: Tue, 31 May 2011 19:57:09 +0200
From: David Sterba <dave@jikos.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: linux-next: build warninga in Linus' tree
Message-ID: <20110531175709.GC12709@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 30, 2011 at 11:36:53AM +1000, Stephen Rothwell wrote:
> After merging the Linus' tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
> 
> fs/btrfs/sysfs.c:76:26: warning: 'btrfs_root_attrs' defined but not used
> fs/btrfs/sysfs.c:97:26: warning: 'btrfs_super_attrs' defined but not used
> fs/btrfs/sysfs.c:153:13: warning: 'btrfs_super_release' defined but not used
> fs/btrfs/sysfs.c:160:13: warning: 'btrfs_root_release' defined but not used
> 
> I have started using gcc v4.5.2 (instead of v4.4.4) if that makes a
> difference.

the warning probably started to show up after one of my cleanup patches,
removing unused functions (f2a97a9dbd86eb1ef956bdf20e05c507b32beb96).
The sysfs interface is not being used right now, but there's a unmerged
patchset which adds the interesting bits like info about available btrfs
filesystems and devices. I don't know what are the intentions regarding
sysfs.


david
