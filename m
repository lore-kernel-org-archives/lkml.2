Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab1IZIZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:25:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63464 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1IZIZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:25:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 0/4] arm/tegra: Convert gpio & pinmux to platform devices
Date: Fri, 23 Sep 2011 18:48:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1316725567-17881-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1316725567-17881-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109231848.52318.arnd@arndb.de>
X-Provags-ID: V02:K0:mNKOMtbx33oxYgnQrNxTfxDZDzkYgc0qeV3auo1i2Y6
 8mz7/noQSI9tsaFP1iWEOIvPE6dp6/SkDJB3YSCMSp8/wJloXA
 6Y9J6d9skIr8u0VeF6e77Gg5hycI7hLXL9xRDikULhDw6NsQKQ
 Ih++CWJionf7WCWCQTGz5HBPhAVu470BtaWslD9Bv86k8E9cv7
 1bF1goEo1EGLX0nh04mbRm1z/9kX/YGAjdRJJ/L/wUjrWrjK0I
 JyE8LFgL2axn/tzaxME+1ZfyCautJ/+dxIrZoOCk014anjDiXL
 ROSMw6G5xVJKtIFaWsJNc3nEKNltJJZIYi0vReMX/nqaQSUoBH
 bp6nb61whdaIwlL5uZKs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 September 2011, Stephen Warren wrote:
> 
> This series converts the Tegra GPIO and pinmux drivers to be regular
> platform devices.

Looks good overall.

> The series is extracted from an earlier series I posted that augmented
> these drivers to initialize HW state from the device-tree. I'm holding
> off on that aspect of the changes, since it's not entirely clear to me
> whether the new pinmux API should drive the initial pinmux state setup
> via "system hog" definitions, or whether pinmux drivers should indeed
> do their own thing.

I think at least you should try to do an ioremap of the pinmux register
area in the pinmux probe function and make sure that it's called early
enough, if at all possible.

Right now, there is an empty probe() function, which is a bit silly,
and the pg_readl()/pg_writel() functions use hardcoded register
addresses.

	Arnd
