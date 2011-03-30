Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1C3SZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:25:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51516 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab1C3SZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:25:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/1] new module for amba axi on-chip interconnect
Date: Wed, 30 Mar 2011 20:24:49 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>, gregkh@suse.de,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>, devel@linuxdriverproject.org,
        akpm@linux-foundation.org
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <201103301509.04899.arnd@arndb.de> <20110330174010.GA2939@n2100.arm.linux.org.uk>
In-Reply-To: <20110330174010.GA2939@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103302024.49921.arnd@arndb.de>
X-Provags-ID: V02:K0:1+1L2mwN/rYqPZFI1EXicFtj2sdjX1uXVO+lnkqPR+N
 fNKC4xw3jCUbaF+XJAbi4uE0VqboPsv/FxZOg+MmnLUm6lwADD
 Z1MfKzjU8u8gFSyck7j8SDMt4ddrE957BLthQE9+2QrbCRhe6e
 eKEJEsxxgXdiSYmMOtnrr/SZtk2hJbaUpytqNeid0jftYKzK6L
 VjKPuO+TPNgxOmqIxSqaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011 19:40:10 Russell King - ARM Linux wrote:

> The reason we don't do automatic scanning (which we could on the various
> ARM platforms) is because of the platform data necessary to make some of
> the primecell drivers work.
> 
> Unfortunately, these buses are not as simple as PCI, where a device
> typically sits on its own card and is totally self-contained.  With
> primecell stuff, there's normally some interdependencies between the
> various primecells.
> 
> That doesn't stop there being an automatic enumeration layer, but such
> a layer would need some way of attaching platform specific data to
> specific amba devices.

Right, I understand that this would not completely remove the need for
platform devices, but I think it would be a great step in the right
direction if we could scan all simple devices automatically, or
possibly even all devices in some simple machines.

If we can scan the main resources (memory ranges, interrupts, ...),
that will make it possible to avoid a whole lot of the stuff we currently
do for each new board. It also means we can gradually move away from
statically defined devices, something that Greg has been pushing for
quite some time.

The device tree work has shown that it's possible to describe very
complex hardware in simple data structures, but it would be much
better if we needed neither a device tree nor a board file for this.
As you say, this isn't possible today with the data on available
to the AMBA bus, but I think it would be better to just fill in 
the blanks (and corrections where they are wrong) than to duplicate
all of it as we now do in the kernel.

Ideally, we would point SoC companies to this (or a future extended
version) as the place to add all the required information when
they want the drivers to work out of the box. My impression is that
there is no fundamental difference to buses like PCI or USB, other
than that there is more data required to encode and that there is
a lack of social pressure to get it right. I remember PCI cards
from the 1990s that could not be probed properly and required
setting a lot of module parameters copied from a web site depending
on what hardware you had bought. The reason we don't have that 
as much today is that the manufacturers realized that it's impossible
to write proper drivers if you cannot detect the hardware.

	Arnd
