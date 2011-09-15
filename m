Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934511Ab1IOTSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:18:47 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52209 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934209Ab1IOTSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:18:46 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+LFzE2gxuL68JmKWneBpdV85pGhRzIPSxoK1yw+p
	38oTeqrODFtdGc
Message-ID: <4E724F93.1050203@gmx.de>
Date: Thu, 15 Sep 2011 19:18:43 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Alex Deucher <alexdeucher@gmail.com>, Keith Packard <keithp@keithp.com>,
        linux-fbdev@vger.kernel.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>, "Clark, Rob" <rob@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
References: <1316088425.11294.78.camel@lappyti>	<yunboul7sx7.fsf@aiko.keithp.com>	<1316100594.23214.65.camel@deskari>	<yun8vpp7qk7.fsf@aiko.keithp.com>	<4E72320B.6020000@gmx.de>	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>	<4E724659.5080709@gmx.de> <20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
In-Reply-To: <20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 06:58 PM, Alan Cox wrote:
>> Well, I rather think that the fb API is more user centric to allow every program
>> to use it directly in contrast to the KMS/DRM API which aims to support every
>> feature the hardware has. For this the fb API should not change much, but I
>> understand some additions were needed for some special users, probably limited
>> to X and wayland.
> 
> Wayland needs vblank frame buffer switching and the like. Likewise given
> you want to composite buffers really any serious accelerated device ends
> up needing a full memory manager and that ends up needing a buffer
> manager. Wayland needs clients to be doing their own rendering into
> objects which means authorisation and management of the render engine
> which ends up looking much like DRM.

As you have DRM now and as I'm not interested in wayland I won't discuss this,
but I guess it might be a good start for Geert's question what would be needed
to use it on dumb framebuffers.

>> One of my biggest problems with KMS is that it has (naturally) a lot more
>> complexity than the fb API which leads to instability. Basically it's very
> 
> It shouldn't do - and a sample of one (your machine) is not a
> statistically valid set. Fb is pretty much ununsable in contrast on my
> main box, but that's not a statistically valid sample either.
> 
> I'm not that convinced by the complexity either. For a simple video card
> setup such as those that the fb layer can kind of cope with (ie linear
> buffer, simple mode changes, no client rendering, no vblank flipping,
> limited mode management, no serious multi-head) a DRM driver is also
> pretty tiny and simple.

Yes, if you limit DRM to the functionality of the fb API I guess you could reach
the same stability level. But where can I do this? Where is a option to forbid
all acceleration or at least limit to the acceleration that can be done without
any risk?

>> Well, I think it's too late to really fix this thing. We now have 3 APIs in the
>> kernel that have to be kept. Probably the best we can do now is figure out how
>> we can reduce code duplication and do extensions to those APIs in a way that
>> they are compatible with each other or completely independent and can be used
>> across the APIs.
> 
> I think it comes down to 'when nobody is using the old fb drivers they can
> drop into staging and oblivion'. Right now the fb layer is essentially
> compatibility glue on most modern x86 platforms.

That's a really difficult question. Determining the users is difficult and there
are people that use their hardware very long, for example we are about to get a
new driver for i740. For the framebuffer infrastructure I guess you have to at
least wait for my death.


Regards,

Florian Tobias Schandinat
