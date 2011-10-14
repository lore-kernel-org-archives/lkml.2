Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1JNQ2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:28:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55261 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab1JNQ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:28:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Date: Fri, 14 Oct 2011 18:27:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com> <201110141729.41515.arnd@arndb.de> <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110141827.53906.arnd@arndb.de>
X-Provags-ID: V02:K0:/YjCyhcEJaWnHg5SKww3m2+FQ7TVxHvY9uCvxYYVJ+x
 rDi9Ssk63iUfV9Ik/JdGogpN/SF8C6mCzYdSNqsm1hvFnCBiYw
 aN6UOThTolsmCNIZEMtgMVTX6mwlYww4KDw1OwtfO/d72XLYhT
 wwxI7K0H8TgwJsx0CRC2cpgZJq+RhsBetMhZxN1QIJB6RSBaaZ
 banWGUpZq6d8ZMLSom6JSYftwDLmAsHJF5sg4uj9ncRrpXMzPP
 exCtYBbfTkOc9ClN1DCmM+mkvJ339+Hv0vmXIrh/XRDs4T3B/D
 m4ynQYAHvGQqa41H0XVrc/l//RKAZjXIXV1WzbF/7sp3MFZZMN
 LdxetDRFKhnvtIED10iQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 October 2011, Stephen Warren wrote:
> Arnd Bergmann wrote at Friday, October 14, 2011 9:30 AM:
> ...
> > You mention that tegra30 will require AUTO_ZRELADDR.
> 
> Well, just to be clear, here's the situation I think:
> 
> Tegra20's SDRAM starts at physical address 0.
> 
> Tegra30's SDRAM starts at physical address 2G.
> 
> To support that, we could either:
> 
> a) Introduce a new Kconfig variable for Tegra30, make T20/T30 mutually
> exclusive, and update arch/arm/mach-tegra/Makefile.boot to set zreladdr
> etc. based on the new Tegra30 config variable too. Then, there's no need
> for AUTO_ZRELADDR anywhere.
> 
> b) Have no new config variable, build a unified T20/T30 kernel, leave
> Makefile.boot untouched, and rely on using AUTO_ZRELADDR for Tegra30 to
> account for the different SDRAM physical addresses.

Ok, thanks for the explanation, that makes it much clearer. For
completeness, you could also do both of the above and make T20/T30 mutually
exclusive unless AUTO_ZRELADDR is set. That might be more complex than
necessary, I don't know.

	Arnd
