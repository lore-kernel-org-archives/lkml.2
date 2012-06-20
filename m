Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab2FTQX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:23:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60294 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab2FTQX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:23:56 -0400
Message-ID: <4FE1F918.1040909@wwwdotorg.org>
Date: Wed, 20 Jun 2012 10:23:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, arnd@arndb.de, lrg@ti.com,
        lee.jones@linaro.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/3] regulator: dt: add policy to match regulator with
 prop "regulator-compatible"
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com> <CACRpkdYSLiLZwVwY1tU9PWGTx2EGP6OykeXE5rtwRKAHror-Yg@mail.gmail.com> <20120620100058.GD3978@opensource.wolfsonmicro.com>
In-Reply-To: <20120620100058.GD3978@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 04:00 AM, Mark Brown wrote:
> On Wed, Jun 20, 2012 at 10:59:32AM +0200, Linus Walleij wrote:
> 
>> If I had today deployed the device trees generated prior to this
>> patch, and try to boot kernels after this patch with the same
>> device tree, would they still work as expected?
> 
>> I don't know it it's an issue right now, but at some point we
>> need to realize that people will expect old device trees to work
>> on newer kernels.
> 
> I don't think anyone's taking that idea terribly seriously right
> now for ARM, lots of the core SoC bindings are still in flux or not
> there.
> 
> Even for PowerPC where this has apparently been achieved I've still
> had to push back on new mandatory properties being added :/

For Tegra bindings at least, I had historically tried to be extremely
hard-and-fast on binding changes, based on this compatibility requirement.

However, at Linaro Connect Q1 I think, Grant made the point that he
considers the current binding definitions a work-in-progress in
general since as you say, everything is so new. So, I've backed off on
the 100% compatibility requirement until things are more solidified.
It's better to fix broken stuff that force any historical binding bugs
not be fixed.

Related to this, I wonder if we need some scheme to tag individual
bindings as under-development vs. final, and some way to promote
bindings between those states (a bindings review board?!). Do binding
definitions need versions? This perhaps might be coupled with the
binding documentation (even .dts files?) moving out of the kernel tree
to some other repository. To be honest, until/unless the source and
.dts files or binding docs are separated, it's slightly hard to argue
that the bindings ever need to be static, since the idea appears to be
to always use the .dts file that shipped with the kernel you built,
and upgrade them both at once.
