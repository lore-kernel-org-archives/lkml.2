Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2LNT7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 14:59:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16577 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab2LNT7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 14:59:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 14 Dec 2012 11:58:01 -0800
Message-ID: <50CB850F.9090704@nvidia.com>
Date: Fri, 14 Dec 2012 21:59:11 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com> <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de> <50BF1DAA.8030805@nvidia.com> <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de> <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de> <50C5CAB5.3040000@nvidia.com> <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de> <50C99677.6090306@nvidia.com> <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de> <50CA175F.60002@wwwdotorg.org> <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org>
In-Reply-To: <50CB5205.1030303@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.12.2012 18:21, Stephen Warren wrote:
> On 12/13/2012 11:09 PM, Terje Bergström wrote:
>> They want to get the global data by getting drvdata of their parent.
> 
> There's no reason that /has/ to be so; they can get any information from
> wherever it is, rather than trying to require it to be somewhere it isn't.

Exactly, this was also my solution.

>> The dummy device is not their parent - host1x is. There's no
>> connection between the dummy and the real client devices.
> 
> It's quite possible for the client devices to ask their actual parent
> (host1x) for the tegradrm struct device *, by calling a host1x API, and
> have host1x implement that API by returning the dummy/virtual device
> that it created. That should be just 1-2 lines of code to implement in
> host1x, plus maybe a couple more to correctly return -EPROBE_DEFERRED
> when appropriate.

My solution was to just have one global, and an getter for the global.
Instead of drvdata, the pointer is retrieved with the getter. No need
for dummy device, or passing points between host1x and tegradrm.

Terje

