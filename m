Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2FAUk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 16:40:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59103 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755297Ab2FAUk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 16:40:56 -0400
Date: Fri, 1 Jun 2012 21:40:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator
 tps65911
Message-ID: <20120601204052.GB4258@opensource.wolfsonmicro.com>
References: <1337691917-15040-1-git-send-email-ldewangan@nvidia.com>
 <1337691917-15040-2-git-send-email-ldewangan@nvidia.com>
 <4FBBC192.7030900@wwwdotorg.org>
 <4FBBC830.2060802@nvidia.com>
 <4FBBCA8F.3050903@wwwdotorg.org>
 <4FBBD33C.8020802@nvidia.com>
 <4FBBDA97.6000006@wwwdotorg.org>
 <4FBBDE06.5080806@nvidia.com>
 <4FC916AC.4060804@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <4FC916AC.4060804@wwwdotorg.org>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 01, 2012 at 01:23:24PM -0600, Stephen Warren wrote:

> However, Mark warned that changing this would be a bit painful because
> there are already users of the existing scheme. It looks like that's
> only tps65910 (which we haven't started using yet), db8500, and ab8500,
> so probably not that big a deal.

No, there's a bunch of others - some queued for -next, others open
coding the same scheme.  Any device with more than one regulator in a
node should be using the same scheme.

> We could either augment struct of_regulator_match with an integer ID
> field for each regulator (which would perhaps make it slightly painful
> to write the nodes and keep the IDs matched up), or add a new property

No, that's awful.  How's anyone supposed to read stuff like that?  The
interrupt bindings are a disaster, not a model.

> to each regulator provider node e.g. regulator-id which contained the
> name that the regulator driver knows the regulator as (which would match
> struct of_regulator_match.name), since the existing regulator-name
> property is used for semantically different purposes.

Oh, ick.  This isn't nice.  If anything I'd be more inclined to put a
named property in there and have drivers look for its presence.  The
presence of multiple name properties isn't nice.

> > 		vdd1_reg: regulator@0 {

Can't we use the right hand side of this?  It appears to just be
syntactic sugar without any current meaning.

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPySfAAAoJEBus8iNuMP3dWXMQAJYiHAWhGBWbyoXup5Wpxwu1
pibzE+dPcvxvTHxcz1lBWztJpz5IBj+HE5klzYAOehzSmbsQCfobJQnW40WYblR8
uiq/xM2dcKD/M+G6XfPhIBARkMjjxsZgmpuECJ89hrXo98aApQn0iZ2qNnBrP3Qw
I1CZNqAFQmiVOKi9mgUGvALVqWbcgL2ZEbWBUdj/WJMKfyfVn1YH7WAdaw637V62
kqy+litXwoDI1BgF8Y5O8RmdAyMnq6u614k6tihYlGbhD9qKT9Z5yfxXtv9Hzwfi
g6UkAJ5v1PDTqluJu8/T1PsrJH+xBxB4cdHZ/ih9LB2dSe6iBm05R+WsgQMsKqv5
1jrptrhjqIImEL3LZs9a2cUv9G+AV8I6mBl+yDcbp6LFLRn055C8QjaN/sU+mboE
uyQEyL+464ygJmCk803rqX0QlU8LZrmjkFElayBe+A6Y8cHelBsJN6lTGeloK0k1
p6pfgpwsRrboqVUsM+IzFJmVWZz2prSOwRTkzvDrj/l2Bu9IoRudkSjTAgjNMayC
PWMDrHvPrTm4IWG6gCUh6H7gClMgctWJ+/B9sJPPlYh9gF6fIQV57QlCEEufLPqv
9P2Tjc/vEjXZbQN19aEwLV97W+dmc8Cx5WfhfojdB51UJDnLXOHuPJDM97rIobq+
bU7Wy9c5v28SdH360SCP
=mUgd
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
