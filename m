Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2ENKQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:16:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47272 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755400Ab2ENKQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:16:31 -0400
Date: Mon, 14 May 2012 11:16:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] MFD: MAX77693: add IRQ handler
Message-ID: <20120514101626.GO31985@opensource.wolfsonmicro.com>
References: <1336972835-15203-1-git-send-email-cw00.choi@samsung.com>
 <20120514095719.GK31985@opensource.wolfsonmicro.com>
 <4FB0D93A.7000108@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B3NBd8mrXZtPJEYR"
Content-Disposition: inline
In-Reply-To: <4FB0D93A.7000108@samsung.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B3NBd8mrXZtPJEYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 07:06:50PM +0900, Chanwoo Choi wrote:
> On 05/14/2012 06:57 PM, Mark Brown wrote:
> > On Mon, May 14, 2012 at 02:20:35PM +0900, Chanwoo Choi wrote:

> >> +	if (!max77693->irq) {
> >> +		dev_warn(max77693->dev, "No interrupt specified.\n");
> >> +		return 0;
> >> +	}

> > I'd suggest just setting up the IRQ domain anyway - it makes life
> > simpler in the other drivers for the chip as they don't need to worry if
> > interrupts are registered unless it's very important to them that they
> > go off which is often not the case.  Just skip actually claiming the
> > IRQ.

> This patch add support irq domain for MAX77693 in the
> max77693_irq_init() function.
> You can check on patchset. Then, The 'max77693->irq' is gpio pin for
> IRQ. max77693->irq
> is meant to indicate to the application processor that the status of
> MAX77693 has changed.

Sure.  What I'm saying is that it's probably going to be easier all
round if you run through all the init except actually calling
request_threaded_irq() (and unmasking the external interrupt if you have
control of that) - that way the interrupt numbers for the interrupts on
the PMIC can always be requested, even if they can't actually occur.
Only child drivers that *really* need the interrupts to happen will need
to have conditional code.

--B3NBd8mrXZtPJEYR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsNtwAAoJEBus8iNuMP3ddLwP/jLlQIu20q+wFdwSGpfFQrQZ
lRX13fXS5aTnafvhDJE9PMsm4nWL0if7QAv0I0GY7BH4gMx09zGDim2tKWLzJUZS
j4/oB7RdNKWvIGcL3vwfnW32b/EbHlupXIq1aFSuWseZdKek8G4Rnk6uG2j2X1ch
C6Nub4VMTOW1HexyTDLPZEkI9skBNiKtUtJrg4tBc7lAK/7U1HsfQ6oqD3Z5DFwD
xJ5bOIf/WznLMz602TYWR2w2+7Zajz/y/r/2jrYgmTfJrMa7c5XAae830mdV+FL8
E72kSSPii3DaMbTtQ/H+2Miko1zZC68chZSD44BqXL3Sm2fGKuUuHUNaaFOgHr/X
id4ydo9Yx2fkzytpLpPI++RkBv8gjDurbi0KgzcpV5wys5H+jnWDp7Z0ttgagT1p
KkkCyFmyPr+QRDOjtKzhDziIzz7obeEBb+y4GNtdGHkT3LQtszoYAFaj/pxVRd+f
JL6L3tClEC5cWOLD/2VVGDjEjoEntvbxYFrxSl/CCiA65vQaXEmZRBdRM9bLzYJl
mIX4k6PI8Q6IaEI0ceSvcoU95Ji1Usx7hAr8xS9Ilrd6DQImSNJejHIm99cZfrhb
ktZW8kdgfnsCD+Go/eqaeLIXYtP1LC4beMmfi3wFNgkxIxIVHGtcnIDy5gjNeNoN
iyhzn5TIiTNz0UjAna3M
=kxFo
-----END PGP SIGNATURE-----

--B3NBd8mrXZtPJEYR--
