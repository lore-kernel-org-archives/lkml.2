Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab0ERMS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:18:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61764 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0ERMSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:18:25 -0400
MIME-Version: 1.0
In-Reply-To: <1274182023.6930.7023.camel@macbook.infradead.org>
References: <AANLkTimB1DsCd8HuMDc9jgVOnOAE_PVd2ktssp3TIwxc@mail.gmail.com>
	 <1274105441.6930.6920.camel@macbook.infradead.org>
	 <1274182023.6930.7023.camel@macbook.infradead.org>
Date: Tue, 18 May 2010 15:18:25 +0300
Message-ID: <AANLkTikvuNiLD-n9Qvf10NmMU2KFQ25YPfM1oYfXtHE9@mail.gmail.com>
Subject: Re: [PATCH v5] mtd: Do not corrupt backing device of device node 
	inode
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 2:27 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2010-05-17 at 15:10 +0100, David Woodhouse wrote:
>> Now you're just reimplementing iget().
>>
>> Can we just use iget_locked() to get the appropriate inode (using the
>> mtd device number as the inode number)? Then we don't need to bother
>> storing it in mtd->inode at all, and we can iput() the last refcount on
>> it when the chardevice is closed -- we don't need it to stick around
>> until the MTD device is destroyed.
>
> ... and we don't _want_ it to stick around until the MTD device is
> destroyed, either. We may actually unload the mtdchar module and its
> inodes will be destroyed when we unregister the fs type; we don't want
> stale pointers to them hanging around to be reused if/when we reload the
> mtdchar module later.
>
> I've committed a version which keeps it entirely within the mtdchar
> code: http://git.infradead.org/mtd-2.6.git/commitdiff/cd874237

Looks ok. Thank you.

What about stable@?

>
> Thanks.
>
> --
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
>
>
