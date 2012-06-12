Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2FLQFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:05:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40047 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab2FLQFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:05:50 -0400
Message-ID: <4FD768DB.3070403@wwwdotorg.org>
Date: Tue, 12 Jun 2012 10:05:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/4] i2c: tegra: Bug fixes, cleanups and M_NOSTART support
References: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com> <4FCE3078.1030008@wwwdotorg.org> <4FCE3CD8.8060502@nvidia.com> <20120612085040.GC9230@pengutronix.de>
In-Reply-To: <20120612085040.GC9230@pengutronix.de>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 02:50 AM, Wolfram Sang wrote:
> On Tue, Jun 05, 2012 at 10:37:36PM +0530, Laxman Dewangan wrote:
>> On Tuesday 05 June 2012 09:44 PM, Stephen Warren wrote:
>>> On 06/05/2012 07:09 AM, Laxman Dewangan wrote:
>>>> This patch series having the: - Handling of late register
>>>> write due to Tegra PPSB design. - support for I2C_M_NOSTART -
>>>> Use devm_* for all allocation.
>>> The series,
>>> 
>>> Acked-by: Stephen Warren<swarren@wwwdotorg.org>
>>> 
>>> Note that patch 4 touches context adjacent to Prashant's "i2c:
>>> tegra: Add clk_prepare/clk_unprepare" patch, which I hope to
>>> take through the Tegra tree since it's a requirement for the
>>> Tegra common clock conversion. I don't think this will cause
>>> any significant conflict, but perhaps it's worth resolving it
>>> explicitly.
> 
> Is it really a requirement? Just wondering if it will cause
> problems, if Prashant's patch goes in via I2C after arm-soc has
> been merged. I am fine with simply acking the patch, though.

AIUI, the clk_prepare patch is certainly a requirement for Tegra's
conversion to common clock; I believe that a clk_enable() without a
preceding clk_prepare() will fail since it's an invalid call sequence.
I'm not 100% sure yet, but I hope Prashant will post patches to
convert Tegra to common clock in time for 3.6, so having all the
driver clk_prepare in a branch prior to the common clock conversion is
required.

>>> Wolfram, perhaps we should put these 4 patches and Prashan'ts
>>> into their own topic branch so that you can merge it into the
>>> I2C tree, and I can merge it into the Tegra tree too? Or, I can
>>> take everything through Tegra if you want, and ack it.
> 
> Laxman's patches should really go via I2C, I think. Can't we just
> fix the conflict in arm-soc?

Yes, Laxman's changes should be able to go through I2C without a
problem. We can try this out without any cross-merged topic branches
and try resolving in arm-soc for now. If there turns out to be an
issue, we can always rebase the Tegra and/or I2C for-next branches to
fix it up.
