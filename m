Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2IMEes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 00:34:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55761 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab2IMEep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 00:34:45 -0400
Message-ID: <50516264.5050303@wwwdotorg.org>
Date: Wed, 12 Sep 2012 22:34:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] USB: phy: re-organize tegra phy driver
References: <1347447481-25574-1-git-send-email-vbyravarasu@nvidia.com> <5050D622.7080704@wwwdotorg.org> <D958900912E20642BCBC71664EFECE3E6DDEFB8D8F@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDEFB8D8F@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 10:16 PM, Venu Byravarasu wrote:
> Forgot to address some of the comments made by stephen, in my previous update.
> Hence addressing them now.
> Thanks a lot Stephen, for detailed review.

OK, so since this patch is basically just splitting the file into
multiple parts, you can ignore most of my review comments for this patch
and consider them as input for things in future cleanup patches.

One comment below:

> Stephen Warren wrote at Thursday, September 13, 2012 12:06 AM:
>> On 09/12/2012 04:58 AM, Venu Byravarasu wrote:
...
>>> +static int	tegra2_usb_phy_open(struct tegra_usb_phy *phy)
>>> +{
>>> +	struct tegra_ulpi_config *ulpi_config;
>>> +	int err;
>>> +
>>> +	if (phy_is_ulpi(phy)) {
>>
>> Similarly, this seems like it'd be better as two separate functions,
>> since there's already an op defined for open.
> 
> tegra2_usb_phy_open is called via open of ops only. 
> Plz let me know if you still have any concern here.

What I meant was the body of this function is:

tegra2_usb_phy_open:
    if (ulpi)
        do a bunch of ULPI stuff
    else
        do a bunch of UTMI stuff

It's seems it'd be simpler to split this into two functions:

tegra2_usb_ulpi_phy_open:
    do a bunch of ULPI stuff

tegra2_usb_utmi_phy_open:
    do a bunch of UTMI stuff

... and have the code that initializes the ops assign the appropriate
one of those two functions into the open op, just like it does for
all/most other ops.

Still, this may come under the same argument as above; fuel for future
cleanup since the existing code already works this way?
