Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab2KJSEj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 13:04:39 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2308 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2KJSEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 13:04:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 10 Nov 2012 10:04:30 -0800
Message-ID: <509E972A.8020200@nvidia.com>
Date: Sat, 10 Nov 2012 20:04:26 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 1/2] drm: Add NVIDIA Tegra20 support
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de> <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de> <CAF6AEGs4bk3umkbQmJmB+Gf4UctKWa2Rj9GEi=DZSqU8MUd+9w@mail.gmail.com> <20121109160002.GA6474@avionic-0098.mockup.avionic-design.de> <CAF6AEGu0j1E96tzsTcJ91-FdTekAoWL7w1GBadRQ7p2h0smVDA@mail.gmail.com> <20121109210334.GA9023@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121109210334.GA9023@avionic-0098.mockup.avionic-design.de>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.11.2012 23:03, Thierry Reding wrote:
> On Fri, Nov 09, 2012 at 10:26:27AM -0600, Rob Clark wrote:
>> hmm, are these values defined by the hw? They look like register 
>> offsets into the DC block? 
> I don't think they are defined by the hardware. From what I gather these
> can arbitrarily be assigned by software. If things actually work the way
> I think they do, then eventually these values could be allocated by the
> host1x_register_client() function and stored within the host1x_client
> structure, so that each HW block can program them into the corresponding
> register.
These are host1x sync points. Sync points are used to synchronize work 
between host1x, host1x client units (like DC, 2D, EPP, etc), and CPU. 
Tegra2 TRM now contains chapters for HOST1X, 2D and EPP, so it has some 
more details.

The assignment of sync points is a software policy. Depending on 
programming model of client unit, one or more sync points are used for 
each. For example, for each DC we have one sync point assigned to 
vblank, and one for each DC window. For 2D, we'd have one sync point, 
and a choice of using the same of different sync point for EPP.

We could either assign sync point registers by hard coding, or assign 
them dynamically one per client unit, and possibly an additional one 
depending on the programming model. Sync points are a scarce resource, 
so we've so far preferred to do static assignment to catch 
overallocation as early as possible.

Terje
