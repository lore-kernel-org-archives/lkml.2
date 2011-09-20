Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab1ITI31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 04:29:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45581 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1ITI3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 04:29:25 -0400
MIME-Version: 1.0
In-Reply-To: <1316417361.1978.48.camel@deskari>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<1316107275.23214.99.camel@deskari>
	<yunfwjxwbjq.fsf@aiko.keithp.com>
	<20110916175326.54567b14@lxorguk.ukuu.org.uk>
	<1316414014.1978.12.camel@deskari>
	<yunfwjtauqg.fsf@aiko.keithp.com>
	<1316417361.1978.48.camel@deskari>
Date: Tue, 20 Sep 2011 10:29:23 +0200
Message-ID: <CAMeQTsbP-_ut7BA3YQ+qgtqfM1tzM4qn3jxHT8B8_0hdPbP3Jg@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Keith Packard <keithp@keithp.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
        "Clark, Rob" <rob@ti.com>, Archit Taneja <archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 9:29 AM, Tomi Valkeinen wrote:
>> So DSI is more like i2c than the DisplayPort aux channel or DDC. That
>
> Well, not quite. DSI is like DisplayPort and DisplayPort aux combined;
> there's only one bus, DSI, which is used to transfer video data and
> commands.
>
> For DSI video mode, the transfer is somewhat like traditional displays,
> and video data is send according to a pixel clock as a constant stream.
> However, before the video stream is enabled the bus can be used in
> bi-directional communication. And even when the video stream is enabled,
> there can be other communication in the blanking periods.

This sounds a lot like SDVO. You communicate with the SDVO chip through
i2c and then do a bus switch to get to the DDC. You also have the GMBus
with interrupt support that can help you do the i2c transfers.

SDVO supports many connectors and can have multiple in and out channels
so some setups are a bit complicated.

It would be nice to have a model that fits both DSI and SDVO, and the option
to configure some of it from userspace.

I thought the purpose of drm_encoder was to abstract hardware like this?

-Patrik
