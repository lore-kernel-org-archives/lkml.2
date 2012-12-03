Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab2LCTUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:20:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56295 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2LCTUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:20:33 -0500
Message-ID: <50BCFB7E.4020007@wwwdotorg.org>
Date: Mon, 03 Dec 2012 12:20:30 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de> <50B874C7.5030208@nvidia.com> <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 03:38 AM, Thierry Reding wrote:
> On Fri, Nov 30, 2012 at 10:56:39AM +0200, Terje Bergström wrote:
>> On 29.11.2012 13:47, Thierry Reding wrote:
>>> On Thu, Nov 29, 2012 at 12:21:04PM +0200, Terje Bergström
>>> wrote:
>>>> Tegra20 and Tegra30 are compatible, but future chips are not.
>>>> I was hoping we would be ready in upstream kernel for future
>>>> chips.
>>> 
>>> I think we should ignore that problem for now. Generally
>>> planning for any possible combination of incompatibilities
>>> leads to overgeneralized designs that require precisely these
>>> kinds of indirections.
>>> 
>>> Once some documentation for Tegra 40 materializes we can start
>>> thinking about how to encapsulate the incompatible code.
>> 
>> I think here our perspectives differ a lot. That is natural
>> considering the company I work for and company you work for, so
>> let's try to sync the perspective.
>> 
>> In my reality, whatever is in market is old news and I barely
>> work on them anymore. Upstreaming activity is the exception. 90%
>> of my time is spent dealing with future chips which I know cannot
>> be handled without this split to logical and physical driver
>> parts.
>> 
>> For you, Tegra2 and Tegra3 are the reality.
> 
> To be fair, Tegra2 and Tegra3 are the reality for *everyone*
> *outside* NVIDIA.
> 
> It's great that you spend most of your time working with future
> chips, but unless you submit the code for inclusion or review
> nobody upstream needs to be concerned about the implications. Most
> people don't have time to waste so we naturally try to keep the
> maintenance burden to a minimum.
> 
> The above implies that when you submit code it shouldn't contain
> pieces that prepare for possible future extensions which may or may
> not be submitted (the exception being if such changes are part of a
> series where subsequent patches actually use them). The outcome is
> that the amount of cruft in the mainline kernel is kept to a
> minimum. And that's a very good thing.

I think there's room for letting Terje's complete knowledge of future
chips guide the design of the current code that's sent upstream.
Certainly we shouldn't add a ton of unnecessary abstraction layers
right now that aren't needed for Tegra20/30, but if there's some
decision that doesn't affect the bloat, opaqueness, ... of the current
code but one choice is better for future development without serious
negatives for the current code, it's pretty reasonable to make that
decision rather than the other.

(That all said, I haven't really followed the details of this
particular point, so I can't say how my comment applies to any
decisions being made right now - just that we shouldn't blanket reject
future knowledge when making decisions)

After all, making the right decision now will reduce the number/size
of patches later, and hence reduce code churn and reviewer load.
