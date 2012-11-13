Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab2KMHh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:37:29 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2559 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2KMHh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:37:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 Nov 2012 23:37:21 -0800
Message-ID: <50A1F8AC.60709@nvidia.com>
Date: Tue, 13 Nov 2012 15:37:16 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de> <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de> <50A0C3BF.90509@nvidia.com> <50A1CECA.3090804@nvidia.com> <20121113064135.GA31443@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121113064135.GA31443@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 02:41 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Nov 13, 2012 at 12:38:34PM +0800, Mark Zhang wrote:
>> On 11/12/2012 05:39 PM, Mark Zhang wrote:
>>> On 11/09/2012 09:20 PM, Thierry Reding wrote:
> [...]
>>>> @@ -1036,9 +1041,6 @@ static struct clk_duplicate tegra_clk_duplicates[] = {
>>>>         CLK_DUPLICATE("usbd",   "utmip-pad",    NULL),
>>>>         CLK_DUPLICATE("usbd",   "tegra-ehci.0", NULL),
>>>>         CLK_DUPLICATE("usbd",   "tegra-otg",    NULL),
>>>> -       CLK_DUPLICATE("hdmi",   "tegradc.0",    "hdmi"),
>>>> -       CLK_DUPLICATE("hdmi",   "tegradc.1",    "hdmi"),
>>>> -       CLK_DUPLICATE("host1x", "tegra_grhost", "host1x"),
>>>>         CLK_DUPLICATE("2d",     "tegra_grhost", "gr2d"),
>>>>         CLK_DUPLICATE("3d",     "tegra_grhost", "gr3d"),
>>>>         CLK_DUPLICATE("epp",    "tegra_grhost", "epp"),
>>>> @@ -1051,6 +1053,9 @@ static struct clk_duplicate tegra_clk_duplicates[] = {
>>>>         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.1", "fast-clk"),
>>>>         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.2", "fast-clk"),
>>>>         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.3", "fast-clk"),
>>>> +       CLK_DUPLICATE("pll_p", "tegra-dc.0", "parent"),
>>>> +       CLK_DUPLICATE("pll_p", "tegra-dc.1", "parent"),
>>>> +       CLK_DUPLICATE("pll_d_out0", "tegra-hdmi", "parent"),
>>>>  };
>>
>> Why we need this "CLK_DUPLICATE"? Set the clock parent of the dc
>> controllers to pll_p?
> 
> This was the method proposed by Stephen to abstract away the clock tree
> differences between Tegra20 and Tegra30. The way this works is that we
> can {devm_,}clk_get(&pdev->dev, "parent") in the display and HDMI
> controllers' .probe() and it'll obtain the correct parent clock
> independent of which version of Tegra is used.
> 

Yes, after reading the corresponding codes in rgb.c & hdmi.c, I got how
this works. It's better than our previous version, I mean, the version
which we hard-code the clock parent setting logics in clock.c. But I
wanna say, it looks weird if you don't read the code of drm driver.

> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 
