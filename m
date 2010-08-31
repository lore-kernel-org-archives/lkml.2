Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab0HaUPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 16:15:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54783 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab0HaUPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 16:15:54 -0400
MIME-Version: 1.0
In-Reply-To: <4C7D5D60.1070203@am.sony.com>
References: <AANLkTimJkPD=shB9oi3ASocaLEpG=C7oDJMbq8BEy2Fe@mail.gmail.com>
	<4C7D5D60.1070203@am.sony.com>
Date: Tue, 31 Aug 2010 21:15:53 +0100
Message-ID: <AANLkTin0EYzHAXBOeyAPxMXkskRXY-Lqj3ND+gsnH8E9@mail.gmail.com>
Subject: Re: [RFC] Kernel 'boot cache' to reduce boot time
From: Andrew Murray <amurray@mpcdata.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux kernel <linux-kernel@vger.kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 31 August 2010 20:52, Tim Bird <tim.bird@am.sony.com> wrote:
> Having said that, I don't think that probing of static
> hardware is a solved problem, by any means.
>
> For the boot cache data, you are going to need to figure
> out how to make the data persistent.  Doing something
> in a regular fashion (rather than ad-hoc via command line
> options) should help with this.
Yes I wanted to see if the community was interested in the general
idea before I considered the implementation in too much detail. Though
the two obvious choices spring to mind. 1) Simply serialise and print
any suitable values to the console - these can be parsed with a
bootscript much like the way you parse initcall_debug. 2) Output these
values to a proc file which the use can extract.

The difficult part as I see it - is passing it back to the kernel - as
you suggested they may be some common ground with the device tree
models. Any suggestions?

I anticipate seeing name/value string pairs (or a small number of
types, e.g. int) - and leave it up to the driver to determine the best
way to serialise the data into the supported types. For example a
driver you may see the following pairs in a 'bootcache' file:
lpj=12313,drivers.media.video.decoder.ver=14,drivers.media.video.camera.type=pal
etc. I think the information encoded in this way would be a much
higher level that the typical register values used in suspend/resume
code.

>
> To some degree this might end up looking very similar
> to the "resume" path in the driver, where a particular
> device state is entered into from cold start.
I anticipated perhaps a simpler approach where instead of completely
getting rid of the probe - the probe simply skips time consuming paths
via this framework - I though this would make it easier for device
drivers to use the framework.

> Sorry for rambling.  Anyway - I'm all for the boot cache idea.
> But acceptability would, of course, be dependent on the
> details of the implementation.
>
> The best thing to get started, IMHO, would be to identify
> a few drivers which have long probe times, and see
> how they could reduce these with the proposed boot cache.
> If you find that each new device adds some new wrinkle
> in the cache requirements, that would be a bad sign.  But
> if different drivers, especially drivers in different functional
> areas, are found to be able to use a consistent API, then
> this could be a nice feature.
I agree.

>
> BTW - I could see this tying into the flattened device
> tree work by Grant Likely.
>  -- Tim
>
> P.S.  Also, I would recommend cross-posting to LKML
> to get wider visibility of your proposal.  I'm doing
> so in this response - I hope that's OK.

Thanks for the useful information - I'll read up on those slides.

Andrew Murray
