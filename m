Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab2CHPwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:52:18 -0500
Received: from twin.jikos.cz ([89.185.236.188]:51001 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab2CHPwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:52:17 -0500
Date: Thu, 8 Mar 2012 16:52:11 +0100
From: David Sterba <dave@jikos.cz>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Message-ID: <20120308155211.GF4334@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Jacek Luczak <difrost.kernel@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 01:10:45PM +0100, Jacek Luczak wrote:
> kernel BUG at fs/btrfs/delayed-inode.c:1466!

1461         ret = btrfs_delayed_item_reserve_metadata(trans, root, item);
1462         /*
1463          * we have reserved enough space when we start a new transaction,
1464          * so reserving metadata failure is impossible.
1465          */
1466         BUG_ON(ret);

> RAX: 00000000ffffffe4

ENOSPC

>  [<ffffffffa03210e5>] ? __btrfs_unlink_inode+0x172/0x25e [btrfs]
>  [<ffffffffa032158c>] ? btrfs_rename+0x38b/0x55b [btrfs]

rename reserves 20 blocks, but seems that's not enough.  I've never seen
a crash report in rename, and according to the stacktrace there's
nothing suspicious (like selinux related).


david
