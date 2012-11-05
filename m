Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2KEUOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:14:37 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34091 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2KEUOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:14:35 -0500
MIME-Version: 1.0
In-Reply-To: <18667A4E-5513-4D74-922F-30D091609F16@antoniou-consulting.com>
References: <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
 <20121101110418.GF410@arwen.pp.htv.fi> <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
 <20121101124025.GA12489@arwen.pp.htv.fi> <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
 <20121101131609.GC12489@arwen.pp.htv.fi> <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
 <20121101135148.382aec00@pyramind.ukuu.org.uk> <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com>
 <20121101220518.GE14982@arwen.pp.htv.fi> <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com>
 <20121102112104.4657fb7b@pyramind.ukuu.org.uk> <0EC43413-1DD7-4E2A-879B-0B5B926FFDFE@antoniou-consulting.com>
 <CACxGe6uuK6ew5uxh0BjtYAtPZCTLeUpHc4emXRAnMUtNmEzmGg@mail.gmail.com>
 <AC5129F0-FF30-46ED-AD57-3FA6CA919F99@antoniou-consulting.com>
 <CACxGe6v9cyybV4+5tQJ-DG8qdyEHfsLa7t+-3CTL+97Q9msrFw@mail.gmail.com> <18667A4E-5513-4D74-922F-30D091609F16@antoniou-consulting.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 5 Nov 2012 20:14:15 +0000
X-Google-Sender-Auth: FPcVhLBferzC3ac0zkUhEsu5wbs
Message-ID: <CACxGe6uR5VhHsCS1vmayURkGBKmhagaeWBBaCnyfsfOjZ2Dutg@mail.gmail.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Russ Dill <Russ.Dill@ti.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 7:54 PM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
>> This handles many of the use cases, but it assumes that an overlay is
>> board specific. If it ever is required to support multiple base boards
>> with a single overlay file then there is a problem. The .dtb overlays
>> generated in this manor cannot handle different phandles or nodes that
>> are in a different place. On the other hand, the overlay source files
>> should have no problem being compiled for multiple targets, so maybe
>> it isn't an issue. Plus if dtc is installed on the target, then the
>> live tree from /proc can be used as the reference when compiling the
>> overlay.
>
> My worry is that this format is dependent on linking against the board
> DTS file. One of the ideas thrown around here was that it might make
> sense to store the DTB fragment in the EEPROM of the device.

Right, that wouldn't work well if the base DT changed, or if a
BeagleBone2 is released that has the same header configuration, but
different backing devices. It would be nice to have a solution for
that.

> In that case you have a OS independent hardware description, which can
> be even used even by the bootloader to access devices it knows not about
> at compile time.
>
> Other than that, I have no other objections.

I'm open to suggestions if anyone has any. I have not objections to a
fixup approach, but I'm not comfortable with anything that is fragile
to modifications to the fragment.

g.
