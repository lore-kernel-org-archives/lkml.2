Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab2BZKC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 05:02:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2BZKCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 05:02:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
Date: Sun, 26 Feb 2012 10:01:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
        Roland Stigge <stigge@antcom.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com
References: <Pine.LNX.4.44L0.1202251033550.4173-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1202251033550.4173-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202261001.49937.arnd@arndb.de>
X-Provags-ID: V02:K0:4svaJ2Vvi0bWkdZjuR2+/TGQu5B0MiNyqWEj4VTLPJk
 3Ce4xB9lwR9phLk9eCc8IH/VJ1F8SlZkARKgTyHOiPH3CnDC+v
 UhOpq41jNAdVQrUmDsFKnqRx1xfPwPm0tgGe1vO2yE9/XVCNom
 Y/ws5ZSCS3TZcYsLOq63wxuTkfvGxZioZKH6vtLQez3Y5dWcor
 Q0aV6E/G2duY2pPOscT6sxDCV3BxBTiYJe75v3SNeXMmUZFzcx
 /x9Qjqs9pJbvhaLtid2mRcW0TD++gmi0q+cc/Luj4qYWdEpukP
 o8WGRAzDMawgtqTGBUCckpXwlQVjZeggF2QNY6I5vr+n8kaxX6
 VDb32AjaqVmFNKAEWXoE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 February 2012, Alan Stern wrote:
> You are talking about two separate issues.  One is the way the various
> bus-glue files get built into the driver, and the other is the way it
> #includes .c files.
> 
> I don't view the second as a big deal.  A few people have complained
> about it, but I don't see the point.  Sure, it has the disadvantage
> that you have to recompile the entire driver any time one of the files
> is changed.
> I can live with that.  It has the advantage that symbols
> shared among the source files can be static; they don't have to get
> merged into the overall kernel namespace when the driver isn't build as
> a module.

Right, I don't really object that part (including .c files), with
conditional includes I was referring to the inclusion of hw-specific
glues into the driver.

> The first issue is more serious.  There are long-term plans to
> restructure both of those drivers so that the bus glue resides in a
> separate module from the main core of the driver.  However I have not
> started to work on that yet; there are other more pressing matters to
> do first.

Ok.

> It doesn't seem extremely urgent.  Things are working the way they are.  
> The main advantage to restructuring is that it would allow distributors
> to build bus glue for multiple platforms in a single distribution
> image.  Currently that's not possible (except that any one of the
> platform glues can be enabled along with the PCI glue).

We are doing a major rework of the ARM architecture tree right now
to allow building multiple SoC platforms together, which has not
been possible traditionally. The "PLATFORM_DRIVER" macro in ohci
and ehci is one of many things standing in the way still and will have
to be dealt with at some point.

> A little progress has been made already.  We just received a submission
> for a "generic" platform bus glue file that will be able to take over
> the jobs of several of the existiing files.  If anyone wants to take
> this further I won't object, but I don't plan to work on it myself
> soon.

Ok, good to know. The approach of a generic glue is exactly what I
was going to suggest. As we get to ARM platforms that are currently
using PLATFORM_DRIVER, I will then ask people to convert the ohci
glue to use that generic glue instead of adding another *_DRIVER
macro to ohci/ehci.

I'm not sure about what we should do for lpc32xx. Is that
generic glue going into v3.4? If so, we could convert the
pnx4008 driver to use that and abstract it in a way that works
nicely for pnx4008 and lpc32xx. OTOH, we might just let this
one go in as before and ask people to do it right for the next
one.

	Arnd
