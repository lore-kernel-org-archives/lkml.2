Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1DAHrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:47:10 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:57617 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab1DAHrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:47:08 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: victor.vde@gmail.com, util-linux@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>, linuxram@us.ibm.com
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Victor van den Elzen <victor.vde@gmail.com>,
        "Eugene J. Markow" <ejmarkow@yahoo.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] libmount misparses mountinfo on Linux v2.6.39-rc1
In-Reply-To: <19860.58082.277944.875401@gargle.gargle.HOWL>
References: <19860.58082.277944.875401@gargle.gargle.HOWL>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Fri, 01 Apr 2011 13:16:23 +0530
Message-ID: <87d3l62z3k.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 22:24:01 +0200, victor.vde@gmail.com wrote:
> /proc/self/mountinfo on Linux v2.6.39-rc1 includes the UUID of ext4
> and ext3 mounts, for example:
> 
> 15 1 8:3 / / rw,noatime uuid:c645234d-9756-4d84-825e-6fe999252a34 - ext4 /dev/sda3 rw,user_xattr,acl,barrier=1,data=ordered
> 
> It seems the hyphens in the uuid confuse the parser
> mnt_parse_mountinfo_line in tab_parse.c of libmount in util-linux.

shouldn't the parser look for " " followed by "-" followed by " " as the
field seperator ? 

I am adding Miklos and Ram Pai to CC to check whether the kernel or the libmount 
should be fixed ?

> 
> My util-linux version is 2.19-4 Arch Linux.
> 
> ~ $ findmnt -l /
> TARGET SOURCE FSTYPE                      OPTIONS
> /      -      9756-4d84-825e-6fe999252a34 rw,noatime,ext4
> 
> For reference, the commits in Linus' tree that introduced these uuids
> are:
> 
> 93f1c20bc8cdb757be50566eff88d65c3b26881f vfs: Export file system uuid via /proc/<pid>/mountinfo
> 03cb5f03dcb26846fcad345d8c15aae91579a53d ext3: Copy fs UUID to superblock.
> f2fa2ffc2046fdc35f96366d1ec8675f4d578522 ext4: Copy fs UUID to superblock

-aneesh
