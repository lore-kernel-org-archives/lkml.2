Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2K2SiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:38:16 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47253 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2K2SiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:38:14 -0500
Message-ID: <50B7AB93.5060207@wwwdotorg.org>
Date: Thu, 29 Nov 2012 11:38:11 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 04:47 AM, Thierry Reding wrote:
> On Thu, Nov 29, 2012 at 12:21:04PM +0200, Terje Bergström wrote:
>> On 28.11.2012 23:23, Thierry Reding wrote:
>>> This could be problematic. Since drivers/video and
>>> drivers/gpu/drm are separate trees, this would entail a
>>> continuous burden on keeping both trees synchronized. While I
>>> realize that eventually it might be better to put the host1x
>>> driver in a separate place to accomodate for its use by other
>>> subsystems, I'm not sure moving it here right away is the best 
>>> approach.
>> 
>> I understand your point, but I hope also that we'd end up with
>> something that can be used as basis for the downstream kernel to
>> migrate to upstream stack.
>> 
>> The key point here is to make the API between nvhost and tegradrm
>> as small and robust to changes as possible.
> 
> I agree. But I also fear that there will be changes eventually and 
> having both go in via different tree requires those trees to be
> merged in a specific order to avoid breakage should the API change.
> This will be particularly ugly in linux-next.
> 
> That's why I explicitly proposed to take this into
> drivers/gpu/drm/tegra for the time being, until we can be
> reasonably sure that the API is fixed. Then I'm fine with moving it
> wherever seems the best fit. Even then there might be the
> occasional dependency, but they should get fewer and fewer as the
> code matures.

It is acceptable for one maintainer to ack patches, and another
maintainer to merge a series that touches both "their own" code and
code owned by another tree. This should of course only be needed when
inter-module APIs change; changes to code within a module shouldn't
require this.

