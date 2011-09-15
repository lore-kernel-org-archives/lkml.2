Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab1IORFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:05:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45385 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751441Ab1IORFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:05:46 -0400
Date: Thu, 15 Sep 2011 18:05:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Keith Packard <keithp@keithp.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-dev@lists.linaro.org, "Clark\, Rob" <rob@ti.com>,
        Archit Taneja <archit@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
Message-ID: <20110915180500.53c70206@lxorguk.ukuu.org.uk>
In-Reply-To: <yun8vpp7qk7.fsf@aiko.keithp.com>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011 10:50:32 -0500
Keith Packard <keithp@keithp.com> wrote:

> On Thu, 15 Sep 2011 18:29:54 +0300, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> 
> > 1) It's part of DRM, so it doesn't help fb or v4l2 drivers. Except if
> > the plan is to make DRM the core Linux display framework, upon which
> > everything else is built, and fb and v4l2 are changed to use DRM.
> 
> I'd like to think we could make DRM the underlying display framework;
> it already exposes an fb interface, and with overlays, a bit more of the
> v4l2 stuff is done as well. Certainly eliminating three copies of mode
> setting infrastructure would be nice...

V4L2 needs to interface with the DRM anyway. Lots of current hardware
wants things like shared 1080i/p camera buffers with video in order to do
preview on video and the like.

In my semi-perfect world vision fb would be a legacy layer on top of DRM.
DRM would get the silly recovery fail cases fixed, and a kernel console
would be attachable to a GEM object of your choice.

Alan


