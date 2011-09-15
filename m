Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934327Ab1IORwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:52:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46153 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040Ab1IORwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:52:08 -0400
MIME-Version: 1.0
In-Reply-To: <4E72320B.6020000@gmx.de>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
Date: Thu, 15 Sep 2011 13:52:06 -0400
Message-ID: <CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Alex Deucher <alexdeucher@gmail.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Keith Packard <keithp@keithp.com>, linux-fbdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Archit Taneja <archit@ti.com>,
        "Clark, Rob" <rob@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 1:12 PM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> On 09/15/2011 03:50 PM, Keith Packard wrote:
>> On Thu, 15 Sep 2011 18:29:54 +0300, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>>
>>> 1) It's part of DRM, so it doesn't help fb or v4l2 drivers. Except if
>>> the plan is to make DRM the core Linux display framework, upon which
>>> everything else is built, and fb and v4l2 are changed to use DRM.
>>
>> I'd like to think we could make DRM the underlying display framework;
>> it already exposes an fb interface, and with overlays, a bit more of the
>> v4l2 stuff is done as well. Certainly eliminating three copies of mode
>> setting infrastructure would be nice...
>
> Interesting that this comes from the people that pushed the latest mode setting
> code into the kernel. But I don't think that this will happen, the exposed user
> interfaces will be around for decades and the infrastructure code could be
> shared, in theory.
> For fb and V4L2 I think we'll develop some level of interoperability, share
> concepts and maybe even some code. The FOURCC pixel formats and overlays are
> such examples. As Laurent is really interested in it I think we can get some
> nice progress here.
> For fb and DRM the situation is entirely different. The last proposal I remember
> ended in the DRM people stating that only their implementation is acceptable as
> is and we could use it. Such attitude is not helpful and as I don't see any
> serious intention of the DRM guys to cooperate I think those subsystems are more
> likely to diverge. At least I'll never accept any change to the fb
> infrastructure that requires DRM.

Not exactly.  This point was that the drm modesetting and EDID
handling was derived from X which has had 20+ years of of quirks and
things added to it to deal with tons of wonky monitors and such.  That
information should be preserved.  As mode structs and EDID handling
are pretty self contained, why not use the DRM variants of that code
rather than writing a new version?

While the DRM has historically targeted 3D acceleration, that is not a
requirement to use the DRM KMS modesetting API.  The current fb API
has no concept of display controllers or connectors or overlays, etc.
To match it to modern hardware, it needs a major overhaul.  Why create
a new modern fb interface that's largely the same as DRM KMS?  What if
we just consider the KMS API as the new fb API?  If there are any
inadequacies in the DRM KMS API we would be happy to work out any
changes.

Please don't claim that the DRM developers do not want to cooperate.
I realize that people have strong opinions about existing APIs, put
there has been just as much, if not more obstinacy from the v4l and fb
people.

Alex
