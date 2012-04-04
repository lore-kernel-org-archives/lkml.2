Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab2DDWT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 18:19:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47636 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556Ab2DDWTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 18:19:25 -0400
Date: Wed, 4 Apr 2012 23:19:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 5/6] regmap: add runtime PM calls to debugfs file IO
Message-ID: <20120404221920.GF10787@opensource.wolfsonmicro.com>
References: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
 <1333576113-13196-5-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V4b9U9vrdWczvw78"
Content-Disposition: inline
In-Reply-To: <1333576113-13196-5-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V4b9U9vrdWczvw78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 04, 2012 at 03:48:32PM -0600, Stephen Warren wrote:

> It's quite probably that devices need to be active in order for their
> registers to be read/written. In normal regmap usage by drivers, it's the
> responsibility of the driver to assure this if needed. However, regmap
> debugfs file handling is outside the driver's control, so we need to
> explicitly ensure this.

This feels wrong, it's too invasive on the device.  If we're in cache
only mode (which we should be if the device is off and we have a cache)
then I'd expect us to error out if we can't satisfy the read from cache
rather than wake the device up which might be terribly expensive and
cause register writes which change the device state we were trying to
inspect, and if we have a cache then we might not need to interact with
the hardware at all at which point the wakeup would've been needless.
It's certainly not what I'd expect a diagnostic interface to be doing,
I'd expect it to reflect the current state of the device.

Now, quite how the mmio bus deals with access to a suspended device is
probably platform specific and certainly more fun than at least I2C (SPI
has issues since it's hard to tell if the device is there or not and the
MISO line might be undriven but at least you'll not lock up or anything).

--V4b9U9vrdWczvw78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfMjgAAoJEBus8iNuMP3d408QAJIUv+7UC3447b4fcFebco79
MtyeFcT5qHhJnRxSDAcfrasp298S5dtTVmj4rMrqDnAZ9FL/nsC1oFjUfosGqQ0N
5dQpXZLerG2lgeSFVQEIxmdKUb8fayHPDaEDdb+AJc7Zqs/cJ4HymfeKxd+kAvpF
CDFaEPgKUvqKMTxFGBZbYdxb4xiMbxcYpwAlWYePhSDwfZKpNx9JGlLa8PHplYr/
Pe+Hug/560fNk3rH499G09ttd/ZGFvs/hXxprX2ge4Z/s43y8qsLJOs1nnZ0ynE+
u859qHNbkgu59A03jc+k6J6OlspAWDhjl+E6mmMo71xb9gvSBaM6BsSKKB3hwT4i
VwFhIt43W5kNkAC/KWGiJa0nLNpYvKuToTmVDUYmvPzmFWyCr6h69BtPMiN3ksyo
QYLJmBfgvFVpZbvJHV3zlMLWYwuYsJeTp3UGo0xc4pmhGRKHimx3JR+KoBNdn2hr
QLFsya3j6dhlmzJTpeyiAXzhCowy74PX+7H9rFFYKs70vYFnl2j5Qfilg18yB7oE
HKNipvcNX5pLpCruz6QZMETbrIBNK51NmFepZ+ZTA86auqZroRQ4uL30/0J82IJV
mlX4UVIc05U32mYNAnTq5bsgJ0C43rxQdumvaQH69d0VdLTqIh6YtC2KgOTuxvQM
RO9VOkcBVpo0y7hKsgzo
=D38s
-----END PGP SIGNATURE-----

--V4b9U9vrdWczvw78--
