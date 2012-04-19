Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2DSPfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:35:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33310 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab2DSPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:35:52 -0400
Message-ID: <4F9030D5.2050601@wwwdotorg.org>
Date: Thu, 19 Apr 2012 09:35:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Rhyland Klein <rklein@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 3/4] mfd: tps65910: Add device-tree support
References: <1334710829-22777-1-git-send-email-rklein@nvidia.com> <1334710829-22777-4-git-send-email-rklein@nvidia.com> <20120418090133.GC3021@opensource.wolfsonmicro.com> <1334777758.32315.37.camel@rklein-linux> <20120419125041.GH3046@opensource.wolfsonmicro.com>
In-Reply-To: <20120419125041.GH3046@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 06:50 AM, Mark Brown wrote:
> On Wed, Apr 18, 2012 at 12:35:58PM -0700, Rhyland Klein wrote:
>> On Wed, 2012-04-18 at 02:01 -0700, Mark Brown wrote:
> 
>>> This is a really odd idiom - normally the pattern for device tree
>>> support is to just go and try to use the device tree data if it's there
>>> and there's no need for any flag to say if it should be used.
> 
>> I agree its odd. My concern was that the idiom is that is pdata assigned
>> from board files should override dt data. At this point, we don't know
>> where the tps65910->board_data is coming from, dt or board files.
>> Arbitrarily using dt breaks that idiom. We could do a check like this if
>> you prefer:
> 
> No, just prefer the DT - what you're proposing is exactly the opposite
> idiom to what all the other DT drivers do so we'd need to go round
> changing the policy globally at which point we probably want to start
> having helpers for this.

That's not right - the idea is that pdata should override device tree so
that if there's a platform where the DT is known to contain incorrect
data, then some early platform code can add pdata to the device to fix
the problem, and that will be used in preference to the DT data.

At least, that's the last I heard Grant say on the subject, and that's
how I've been writing all the Tegra-related drivers, and I've seen
others do the same for other platforms.
