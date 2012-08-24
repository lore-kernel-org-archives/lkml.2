Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab2HXJXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:23:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17208 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab2HXJXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:23:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 24 Aug 2012 02:23:01 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Date: Fri, 24 Aug 2012 18:24:54 +0900
Message-ID: <6044581.2jEzZBWCu1@percival>
Organization: NVIDIA
User-Agent: KMail/4.9 (Linux/3.4.9-1-ARCH; KDE/4.9.0; x86_64; ; )
In-Reply-To: <1345542860.4085.40.camel@deskari>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com> <20120821091306.GA4819@avionic-0098.mockup.avionic-design.de> <1345542860.4085.40.camel@deskari>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2012 17:54:20 Tomi Valkeinen wrote:
> > However this also means we'll essentially just be moving the board code.
> 
> 
> What do you mean "just"? Wasn't the point of the whole "arm board file
> mess" to get rid of the code from the board files? If the code in the
> board file is device specific code, not board specific, then the driver
> of the device is a logical place to place it.

I think Tomi has a point here - these sequences were not belonging to the 
board code in the first place. They are definitely tied to the device, hence 
should have been handled by the driver all along, with the board code 
assigning the correct resources to the device (like the vast majority of 
device drivers do).

> And as I said, I don't have any problems with some kind of generic power
> sequences. So the code in the board file could be moved and converted to
> use the power sequences, if that is better than just plain c code.

My concern now is, provided that all drivers to their job and handle how their 
devices are switched on and off, when (if at all) are encoded power sequences 
better than their equivalent C code? There is the matching database size issue 
that you mentionned, is it a sufficient concern to justify a new kernel feature?

On the other hand some devices like panels are typically not used in many 
different appliances, so maybe it is not worth to separate them from their 
board definition. As Mark mentionned, having .dtsi files for the DT (and their 
equivalent .h for kernels that use platform data) might be a good middle 
ground.

But the line is really tight between what is code and what is data here.

Alex.

