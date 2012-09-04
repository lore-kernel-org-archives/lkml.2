Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2IDO23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:28:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64404 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab2IDO21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:28:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik I2C driver
Date: Tue, 4 Sep 2012 14:28:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, linus.walleij@stericsson.com,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        devicetree-discuss@lists.ozlabs.org
References: <20120831122323.GC5962@gmail.com> <5044C82E.5060207@gmail.com> <20120903152012.GH31163@gmail.com>
In-Reply-To: <20120903152012.GH31163@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209041428.21409.arnd@arndb.de>
X-Provags-ID: V02:K0:AQkrYaBGayFL7SLgBAhAik7IjkToOQRxQdhCf9QH5i0
 TVu6wmR5i+4XY8jXih6kiqLaR7c5T/ASBExM0p9fsRhAivm9cE
 J8zK8v87skbzdby4RusJFOmaBnnfC97dkhBNIG2X2t/DK57BMs
 b+8bqQVkHqpigYAGEBS/YKhDeiRtobK2raToyv0mwBElAfPYuh
 T4/dmF17M2SYFK/WLQ1kRjmntT9B7bKelXRQLgKPd7YsQ/X5lf
 075uHWJIU6zfpn8exCrk07MP8cg9JPFDNi2tthq6BwiZOHR1Mx
 gofnYwpcKSqivsxlgBICl+zOJacmeUPoC9HVowEbdY7KnviKtg
 uq+wui2GFJPmbDejQbxA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2012, Lee Jones wrote:
> > But if you are handling both, then I agree that platform_data should
> > override DT.
> 
> I do agree with this, but I haven't stumbled over such a use-case yet.
> I have only provided; clock names, DMA settings and call-back information
> via AUX_DATA() thus far, and those are being removed too when a) the 
> correct bindings are mainlined and b) I have the time.

I'd prefer if you just disallow the case where pdata and DT have conflicting
information. We don't seem to have a clear rule that is enforced over the
kernel, so I don't think we can rely on either one taking precedence over
the other in general.

In this particular case, we don't have a single board file providing a
struct nmk_i2c_controller definition for platform data, so the best way
to handle this IMHO is to remove the header file with the platform
data definition, and just encode the defaults in the driver.

	Arnd
