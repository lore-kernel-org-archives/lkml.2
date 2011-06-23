Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab1FWLCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:02:36 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:36564 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab1FWLCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:02:35 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jun 2011 07:02:35 EDT
Date: Thu, 23 Jun 2011 12:53:37 +0200
From: Nico Schottelius <nico-lkml-20110623@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Mis-Design of Btrfs?
Message-ID: <20110623105337.GD3753@ethz.ch>
Mail-Followup-To: Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.39-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning devs,

I'm wondering whether the raid- and volume-management-builtin of btrfs is
actually a sane idea or not.
Currently we do have md/device-mapper support for raid
already, btrfs lacks raid5 support and re-implements stuff that
has already been done.

I'm aware of the fact that it is very useful to know on which devices
we are in a filesystem. But I'm wondering, whether it wouldn't be
smarter to generalise the information exposure through the VFS layer
instead of replicating functionality:

Physical:   USB-HD   SSD   USB-Flash          | Exposes information to
Raid:       Raid1, Raid5, Raid10, etc.        | higher levels
Crypto:     Luks                              |
LVM:        Groups/Volumes                    |
FS:         xfs/jfs/reiser/ext3               v

Thus a filesystem like ext3 could be aware that it is running
on a USB HD, enable -o sync be default or have the filesystem
to rewrite blocks when running on crypto or optimise for an SSD, ...

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
