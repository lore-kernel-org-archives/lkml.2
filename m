Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab1EWPKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:10:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61912 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1EWPKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:10:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110523095829.GG17672@n2100.arm.linux.org.uk>
References: <1305829704-11774-1-git-send-email-robherring2@gmail.com>
 <20110519233958.GB18181@ponder.secretlab.ca> <4DD66B8A.5040404@gmail.com>
 <201105201621.03801.arnd@arndb.de> <4DD68614.6090209@gmail.com>
 <a42f0c27-2811-4b68-bedf-7dfaa7bff6ff@VA3EHSMHS025.ehs.local>
 <BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com> <4DDA2AC0.1060406@gaisler.com>
 <20110523095829.GG17672@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 23 May 2011 09:09:41 -0600
X-Google-Sender-Auth: _r10oxzo_y-px33CLFHB2KoWfTw
Message-ID: <BANLkTink1rrC8F3Gjhqt84gYzOibX+AgDQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] drivers/amba: probe via device tree
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kristoffer Glembo <kristoffer@gaisler.com>, Kevin Hilman <khilman@ti.com>,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 3:58 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, May 23, 2011 at 11:37:04AM +0200, Kristoffer Glembo wrote:
>> Grant Likely wrote:
>> > In the case we're talking about the bus really is an AMBA bus, and all
>> > the devices on it are in some sense real amba devices.  The problem is
>> > that not all of the devices on the bus implement peripheral ID
>> > registers or other mechanisms that good upstanding AMBA devices are
>> > expected to have.
>>
>> Before we go hardware bashing of non primecell AMBA devices I would just
>> want to point out that the primecell stuff is not part of the AMBA
>> specification.
>
> And before we go down that route, let me point out that the 'amba bus'
> stuff in the kernel is there to support primecells, rather than all
> devices which the AMBA specification covers.
>
> The reason it's called 'amba' is because back in 2001 or so when the
> first primecell drivers were created, there was little information
> available as to what AMBA, AHB, or APB even covered.  All I had to go
> on were the primecell documents themselves.  The higher level documents
> were not available to me.
>
> So, despite it being called 'amba', it really is just for primecells
> and if we didn't have the exposure to userspace, I'd have renamed it to
> 'apb' or similar instead.

Okay, that clarifies things a lot, and lends weight to the arguement
that it is perfectly normal and acceptable to have both amba_devices
and platform_devices on the same bus segment.  Are there any cases
where amba primecells are being driven by platform_drivers?  If so,
should those drivers have an amba_driver registration added?

g.
