Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2K0RRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:17:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51860 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2K0RRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:17:46 -0500
Message-ID: <50B4F5B6.6000008@wwwdotorg.org>
Date: Tue, 27 Nov 2012 10:17:42 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 5/8] ARM: tegra: Add auxiliary data for nvhost
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-6-git-send-email-tbergstrom@nvidia.com> <50B3FDCC.7080709@wwwdotorg.org> <50B45EA8.7000502@nvidia.com>
In-Reply-To: <50B45EA8.7000502@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 11:33 PM, Terje Bergström wrote:
> On 27.11.2012 01:39, Stephen Warren wrote:
>> Clock names shouldn't be passed in platform data; instead, clk_get()
>> should be passed the device object and device-relative (i.e. not global)
>> clock name. I expect if the driver is fixed to make this change, the
>> changes to tegra*_clocks_data.c won't be needed either.
> 
> Isn't this code doing exactly that - getting a device relative clock,
> nvhost_module_init() in nvhost.acm.c:
> 
> (...)
> 	/* initialize clocks to known state */
> 	while (pdata->clocks[i].name && i < NVHOST_MODULE_MAX_CLOCKS) {
> 		long rate = pdata->clocks[i].default_rate;
> 		struct clk *c;
> 
> 		c = devm_clk_get(&dev->dev, pdata->clocks[i].name);

The line above is getting the (device-relative) clock name from platform
data, rather than using some fixed name as it should be.
