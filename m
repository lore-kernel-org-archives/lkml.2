Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1KWL1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:27:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40120 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985Ab1KWL1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:27:22 -0500
Date: Wed, 23 Nov 2011 11:28:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: patrik.r.jakobsson@gmail.com, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: GMA500 support
Message-ID: <20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
In-Reply-To: <20111121182910.GA2856@Boggieman>
References: <20111121182910.GA2856@Boggieman>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 19:29:10 +0100
Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:

> Greetings,
> 
> Im syncing my gma500 tree to all the patches I see pass through the kernel mailinglist and
> its progressing well. 
> However, It would be nice with an todo list or a more practical this-works list. I know
> its not a priority but would simplify alot for end users.

If you configure it in the following should work on GMA500/600
- internal laptop displays including backlight
- external svga
- mode setting via KMS
- framebuffer console
- the framebuffer X server (and once out generally Dave Airlie's generic
  KMS X server)
- suspend/resume

The following I know don't work
- Huge external displays so large they won't fit in 8MB at init time
  (causes a crash)
- Using the vesa X server with it - this confuses stuff and isn't
  fixable, it's a "wrong user configuration"

Unsupported
- 2D hardware acceleration except console scrolling (as it seems to be
  too slow to be useful). I may add some 2D bits later where they do help
  (eg back to front blitting may be worth it just about)
- 3D engine (no public documentation)
- Video playback acceleration. In theory there is enough info in the
  VAAPI code for GMA500/600 that has been published and in the old
  'binary X/source kernel' driver to do this but someone will have to
  work on it if they want it
- Dell Mini HDMI port. This seems to be some kind of external bridge
  chip. Being a TV luddite I don't yet own an HDMI capable display to
  test.

And I'm sure we have a few bugs left !

Alan
