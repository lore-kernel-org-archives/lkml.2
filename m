Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2LTRq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:46:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13386 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2LTRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:46:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 20 Dec 2012 09:46:44 -0800
Message-ID: <50D34F00.4080308@nvidia.com>
Date: Thu, 20 Dec 2012 19:46:40 +0200
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
References: <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de> <50C5CAB5.3040000@nvidia.com> <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de> <50C99677.6090306@nvidia.com> <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de> <50CA175F.60002@wwwdotorg.org> <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org> <50CB850F.9090704@nvidia.com> <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de> <50D2D792.1050401@nvidia.com> <50D34775.5010606@wwwdotorg.org>
In-Reply-To: <50D34775.5010606@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.12.2012 19:14, Stephen Warren wrote:
> I'm not sure that sounds right. drvdata is something that a driver
> should manage itself.
> 
> What's wrong with just having each device ask the host1x (its parent)
> for a pointer to the (dummy) tegradrm device. That seems extremely
> simple, and doesn't require abusing existing stuff like drvdata for
> non-standard purposes.

This is tegradrm's own data, and it's tegradrm which accesses the
pointer. So it's entirely something that the driver takes care of itself.

It's simplest if tegradrm takes care of its own data. That way there's
no chance of confusion of ownership or lifecycle of the data. The only
places which needs this access are the probe functions, and adding an
API contract between two components just for these few calls sounds too
much. All code after that anyway access drm_device->dev_private to get
the pointer.

Terje
