Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab1C3OqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:46:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60856 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1C3OqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:46:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
Date: Wed, 30 Mar 2011 16:45:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Lukas Czerner <lczerner@redhat.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20110328103431.GA22323@july> <alpine.LFD.2.00.1103301538580.3418@dhcp-27-109.brq.redhat.com> <AANLkTimA7tmaaw=8XZjaxs9qVOZMjYFCL=UnkJoKXqT=@mail.gmail.com>
In-Reply-To: <AANLkTimA7tmaaw=8XZjaxs9qVOZMjYFCL=UnkJoKXqT=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301645.57991.arnd@arndb.de>
X-Provags-ID: V02:K0:yd41rm4KVrH103SYucYpDOehiphgPS3VbQ8byM6aU7/
 +c/OEdwNLDLNdTXx1Oh37U5AHXApgrV9rTbTX16JDe/ORTTXD+
 UhfB6WST1oCSLzXumleG6ABrd2z9uW102Iq2EpoZrQAQeD8c4T
 Ddi/orrU0fKapkEOw4uq/TJmC4FjLxtv8f37k9JZudngE/USLh
 pGChHG1vQepxvFKD4h6/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, Kyungmin Park wrote:
> >> If you just pass the minimum length, the file system could end up
> >> erasing a 4 MB section that spans two half erase blocks, or it
> >> could span a few clusters of the following erase block, both of
> >> which is not desirable from a performance point of view.
> >
> > Does those cards export such information correctly ?
> 
> Each chip vendor knows it exactly and usually can't tell it outside officially.

I have written a tool for measuring the erase block size reliably
and guessing the page size.

> but it's not big as you think.

The largest erase block I have measured is 12 MB (on a USB stick),
while the smallest typical erase block that gets used in SDHC cards
is 2 MB. I have seen one card using a 1.5 MB erase block.

Older SD cards (up to 2 GB) commonly have erase blocks as small as 
128 KB, but for all I know these do not get produced any more. The
smallest cards on the market today are 2 GB cards with 2 MB erase
blocks.

> also if the request size is under trim size, then it's discarded internally.
> I mean do nothing at firmware level.

I don't think that's possible with SD cards, since the command is "erase",
not "trim", i.e. the data gets inaccessible after the command returns.

On eMMC, the command is actually "trim", which can probably be discarded
as you say.

SD cards can also do pre-erase when writing. This has similar meaning
as trim, but is not currently supported by Linux, because it is not
as easy to use.

	Arnd
