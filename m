Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2BVQuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:50:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab2BVQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:50:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v2 12/19] ARM: at91/rtc-at91sam9: each SoC can select the RTT device to use
Date: Wed, 22 Feb 2012 16:47:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rmallon@gmail.com, linux@arm.linux.org.uk
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com> <201202221450.04390.arnd@arndb.de> <20120222162442.GD9407@game.jcrosoft.org>
In-Reply-To: <20120222162442.GD9407@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202221647.23430.arnd@arndb.de>
X-Provags-ID: V02:K0:mZYH0hF/KiP4Uo5DUSVOh5LVW7xQWedAV/Rj6RVkt5j
 XG1aNx3UuA3hkWevtHugV5djuLN1Ze9G/f4uM3V1bontzwndOb
 5ftIdqg+3A994IE1817DdDTro62hWEFhfOabCbFJxeTk5ist8Z
 4nlT2+iEye2/UFsBKRIo9dsh9RaQZpyCdwXzossFbb8bJDfhn7
 /mQ6mzJOx1pCtkbBlH9tYDqDV5dQwBSLX6awuPOoZJyouODQ7Y
 AlhkKehopyLK0UqEPQFeqK4SPXcs7kH2stiwaZbYqu6kihizyX
 JuTmLJ04HXKgVv4+kG+iHTZbrBbYcv1A5o8Sl0yRVws0QWhghh
 TfRpkdpTLrFhAFLHwHxA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 February 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 14:50 Wed 22 Feb     , Arnd Bergmann wrote:
> > On Wednesday 22 February 2012, Nicolas Ferre wrote:
> > > From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > > 
> > > For the RTT as RTC driver rtc-at91sam9, the platform_device structure
> > > is filled during SoC initialization. This will allow to convert this
> > > RTC driver as a standard platform driver.
> > 
> > Can you make this more elaborate? I don't see from this or the code why
> > you don't just always register the RTT as "rtc-at91sam9". There seems to
> > be no driver for the "at91_rtt" in tree, so I don't know if there is
> > an out of tree driver binding to it.
> > 
> > Would it be possible to remove the compile time #if and the resetting
> > of the device name if both drivers bind to the rtc name and the other
> > rtt driver binds to both names?
> because I see a quite some people use the rtt for something else
> 
> so I don't want to change on existing kernel

But if you change the rtc driver to always bind to the existing
"at91_rtt" platform_device and fail the probe() function for the
case that you are on at91sam9263 probing the non-RTC device,
you should get the exact same result without any extra code
in the per-soc files.

I guess it also makes sense to specify a device tree property
that lets you detect whether the RTT is used as RTC or something
else.

	Arnd
