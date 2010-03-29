Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0C2S2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:28:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47180 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751240Ab0C2S2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:28:22 -0400
Date: Mon, 29 Mar 2010 19:29:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Giel van Schijndel <me@mortis.eu>,
       Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] resource: shared I/O region support
Message-ID: <20100329192957.0aa66eaa@lxorguk.ukuu.org.uk>
In-Reply-To: <20100329110633.702e3874@jbarnes-piketon>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
	<1269523063-30346-1-git-send-email-me@mortis.eu>
	<20100325155705.1ec79dbc@lxorguk.ukuu.org.uk>
	<20100325180347.GA2761@salidar.me.mortis.eu>
	<20100325181633.0313b8a5@lxorguk.ukuu.org.uk>
	<20100329081834.GB27956@salidar.me.mortis.eu>
	<20100329090713.1317942b@jbarnes-piketon>
	<20100329173800.GA3583@salidar.me.mortis.eu>
	<4BB0E73F.2080104@zytor.com>
	<20100329110633.702e3874@jbarnes-piketon>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well that does keep it simple, and with just one user that's probably
> best.
> 
> But why not use the common bus driver method?  Muxing at the resource
> level only seems to solve part of the problem...  It doesn't guarantee
> for example that driver A does something to a shared region that breaks
> driver B; it just makes sure they don't access the same region at the
> same time.

The obvious reason for not doing that kind of grand over-engineering is
that you are assuming the devices involved are remotely related. On quite
a few systems we have a collection of superio config interfaces on random
low ports all with their own lock/unlock rituals. They range from
parallel devices to watchdogs and god knows what else. Right now we have
various bits of driver code (parport is a good one) that exist on a cross
fingers, pray and poke model. It would be nice to fix that.

For most super I/O devices the muxing is basically a glorified chip select
line. There isn't any structure to impose over it. Where you have
structure there are better ways to do it, but one does not exclude the
other.

Alan
