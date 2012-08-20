Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2HTRgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:36:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52480 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2HTRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:36:19 -0400
Message-ID: <50327590.1080700@wwwdotorg.org>
Date: Mon, 20 Aug 2012 11:36:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] i2c: tegra: I2_M_NOSTART functionality not supported
 in Tegra20
References: <1345317467-22258-1-git-send-email-ldewangan@nvidia.com> <503270B3.7000007@wwwdotorg.org> <50326F82.3050503@nvidia.com>
In-Reply-To: <50326F82.3050503@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 11:10 AM, Laxman Dewangan wrote:
> On Monday 20 August 2012 10:45 PM, Stephen Warren wrote:
>> On 08/18/2012 01:17 PM, Laxman Dewangan wrote:
>>> Tegra20 i2c controller does not support the continue transfer
>>> which implements the I2C_M_NOSTART functionality of i2c
>>> protocol mangling.
>>> Removing the I2C_M_NOSTART functionality support for Tegra20.
>> Thanks, applied the series to Tegra's for-3.7/drivers-i2c branch.
>>
>> Note that I had to fix up patch 1 to remove const on the tegra*_i2c_hw
>> variable declarations to avoid compiler warnings when assigning pointers
>> into tegra_i2c_of_match[].data.
>
> Thanks for correction but
> I did not get this warning and when saw the structure, it is declared as
> const type only..

Ah. This is something new in linux-next but not in 3.6-rc2. It was
introduced by:

98d7bbb of: add const to struct *of_device_id.data

I'll revert the modifications I made to the patch, and ignore the
warnings in Tegra's for-next; they won't be present in 3.7 presumably.
