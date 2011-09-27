Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1I0Nuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:50:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab1I0Nuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:50:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Date: Tue, 27 Sep 2011 15:50:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Dilan Lee <dilee@nvidia.com>, linux-arm-kernel@lists.infradead.org
References: <20110922184614.25419.84606.stgit@ponder> <20110926152634.GN2946@opensource.wolfsonmicro.com> <CACxGe6swdnhk_GCAv3siSx4kxNQXmCLDbwBFjsX5VPNfCBc2Mg@mail.gmail.com>
In-Reply-To: <CACxGe6swdnhk_GCAv3siSx4kxNQXmCLDbwBFjsX5VPNfCBc2Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271550.36427.arnd@arndb.de>
X-Provags-ID: V02:K0:5uZtI+5XahHKaympS/Mjk/rpTtwUKghnOQMcD7mGnsN
 UKgREAoVdeFb6a/bDjsAaW7d2t4lyep1TfLWCBXaA9vp4EiD3w
 Qppb+R/7fvYrHXiik+fjSKvyvC70sV3uwe5iZ+fg/+5D3hwih9
 CT/j5Uv8r+ARMzncpRjb3IYdohNAhBaRnhfjAlOzx1RD+H9T3t
 eZH6CZIqee5bwMiwclXZnzz4OloricsFyQ0V+VkpoMrppFoVQo
 CCSmroLLgJBroivAIxgWhL4HwJreW13QC4GBQ4HkpmbvscWUQq
 DwDW2H5vXMWpwoiW3AXY6WhYD41c0Bm7ZexViHU1dpGwhQOjsG
 xs2DlW0Lm0izwzq90g+0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 September 2011, Grant Likely wrote:
> Actually, in the next iteration, I'm thinking it would be a good idea
> to create a new #define to only be used by probe deferral.  I want it
> to be easy to find all the drivers that are using this mechanism
> without needing to filter all the unrelated hits.  However, this is a
> kernel-only thing so it is probably not appropriate to add it to
> include/asm-generic/errno.h.  I could use some guidance/advice as to
> the best way to handle this.

include/linux/errno.h already has a bunch of kernel-internal error
codes that are never supposed to be seen in user space. Just
add one there, the next free one right now is 517, after
ERESTART_RESTARTBLOCK.

	Arnd
