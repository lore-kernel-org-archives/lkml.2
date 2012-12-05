Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab2LEPng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:43:36 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8959 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab2LEPnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:43:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 05 Dec 2012 07:43:28 -0800
Message-ID: <50BF6B9C.3020006@nvidia.com>
Date: Wed, 5 Dec 2012 17:43:24 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com> <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de> <50BF1DAA.8030805@nvidia.com> <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de> <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2012 14:04, Thierry Reding wrote:
> On Wed, Dec 05, 2012 at 01:47:38PM +0200, Terje Bergström wrote:
> Yes, but there's more. For instance I went to great lengths to make sure
> there's no global data whatsoever. So all the data is bound to the
> host1x device in the current code. I know many other drivers like to
> take a shortcut and just put these things into global variables but I
> didn't want to.

Sure, that feedback is in the todo list. For some parts I already have a
proposed solution, but for chip ops not yet.

>> The problem with doing drm_platform_init() with host1x device as
>> parameter is that drm_get_platform_dev() will take control of drvdata.
>> We'd need to put host1x specific struct host1x pointer to some other
>> place and I'm not sure what that place could be.
> 
> Not anymore. I submitted a patch so that it no longer does that. The
> patch was merged about a month and a half ago.

Oops, I must've checked the status from a stale tree. Thanks for that.
In this case there's no technical reason why host1x couldn't act as the
device to register for drm, as drm wouldn't touch host1x device data in
any way.

How about if we treat the host1x driver as utility library, and move the
code for host1x probe altogether to tegradrm/host1x.c? I haven't yet
checked how bad the dependencies between host1x's driver's host1x.c and
the rest of the driver are, so I'm not sure if it's feasible and if
there would be a clear design. Just tossing in ideas.

That would solve the circular dependency problem. I've already committed
to contents of host1x.c being very different in downstream and upstream,
so this change would just emphasize that.

Terje
