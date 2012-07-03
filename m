Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab2GCLGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:06:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab2GCLGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:06:51 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm tree related)
Date: Tue, 3 Jul 2012 11:06:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au> <201207030859.11975.arnd.bergmann@linaro.org> <20120703100049.GA8455@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120703100049.GA8455@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207031106.42915.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:ldzHHzWQceCDNfhuUpJwgEKbKb//y0HkD58AGq3wHYu
 OT9EWRMARSSm2BeDCemW/s/HQ0UBdNY3rJ7NdSqDrs2Nr7OXTW
 2RzDfwlyNdA0O0BXS9w973qdgDB3x4931klsf3umy7Fv4LEtf4
 eyYStOQUDX2Dexsf91nLLVgaeo8zwfmkBbQMl5F+JGG8AENJ2p
 aQZj7658GzpWsbWCAweB4Hsmzchgq5UYmOCfR9ShainXl6jg/g
 f+BqrOb852cgDrZJBDl670PYMLpsESZdNRvSjvkQ0WHtqMjB7Y
 9TvtE5unYWXD6KCR3D+qj+OiNpEtRO5QLRvId8onrAiS+Xp1t2
 hsVPzB/kBHLMEcBqYz2d19/C7rneD4ypHMz8j1YUH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2012, Thierry Reding wrote:
>   Show Details
>   On Tue, Jul 03, 2012 at 08:59:11AM +0000, Arnd Bergmann wrote:
> > On Tuesday 03 July 2012, Thierry Reding wrote:
> > > I came up with the attached patch. What do you think? It fixes the
> > > PowerPC allyesconfig issue for me.
> > 
> > This one looks correct, but I would still do it the other way around,
> > putting the depends statements into the locations of the other drivers.
> > The main difference is that we can then independently convert the
> > remaining drivers, without having merge conflicts in the same line
> > every time we remove one of the dependencies.
> 
> The downside of that approach, however, is to make PWM override other
> settings. For instance if you have TWL6030_PWM selected and then decide
> to also select PWM, then the former will be automatically deselected to
> satisfy the dependency. I'm not sure if that's desired.

It's true that this may be confusing, but I think it's the right
approach for future multiplatform kernels. If we have e.g. a combined
omap+ux500+imx kernel, we can only have one implementation of the
PWM interfaces, and that should be the new one.

It's less clear for the other architectures. Maybe a mixed approach
is better there, making CONFIG_PWM depend on !MACH_JZ4740 &&
!PUV3_NB0916 && !BLACKFIN, but letting the remaining ARM versions
of the PWM code depend on !PWM.

	Arnd
