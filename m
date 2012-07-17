Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab2GQTO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:14:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34951 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab2GQTOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:14:54 -0400
Date: Tue, 17 Jul 2012 20:14:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: MAX77693: Fix bug of interrupt handlding for
 MAX77693 devices
Message-ID: <20120717191451.GK4477@opensource.wolfsonmicro.com>
References: <1342431665-2812-1-git-send-email-cw00.choi@samsung.com>
 <20120716133636.GA22600@sirena.org.uk>
 <5004A409.9000002@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oplxJGu+Ee5xywIT"
Content-Disposition: inline
In-Reply-To: <5004A409.9000002@samsung.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oplxJGu+Ee5xywIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 17, 2012 at 08:30:17AM +0900, Chanwoo Choi wrote:
> On 07/16/2012 10:36 PM, Mark Brown wrote:
> > On Mon, Jul 16, 2012 at 06:41:05PM +0900, Chanwoo Choi wrote:

> >> This patch fix bug related to interrupt handling for MAX77693 devices.
> >> - Unmask interrupt masking bit for charger/flash/muic to revolve
> >> that interrupt isn't happened when external connector is attached.

> > Shouldn't this be happening when the IRQ is requested?

> The interrupt isn't happened when external connector is attached
> because muic interrupt of MAX77693 is masked on INTSRC_MASK(
> Interrupt Source Mask) register. So, I should set zero to muic interrupt
> masking bit of INTSRC_MASK before requesting IRQ.

Right, but normally that unmasking happens in the unmask() callback of
the irq_chip which is called when the interrupt is requested.  Why isn't
that working here?

--oplxJGu+Ee5xywIT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBbmbAAoJEBus8iNuMP3dCLAP/iKadrXzg5rEJQ2ILr7TP01S
Uq+yl/Ma9tz/YOUOYrRLTBnwIKtEF+4Tn3p6a3iebzRUOmips3ci+cXydhg/R46U
BT1/ZsTWbW2YgZ85/3Ii8rflEavAIVOLN5ZgvxdtuxRoBtJgBmJh5znVoxy40L+H
eJ57QGL4f5dQrNKICVMGscksMnBzu8Re7V3qxw4QNHtcikhkUi7owfEXaOXLr/94
LDgYJdGSfaUShP46Y1Hnx6SY3+ieCT3u3/sKDFyTj2NAuDe4fgR0aJO2+HFAQcwq
n4HcgoYOOO8ydq5k7xZVRh6eHo7GDIxBUa5nqp5CwcKXga+ROsiYvMUeEJLW+YzT
Y/ZS76AzTx2+r32+ul7Knq7NW9bbgtryU/vyBd1fqCKV+FK+tn56hDp69NcYrFbG
YtI6lVAoknIEO8O1LskBFDkLgJ2Rg7k/ra6EDTabvFvWLJLRRwst7csnaoTB2wdF
jqslx0CekgISB1NuuwHqpsu9ABqs0tXUXJakttfSw0C/7EUfLbyJ7r8QXpn70Rut
wyNzdCx5OZQEAAiSnt3lJt1VrZIj/lF5T2+xx2Z/05uPZBIrLQxG185a/SlY6T0Y
GRrYgnzcMamtYLoSEdK7+NAsgUJNJQ+h/gCHGoLJ92M5qnzizrEqFdoAz3M48u4V
Qm+o1/KlDyXpotD/mpDK
=JlQt
-----END PGP SIGNATURE-----

--oplxJGu+Ee5xywIT--
