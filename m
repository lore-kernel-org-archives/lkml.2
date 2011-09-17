Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1IQOor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 10:44:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38361 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab1IQOop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 10:44:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
Date: Sat, 17 Sep 2011 17:44:44 +0300
Message-ID: <CAMP44s1ywhCV+FaudnwjwJUvj5Cf3_oz1M++kjXxRDGQpJ6-0w@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alex Deucher <alexdeucher@gmail.com>,
        Keith Packard <keithp@keithp.com>, linux-fbdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Archit Taneja <archit@ti.com>,
        "Clark, Rob" <rob@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 9:58 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
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

That's not true, many drivers work around the lack of features in the
fb API by providing custom interfaces. For example, in omapfb it's
possible to use the overlays from user-space, configure some YUV
format, do vsink, and multipages just fine:

https://github.com/felipec/gst-omapfb/blob/master/omapfb.c

It's perfect to render video clips. Of course, it would be even better
if those custom interfaces were merged into the fb API.

-- 
Felipe Contreras
