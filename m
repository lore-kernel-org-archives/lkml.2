Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2KEX6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:58:38 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38836 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab2KEX6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:58:37 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAD=GYpYc9L5yKqgar5jB2jG8+GiX7Lb0zevP9Pxaq0HdaVXQ5Q@mail.gmail.com>
References: <50924DA3.1060901@ti.com> <20121101124025.GA12489@arwen.pp.htv.fi> <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com> <20121101131609.GC12489@arwen.pp.htv.fi> <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com> <20121101135148.382aec00@pyramind.ukuu.org.uk> <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com> <20121101220518.GE14982@arwen.pp.htv.fi> <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com> <20121102112104.4657fb7b@pyramind.ukuu.org.uk> <0EC43413-1DD7-4E2A-879B-0B5B926FFDFE@antoniou-consulting.com> <CACxGe6uuK6ew5uxh0BjtYAtPZCTLeUpHc4emXRAnMUtNmEzmGg@mail.gmail.com> <AC5129F0-FF30-46ED-AD57-3FA6CA919F99@antoniou-consulting.com> <CACxGe6v9cyybV4+5tQJ-DG8qdyEHfsLa7t+-3CTL+97Q9msrFw@mail.gmail.com> <18667A4E-5513-4D74-922F-30D091609F16@antoniou-consulting.com> <CACxGe6uR5VhHsCS1vmayURkGBKmhagaeWBBaCnyfsfOjZ2Dutg@mail.gmail.com> <CAD=GYpYc9L5yKqgar5jB2jG8+GiX7Lb0zevP9Pxaq0HdaVXQ5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 05 Nov 2012 23:58:25 +0000
To: Joel A Fernandes <agnel.joel@gmail.com>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Russ Dill <Russ.Dill@ti.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <robherring2@gmail.com>
Message-ID: <7dbed965-f75d-4ad3-9f88-4c3cd0b9e602@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Joel A Fernandes <agnel.joel@gmail.com> wrote:

>Hi Grant,
>
>On Mon, Nov 5, 2012 at 2:14 PM, Grant Likely
><grant.likely@secretlab.ca> wrote:
>> I'm open to suggestions if anyone has any. I have not objections to a
>> fixup approach, but I'm not comfortable with anything that is fragile
>> to modifications to the fragment.
>
>I am fairly new to the DT world so please bear with me, but how about
>a method that resolves symbols the same way that the linux dynamic
>linker does when shared libraries are loaded?
>
>A separate table (similar to .PLT/GOT sections  in the ELF object
>format) could be created when the fragment is loaded, and the phandle
>references could be fixed to point to the table offsets during compile
>time. This table would be a second level indirection and the kernel
>would populate this table with the in-kernel values of the phandles
>that the dt fragment refers to.

That's an interesting idea that is worth exploring. That would make it possible to avoid a fixup stage, but it also means that any parsing code must know how to handle the got-like table. It won't be backwards compatible with existing tools. It also wouldn't easily support the case of firmware applying the overlay and passing the resulting tree to the kernel. Hmmm.... Not being backwards compatible at the data level is a big problem. I really want a method that can resolve back to the current data format or is a compatible extension of it.

>
>This might involve changes to the DT core, but as such, this method
>wouldn't suffer from the fragility problem of either base or fragment
>DT trees being modified.
>
>The table itself could be added to the tree by the compiler, and the
>phandles could point to it (fixed). such phandles could be marked for
>special handling to facilitate the 1-level indirection.

That's part of the problem. Property values are essentially anaonymous data. There is no mechanism currently for marking data such as indicate which data values are phandles. If there were then it would be a simple matter to find all the phandles and fix them up.

We could possibly add data type suppplementary properties to the tree to solve that problem. They would have to be optional for the base tree to retain backwards compatibility, but could be required on overlays.

g.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
