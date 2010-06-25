Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0FYJP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:15:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51176 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab0FYJP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:15:56 -0400
From: Andi Kleen <andi@firstfloor.org>
To: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Cc: "Mike Fedyk" <mfedyk@mikefedyk.com>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Mat" <jackdachef@gmail.com>, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, "Chris Mason" <chris.mason@oracle.com>,
       "Ric Wheeler" <rwheeler@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "The development of BTRFS" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs: broken file system design
References: <4C07C321.8010000@redhat.com>
	<AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
	<4C1B7560.1000806@gmail.com>
	<AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com>
	<4C1BA3E5.7020400@gmail.com> <20100623234031.GF7058@shareable.org>
	<469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>
	<AANLkTil5Gl0-rWClRsLZby_c37bQu5RB_tCgHsxTFshO@mail.gmail.com>
	<469D2D911E4BF043BFC8AD32E8E30F5B24AEBB@wdscexbe07.sc.wdc.com>
Date: Fri, 25 Jun 2010 11:15:55 +0200
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEBB@wdscexbe07.sc.wdc.com>
	(Daniel Taylor's message of "Thu, 24 Jun 2010 15:06:03 -0700")
Message-ID: <87hbkrealw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Daniel Taylor" <Daniel.Taylor@wdc.com> writes:
>
> As long as no object smaller than the disk block size is ever
> flushed to media, and all flushed objects are aligned to the disk
> blocks, there should be no real performance hit from that.

The question is just how large such a block needs to be.
Traditionally some RAID controllers (and possibly some SSDs now) 
needed very large blocks upto MBs.

>
> Otherwise we end up with the damage for the ext[234] family, where
> the file blocks can be aligned, but the 1K inode updates cause
> the read-modify-write (RMW) cycles and and cost >10% performance
> hit for creation/update of large numbers of files.

Fixing that doesn't require a new file system layout, just some effort
to read/write inodes in batches of multiple of them. XFS did similar
things for a long time, I believe there were some efforts for this
for ext4 too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
