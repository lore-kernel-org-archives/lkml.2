Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0GFX6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 19:58:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661Ab0GFX6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 19:58:51 -0400
MIME-Version: 1.0
In-Reply-To: <4C33B883.6010206@kernel.org>
References: <20100630211516.GA25991@us.ibm.com>
	<AANLkTin6_LbGwRZm3GPDnyNb36v8G4DHqGno1mEXjmV0@mail.gmail.com>
	<20100630235949.GA5120@us.ibm.com>
	<20100702143515.2896d728@virtuousgeek.org>
	<4C33B883.6010206@kernel.org>
Date: Tue, 6 Jul 2010 16:58:14 -0700
Message-ID: <AANLkTiknAtUipCr64qwJXakD9VgqhHNp35KPq5x9_x8V@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port 
	resources
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       clemens@ladisch.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 6, 2010 at 4:13 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> So you want to use pci=override_bios to reallocate all bios assigned resource include
> peer root buses resources and pci bridge resource and pci devices BAR?

In a perfect world, we'd never need this at all, but sicne that's not
an option, the second-best alternative might be something like the
following:

  pci=override=off # default
  pci=override=conflict # override only on conflicts
  pci=override=<device> # clear BIOS allocations for <device> (and any
children, if it's a bus)

and possibly

  pci=override=always # ignore BIOS allocations entirely

although I suspect that last one isn't really usable, since at a
minimum you'd have to honor things that ACPI ends up depending on.
Which is pretty much always going to happen for _some_ device.

What I _don't_ think is a good idea is to call it "try=1" and "try=2"
which is entirely uncomprehensible. Also, I do think we have to
default to "override=off", since even the "only for conflicts"
obviously triggers problems.

                           Linus
