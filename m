Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab1D0UWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:22:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62905 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1D0UWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:22:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Date: Wed, 27 Apr 2011 22:21:48 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
References: <201104212129.17013.arnd@arndb.de> <201104271302.44249.arnd@arndb.de> <20110427201605.GW17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110427201605.GW17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104272221.48601.arnd@arndb.de>
X-Provags-ID: V02:K0:+Mm27/YE1M9ZChN5PmIOQzKzCNHcP6aW7lMFivNzmtG
 WVliqSvrcygiYgGBRGjyMCC+LxXZngZbZIvR1ZlijPdL5E18QA
 YGhOaA5H+/eVq116kwDsRTfxXq1jdE4rOG/F4vd0yQX0DtU4Xt
 aAkkvzSfoVsbsMCRbPmUFBK/zN2pRLhAzzXP3Hx+4zvDwa8epQ
 snMMMvFoxWpt2aUZPvwrg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011 22:16:05 Russell King - ARM Linux wrote:
> > As for making the default being to do cache handling, I'm not completely
> > sure how that would work on architectures where most devices are coherent.
> > If I understood the DRM people correctly, some x86 machine have noncoherent
> > DMA in their GPUs while everything else is coherent.
> 
> Well, it sounds like struct device needs a flag to indicate whether it is
> coherent or not - but exactly how this gets set seems to be architecture
> dependent.  I don't see bus or driver code being able to make the necessary
> decisions - eg, tulip driver on x86 would be coherent, but tulip driver on
> ARM would be non-coherent.
> 
> Nevertheless, doing it on a per-device basis is definitely the right
> answer.

The flag would not get set by the driver that uses the device but
the driver that found it, e.g. the PCI bus or the platform code,
which should know about these things and also install the appropriate
iommu or mapping operations.

	Arnd
