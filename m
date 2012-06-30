Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2F3UnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 16:43:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59687 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2F3UnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 16:43:09 -0400
Date: Sat, 30 Jun 2012 23:43:03 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: dedekind1@gmail.com
Cc: Richard Genoud <richard.genoud@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: add minimal amount of reserved erase blocks in
 Kconfig
Message-ID: <20120630234303.148c612b@halley>
In-Reply-To: <1340974064.3070.177.camel@sauron.fi.intel.com>
References: <1340636918-7505-1-git-send-email-richard.genoud@gmail.com>
	<20120628205303.676fa2ea@halley>
	<1340974064.3070.177.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 29 Jun 2012 15:47:44 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > I'd expect a fixed number of 'beb_rsvd_level' PEBs for a given mtd
> > partition, or more correctly, as Richard suggests, the *sum* of bad PEBs
> > plus the beb reserved PEBs should be constant for a partition - as I
> > do not expect more than a known constant of blocks to go bad during
> > device's (and thus, partition's) lifetime.
> 
> Those days we did not have this "vendor-guaranteed max. bad blocks
> count" thing and I thought that UBI would try to always maintain a pool
> of reserved PEBs.
> 
> Would you send a patch?

Ok. I'll try to fiddle with UBI beb reserved arithmetics.

I thought to make it a gradual change.

First, change the semantics of CONFIG_MTD_UBI_BEB_RESERVE to be the
percent of total number of eraseblocks (instead of total number of
_good_ eraseblocks). And 'reserve' counts for both existing bad PEBs
and those reserved for future bad PEB handling.
Note this would still be % of the blocks in the mtd partition (and as
such, it is very loosely related to the MBB of the device, if at all).

Then, Richard may introduce the MBB parameter to ubiattach, and later
may kill CONFIG_MTD_UBI_BEB_RESERVE (if no longer needed). The
calculations will be according to the new parameter.

What do you say?

On a side note, the new ubiattach parameter should not be called MBB,
but rather a generic "reserved" (or "% reserved").

This is since the MBB is a property of the mtd nand device.
But the ubi user may issue, for the partition attached, a value other
than the device's MBB, according to his storage needs and
risks/securities he is willing to take.

Regards,
Shmulik
