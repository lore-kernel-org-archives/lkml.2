Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2CILIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 06:08:16 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54615 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2CILIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 06:08:15 -0500
MIME-Version: 1.0
In-Reply-To: <20120309105537.GG4334@twin.jikos.cz>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
	<20120308155211.GF4334@twin.jikos.cz>
	<CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
	<4F595D6D.6080809@cn.fujitsu.com>
	<20120309105537.GG4334@twin.jikos.cz>
Date: Fri, 9 Mar 2012 12:08:12 +0100
Message-ID: <CADDYkjRcRbxxPErdMBOs55-gNHZA0GfxcsWNrVbAuv37b3rtvw@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
From: Jacek Luczak <difrost.kernel@gmail.com>
To: dave@jikos.cz, Liu Bo <liubo2009@cn.fujitsu.com>,
        Jacek Luczak <difrost.kernel@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/9 David Sterba <dave@jikos.cz>:
> On Fri, Mar 09, 2012 at 09:31:25AM +0800, Liu Bo wrote:
>> > There were quite many things happening in the system at that time.
>> > Can't really tell what could trigger this.
>> >
>> > Complete logs: http://91.234.146.107/~difrost/logs/tampere_log.gz
>> >
>> So are these warnings based on the latest upstream of btrfs?
>
> No, from the log it's 3.2.7, so it does not conain the patch
>
> "increase the global block reserve estimates"
>
> the log shows lots of messages
>
> Mar  8 13:36:37 kernel: use_block_rsv: 7 callbacks suppressed
> Mar  8 13:36:37 kernel: ------------[ cut here ]------------
> Mar  8 13:36:37 kernel: WARNING: at fs/btrfs/extent-tree.c:5985 btrfs_alloc_free_block+0xc5/0x292 [btrfs]()
> ...
> Mar  8 13:36:37 kernel:  [<ffffffffa031161f>] ? btrfs_alloc_free_block+0xc5/0x292 [btrfs]
> Mar  8 13:36:37 kernel:  [<ffffffff8106901d>] ? warn_slowpath_common+0x78/0x8d
> Mar  8 13:36:37 kernel:  [<ffffffffa031161f>] ? btrfs_alloc_free_block+0xc5/0x292 [btrfs]
> Mar  8 13:36:37 kernel:  [<ffffffffa032bbad>] ? btrfs_item_offset+0x2c/0x61 [btrfs]
> Mar  8 13:36:37 kernel:  [<ffffffffa03007dc>] ? leaf_space_used+0x86/0xb5 [btrfs]
> Mar  8 13:36:39 kernel:  [<ffffffffa0304a7a>] ? split_leaf+0x2d9/0x632 [btrfs]
> Mar  8 13:36:39 kernel:  [<ffffffffa0306261>] ? btrfs_search_slot+0x6c1/0x75a [btrfs]
> Mar  8 13:36:40 kernel:  [<ffffffffa0306e6e>] ? btrfs_insert_empty_items+0x61/0xab [btrfs]
> Mar  8 13:36:41 kernel:  [<ffffffffa032207c>] ? insert_inline_extent+0xea/0x2d4 [btrfs]
> Mar  8 13:36:41 kernel:  [<ffffffffa0322389>] ? cow_file_range_inline+0x123/0x163 [btrfs]
> ...

For this one I've created also a report [1].

>
> so there is probably other problem in reservations and it just blew up during
> the unlink call.

Could be as this came up after a longer time of throwing above WARN_ON.

I'm now cloning the Linus tree. Lets see if both will pop up on there.

-Jacek

[1] http://www.spinics.net/lists/linux-btrfs/msg15404.html
