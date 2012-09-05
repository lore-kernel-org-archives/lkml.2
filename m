Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab2IEPdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:33:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38441 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2IEPdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:33:11 -0400
Message-ID: <504770AD.8060103@wwwdotorg.org>
Date: Wed, 05 Sep 2012 09:33:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] regulator: tps6586x: register regulator even if no
 init data
References: <1346252473-30068-1-git-send-email-ldewangan@nvidia.com> <504668E3.1060907@wwwdotorg.org> <5047072F.5030702@nvidia.com>
In-Reply-To: <5047072F.5030702@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 02:02 AM, Laxman Dewangan wrote:
> On Wednesday 05 September 2012 02:17 AM, Stephen Warren wrote:
>> On 08/29/2012 09:01 AM, Laxman Dewangan wrote:
>>> Register all TPS6586x regulators even if there is no regulator
>>> init data for platform i.e. without any user-supplied constraints.
>>>
>>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>> Tested-by: Stephen Warren<swarren@nvidia.com>
>>
>> Note that this patch depends on the patch I just posted titled
>> "regulator: tps6586x: add support for SYS rail". I also believe Laxman
>> will be posting another patch based on these 2 soon (it will move the
>> regulator DT parsing out of the MFD driver into the regulator driver),
>> so I guess it makes sense to take them all through the same TPS6586x
>> topic branch in the regulator tree.
> 
> About next patch (moving regulator dt parsing out of mfd), do you want
> to support the Harmony also?
> If yes then same change should also contain the board-harmony-power.c
> changes.

Yes, Harmony needs to continue working.

We can either:

a) Add your third patch to the TPS6586x topic branch in the regulator
tree, and I'll merge all 3 into the Tegra tree in order to build on it
and switch the regulators to DT.

b) You can wait to submit your third patch until after the 3.7 merge
window (i.e. send if for 3.8) since then all the dependencies will have
appeared in Linus's tree as a baseline. This is probably the simplest.
