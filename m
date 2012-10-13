Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2JMLj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 07:39:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59283 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2JMLj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 07:39:57 -0400
Message-ID: <1350128388.1917.1.camel@kjgkr>
Subject: Re: [PATCH 02/16] f2fs: add on-disk layout
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?euc-kr?Q?=B1=E8=C0=E7=B1=D8?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Sat, 13 Oct 2012 20:39:48 +0900
In-Reply-To: <1557307.tHJJu7g4Ig@wuerfel>
References: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
	 <1557307.tHJJu7g4Ig@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-12 (금), 21:05 +0000, Arnd Bergmann:
> On Friday 05 October 2012 20:56:44 김재극 wrote:
> > +struct f2fs_nat_entry {
> > +       __u8 version;
> > +       __le32 ino;
> > +       __le32 block_addr;
> > +} __packed;
> > +
> > +struct f2fs_nat_block {
> > +       struct f2fs_nat_entry entries[NAT_ENTRY_PER_BLOCK];
> > +} __packed;
> 
> Using "__packed" on structure is rather inefficient on CPU architectures
> that cannot do aligned accesses. I would suggest you remove this
> attribute everywhere you can. The f2fs_nat_entry is particularly
> suboptimal because it is 9 bytes long, and I'm not sure if this
> can be reasonably changed to a multiple of four.
> 
> In all other cases, you should try to lay out the structures
> so that each member is naturally aligned and you don't need any __packed
> attributes, in particular for those that are accessed a lot.
> 

Ok, I'll check all the in-memory data structures.
Thank you for comments.

> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

