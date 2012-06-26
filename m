Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2FZG3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:29:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19758 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2FZG3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:29:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 25 Jun 2012 23:29:18 -0700
Message-ID: <4FE9564C.4010502@nvidia.com>
Date: Tue, 26 Jun 2012 11:57:24 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: Re: [PATCH] i2c: tegra: use clk_disable_unprepare in place of clk_disable
References: <1340196960-3002-1-git-send-email-ldewangan@nvidia.com> <4FE1F9A0.6080200@wwwdotorg.org> <4FE1F9D6.6090802@wwwdotorg.org> <4FE83374.6090608@nvidia.com> <4FE889D6.4030500@wwwdotorg.org>
In-Reply-To: <4FE889D6.4030500@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 June 2012 09:25 PM, Stephen Warren wrote:
> On 06/25/2012 03:46 AM, Laxman Dewangan wrote:
>> Stephen,
>>
>> On Wednesday 20 June 2012 09:57 PM, Stephen Warren wrote:
>>> On 06/20/2012 10:26 AM, Stephen Warren wrote:
>>>> On 06/20/2012 06:56 AM, Laxman Dewangan wrote:
>>>>> Use clk_disable_unprepare() inplace of clk_disable().
>>>>> This was missed as part of moving clock enable/disable to
>>>>> prepare/unprepare for using the common clock framework.
>>> ...
>>>> I see no reason not to take the second patch in the series through the
>>>> I2C tree though.
>>> Uggh. Ignore that paragraph - the other patch was sent separately not as
>>> a series.
>> so are you taking care of this patch or do I need to send the patch
>> based on your tree in place of linux-next?
> Yes, this patch should be applied through the Tegra tree, since it will
> be a dependency of the common clock framework switchover there, which I
> hope to take place this kernel cycle.
>
> I did just attempt to apply this patch to the for-3.6/common-clk branch,
> but it doesn't apply:-( Could you please rebase and resend. Thanks.

Looked at your common_clk branch and the related code is not there.
The clk_disable() in the particular case is introduced by change
i2c: tegra: make all resource allocation through devm_*
which is not in your branch.

Then later Prashant post the change as
i2c: tegra: Add clk_prepare/clk_unprepare
and it does not accounted for the above patch.

So none of your local tree will have this issue.

You need to pull some of the change from Wofram's tree to you commn-clk 
to fix the issue.
Suggest to pull the change
i2c: tegra: make all resource allocation through devm_*
i2c: tegra: support for I2C_M_NOSTART functionality
i2c: tegra: add PROTOCOL_MANGLING as supported functionality.
i2c: tegra: make sure register writes completes





