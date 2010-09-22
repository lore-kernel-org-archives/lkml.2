Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0IVXCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 19:02:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:23429 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab0IVXCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 19:02:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,220,1283756400"; 
   d="scan'208";a="660143745"
Date: Wed, 22 Sep 2010 23:15:14 +0100
From: Alan Cox <alan@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100922231514.5e9967c7@linux.intel.com>
In-Reply-To: <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
	<20100920150431.GD31167@sirena.org.uk>
	<20100920152726.68ac2d84@linux.intel.com>
	<20100920152705.GJ3414@rakim.wolfsonmicro.main>
	<AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Okay, before I start a long rant I'll start with this disclaimer; at
> least this patch is isolated to the mrst platform so that it doesn't
> impact the rest of the kernel.  Feel free to take the stance that this
> is platform specific code and therefore will never have to handle the
> general-case of multiple machines.  In that case each machine will
> need to have a separate copy of this functionality, but at least the
> damage is contained. </disclaim>

Simple answer to this. It's intended that SFI will be used on certain
Intel MID platforms. I am hopeful that something more sensible will
happen with future firmware for future platforms but for existing MID
platforms its not negotiable, we either support SFI or we don't run on
them.

> This will be an utter nightmare to maintain over the long term.  It

Intel will be maintaining it. While I can't speak for Intel on the
matter my personal way of seeing this is "our turd, our shovel" and its
localised so there will be no funny smells elsewhere.

> combines the worst parts of both static device tables and firmware
> data parsers.  From the former it uses large statically allocated
> tables that cannot be either extended or freed at runtime which is
> unfriendly for multiplatform kernels.

I know this. I've been managing it internally for a while. I have a
deeper understanding than I want but the SFI side is fixed and better
firmware design is a thing that you talk about now for products 'n'
years down the line because of the way all the
design/bringup/development for plaforms works.

In truth SFI is closer to being a device enumeration than a
configuration description.

> adding another.  It is already an uphill battle to convince device
> driver maintainers that adding device tree parsing code (appropriately
> contained) to .probe() hooks is the right thing to do.  Asking them to
> also support SFI hooks (plus the next firmware-interface-of-the-month)
> is likely to end in a revolt.

You need to look at the code again. There is *no* SFI specific hookery
in drivers. In fact I have been going around removing that from code as
we submit drivers upstream  - and rightfully if I didn't the i²c
maintainers and the like would reject the code.

If a driver wants device tree the SFI parser would ideally supply it
with device tree. If the entire kernel goes device tree I will whoop
with joy and make SFI use it.

> Since data in the tree is free-form key-value properties, any
> device-specific SFI data can be imported into the tree verbatim to
> eliminate the risk that critical data will get discarded in the
> translation process.  Well understood properties, like address ranges,
> IRQs and GPIOs would be straight forward to translate into the device
> tree form to make it parsable by common code.

In the idea world SFI would be replaced with a self describing
expandable data format that translated neatly into whatever we needed,
and the kernel drivers we are re-using would have corresponding
interfaces. Lots of people understand this, but it simply won't happen
for these existing SFI platforms.

In the real world they don't - yet, but if they do we'll be happy to
join the revolution.

Alan
