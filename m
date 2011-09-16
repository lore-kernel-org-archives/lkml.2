Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1IPQyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 12:54:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46415 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753405Ab1IPQyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 12:54:11 -0400
Date: Fri, 16 Sep 2011 17:53:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Keith Packard <keithp@keithp.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-dev@lists.linaro.org, "Clark\, Rob" <rob@ti.com>,
        Archit Taneja <archit@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
Message-ID: <20110916175326.54567b14@lxorguk.ukuu.org.uk>
In-Reply-To: <yunfwjxwbjq.fsf@aiko.keithp.com>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<1316107275.23214.99.camel@deskari>
	<yunfwjxwbjq.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure a common interface to all of these different
> channels makes sense, but surely a DSI library and an aux channel
> library would fit nicely alongside the existing DDC library.

DSI and the various other MIPI bits tend to be horribly panel and device
specific. In one sense yes its a standard with standard commands,
processes, queries etc, on the other a lot of stuff is oriented around
the 'its a fixed configuration unit we don't need to have queries' view.
There also tends to be a lot of vendor magic initialisation logic both
chipset and device dependant, and often 'plumbing dependant' on SoC
systems. This is doubly ugly with the I²C abstractions for DDC because
SoC systems are not above putting the DDC on a standard I²C port being
shared with other functionality.

> Oh, I think you're also trying to get at how we expose some of these
> controls outside of the display driver -- right now, they're mostly
> exposed as properties on the output device. Things like backlight
> brightness, a million analog TV output values, dithering control and
> other more esoteric controls.

This is how the MIPI handling in the GMA500 driver works, although the
existing code needs to be taken out and shot, which should be happening
soon. There is a lot, like panel initialisation which is however not
really going to fit a properties model.

Alan
