Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1FCO46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:56:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29755 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab1FCO4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:56:55 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: dave <dave@jikos.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Miao Xie <miaox@cn.fujitsu.com>, Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix uninitialized variable warning
In-reply-to: <20110603145014.GU12709@twin.jikos.cz>
References: <20110603110011.77121203.sfr@canb.auug.org.au> <20110603145014.GU12709@twin.jikos.cz>
Date: Fri, 03 Jun 2011 10:56:18 -0400
Message-Id: <1307112880-sup-4802@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DE8F620.008C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from David Sterba's message of 2011-06-03 10:50:14 -0400:
> From: David Sterba <dsterba@suse.cz>
> 
> With Linus' tree, today's linux-next build (powercp ppc64_defconfig)
> produced this warning:
> 
> fs/btrfs/delayed-inode.c: In function 'btrfs_delayed_update_inode':
> fs/btrfs/delayed-inode.c:1598:6: warning: 'ret' may be used
> uninitialized in this function
> 
> Introduced by commit 16cdcec736cd ("btrfs: implement delayed inode items
> operation").
> 
> This fixes a bug in btrfs_update_inode(): if the returned value from
> btrfs_delayed_update_inode is a nonzero garbage, inode stat data are not
> updated and several call paths may hit a BUG_ON or fail with strange
> code.

Ugh, thanks!  It looks like the gcc uninit stuff isn't as verbose as it
used to be, but it does catch a bunch of allocated/set but not used
vars.

I have a nitems = 0 fix in my tree as well.

-chris
