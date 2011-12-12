Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab1LLImh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 03:42:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1LLIme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 03:42:34 -0500
Date: Mon, 12 Dec 2011 09:42:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH RFC V2 0/4] Add "scope" to power supplies
In-Reply-To: <cover.1323454016.git.jeremy@goop.org>
Message-ID: <alpine.LNX.2.00.1112120941380.21970@pobox.suse.cz>
References: <cover.1323454016.git.jeremy@goop.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011, Jeremy Fitzhardinge wrote:

> This series adds a "scope" attribute to power supplies, to indicate
> whether it powers the whole system ("System") or just some subset of
> the devices ("Device").  This allows upowerd to distinguish between
> system-wide power supplies and self-powered devices such as cordless
> mice.
> 
> This series also adds a "powers" link to power supplies, so that if
> they're scope=Device, they can specifically indicate which device
> tree they power.
> 
> Updates since last post:
>  - Add more complete documentation to scope and "powers" links
>  - Remove unnecessary scopes on System power supplies
>  - Make HID battery supplies Device, and add "powers" pointers
>    for them.
> 
> This can also be pulled from:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git power-supply-scope
> 
> Jeremy Fitzhardinge (4):
>   power_supply: add SCOPE attribute to power supplies
>   power_supply: allow a power supply to explicitly point to powered
>     device
>   power_supply: add scope properties to some self-powered HID devices
>   power_supply: add "powers" links to self-powered HID devices
> 
>  drivers/hid/hid-wacom.c            |   16 ++++++++++++++--
>  drivers/hid/hid-wiimote.c          |   10 +++++++++-
>  drivers/power/power_supply_core.c  |    7 +++++++
>  drivers/power/power_supply_sysfs.c |    6 ++++++
>  include/linux/power_supply.h       |    8 ++++++++
>  5 files changed, 44 insertions(+), 3 deletions(-)

Anton, in case you are going to take this patchset, I think it makes sense 
to take it through your tree. In that case, please add

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

to the two patches touching drivers/hid/. Thanks,

-- 
Jiri Kosina
SUSE Labs
