Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1EWNkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:40:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51886 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751531Ab1EWNkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:40:23 -0400
Date: Mon, 23 May 2011 14:41:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Skip bogus LVDS VBT mode and check for LVDS
 before adding backlight (try 2)
Message-ID: <20110523144159.5788ee9f@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTi=tB+22Xen9StHkCdoEa8A2hqA2aA@mail.gmail.com>
References: <20110511204609.GA6059@patrik-macbook>
	<20110511225557.2c8f6649@lxorguk.ukuu.org.uk>
	<BANLkTi=tB+22Xen9StHkCdoEa8A2hqA2aA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Will it go into 2.6.40-rc1?

I hope so.

> The issue is that I'm not getting any EDID from the display. Could be
> the GMBus getting in the way or that the SDVO IO mapping isn't set up
> properly before sending the SDVO_CMD_SET_CONTROL_BUS_SWITCH command.
> I've been fiddling quite a lot with it but nothing seems to work, so

I'm also not clear if the i²c mapping is always the same. Certainly this
is a problem on Moorestown/Oaktrail in some cases.

> instead I took the current SDVO code (and large parts of the output
> handling) from the i915 driver and crammed it into gma500. That did
> the trick (though it's not currently talking to crtc abstraction
> properly).

Interesting.

> So my question is, do you think we should incorporate the new and more
> feature complete output handling from the i915 into gma500? We might
> even start sharing that code between gma500 and i915. If that is
> something you like to avoid we can of course keep working on our
> current output code.

Importing the code seems reasonable. KeithP didn't want it shared when I
asked him, but importing it and having the same code in many areas is the
first step to sharing anyway.

Alan
