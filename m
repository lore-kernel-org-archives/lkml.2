Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2DPMhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 08:37:15 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:35737
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753359Ab2DPMhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 08:37:13 -0400
Date: Mon, 16 Apr 2012 14:37:06 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: mtdchar kernel oops
In-Reply-To: <20120415215355.GS6589@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1204161329200.21808@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1204151350450.13924@eristoteles.iwoars.net> <20120415153220.GR6589@ZenIV.linux.org.uk> <alpine.DEB.2.00.1204151951560.16000@eristoteles.iwoars.net> <20120415215355.GS6589@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The troubled asm pair corresponds to this line:
this_cpu_add(mnt->mnt_pcp->mnt_count, n) in  the inline mnt_add_count().
So I suppose that perhaps either mnt is bad, or mnt_pcp is bad.

I'm using nandsim to simulate the mtd device. Steps are simple, load the
modules:
nand_ecc nand nand_ids mtd  mtd_blkdevs mtdblock mtdchar
nandsim first_id_byte=0x20 second_id_byte=0xa5 third_id_byte=0x00 fourth_id_byte=0x15 parts=0xa40 rptwear=1000

then `ubiformat /dev/mtd0` does the oops.

>
> Could you add printk into mtdchar_open(), dumping mnt and count values
> right after simple_pin_fs() call?
>

It oopses before it returns from the simple_pin_fs call, so that won't be
possible...

Cheers,
Joel
