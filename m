Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337Ab2COOrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:47:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54408 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039Ab2COOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:47:11 -0400
Date: Thu, 15 Mar 2012 14:47:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Simon Horman <horms@verge.net.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: notify sysfs when voltage is set
Message-ID: <20120315144708.GM3138@opensource.wolfsonmicro.com>
References: <1331813073-714-1-git-send-email-horms@verge.net.au>
 <20120315124631.GJ3138@opensource.wolfsonmicro.com>
 <20120315142657.GD3129@verge.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DXIF1lRUlMsbZ3S1"
Content-Disposition: inline
In-Reply-To: <20120315142657.GD3129@verge.net.au>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DXIF1lRUlMsbZ3S1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 11:26:58PM +0900, Simon Horman wrote:
> On Thu, Mar 15, 2012 at 12:46:31PM +0000, Mark Brown wrote:

> > I notice that we don't generate similar events for cpufreq...  what are
> > the performance implications from firing off udev (which isn't free)
> > every time we scale the CPU frequency?  It feels like this might be
> > disruptive, especially with a governor like ondemand which responds to
> > system load.

> that is a good point and to be honest not one that I had considered.  For
> the use-case that I have in mind, which is basically to log voltage changes
> over time, it may be acceptable to rate-limit notifications somehow. But at
> that point I may be better off just polling.

Hrm, if you're doing logging then we do already have tracepoints defined
for voltage changes - could you have your application work with those
instead of sysfs?  One of the applications of tracepoints is flight
recorder style system monitoring.

> Out of interest, how often can ondemand potentially change the voltage?

Depends on how slow it thinks frequency changes are.  I'm not so worried
about the performance impact from that point of view, I'm more worried
about what happens when we lower the clock frequency and generate a
sysfs event causing userspace to wake up and start doing stuff.  It'd be
bad if ondemand (or another dynamic governor) noticed that the system
got more busy again and responded by ramping the frequency...

--DXIF1lRUlMsbZ3S1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYf4sAAoJEBus8iNuMP3diMQP/01SrcZ58dRTdjjoMkDkqMYK
zivDeZujxIKXZR1IfSkhAKthnALVvDpGJyXsK1p+cqIfAPoUlB/PZ0v0cTyfqY0t
pvqVsgSf9Pg1/Q01Ok/cQFnbCNinEHRBvmAP6kVZ3RrG9XgZVbBlz6dXQH9q/4zV
09R6jfmzQ8TUnTYBAsrzJhXj8GffsTxcFY7IKq9KZKD6G8H1Eq19d1K5L7VvsvJE
xpwdGFl/zGAp/NX9I0wRbadMbOzkY6hTDhXA3pC/ZVFRvFPOnd/CfqcKxC84kSl5
PrW6EMYdNG52Ou1xrN5Tx9PWsZvteCJz48zUIvY4scSoRMuZXmcafqSQOBFqdkvo
iKTGC8QwQKpW2CRnjv5s6hpyVL9sw8cF8y27KmfWLzvMh1jcmnlHQATKDFMEZ7hv
EPuAnRp4yA6BdCNQ/WOnkQFX4fPimCth0MHzFJLnJGzdIDr9IBwCSmIBwD2TVR42
0dQppbKE5PclamnWH/NC5LHcoeGBAaGpJhCasLW7zjpE1Ze6mmQz1pOs3v2t8VPk
4KpQPMAwwKTWzMgEiSs5f8/IxI3YWMKqUiY44HTS76Jv2cTG20+laZnstFxiiVv6
L+Lh91ne7MW9qyLk3KQFqClHl4gS/ykb6WXddw+pSBcVwe7BpxSeIp+Fwe4HFyt/
13ElYheWGI1USMb2CPUA
=Q1JU
-----END PGP SIGNATURE-----

--DXIF1lRUlMsbZ3S1--
