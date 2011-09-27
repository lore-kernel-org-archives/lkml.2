Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1I0CWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 22:22:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56248 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1I0CWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 22:22:20 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4E81302B.8060903@freescale.com>
References: <1316502540.4269.1.camel@phoenix> <4E81302B.8060903@freescale.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 27 Sep 2011 10:21:59 +0800
Message-ID: <CAF+7xWmy6v6XWMwrHSdRTUPBKmtQ1Wf88gBD0LDZCUWwg_Gd_A@mail.gmail.com>
Subject: Re: [PATCH] ASoC: fsl: Fix error handling if platform_device_add fails
To: Tabi Timur-B04825 <B04825@freescale.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/27 Tabi Timur-B04825 <B04825@freescale.com>:
> Axel Lin wrote:
>> Call platform_device_put() instead of platform_device_unregister() if
>> platform_device_add() fails.
>
> What's wrong with calling platform_device_unregister()?

/**
 * platform_device_unregister - unregister a platform-level device
 * @pdev: platform device we're unregistering
 *
 * Unregistration is done in 2 steps. First we release all resources
 * and remove it from the subsystem, then we drop reference count by
 * calling platform_device_put().
 */

platform_device_unregister() actually calls platform_device_del() and
platform_device_put().

If platform_device_add() call fails, we failed to add the platform
device to device hierarchy. Thus we can just call platform_device_put() instead.

>
> --
> Timur Tabi
> Linux kernel developer at Freescale
>
