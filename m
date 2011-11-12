Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1KLLAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 06:00:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40765 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab1KLLAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 06:00:21 -0500
MIME-Version: 1.0
In-Reply-To: <1321074108-10025-1-git-send-email-inderpal.singh@linaro.org>
References: <1321074108-10025-1-git-send-email-inderpal.singh@linaro.org>
Date: Sat, 12 Nov 2011 12:00:20 +0100
Message-ID: <CACRpkdbC=w5vRvgLVpAcmcampt-baTydpLHBexak4RzxUcO32Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: SAMSUNG: Save/restore GPIO drive strength across suspend/resume
From: Linus Walleij <linus.walleij@linaro.org>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 12, 2011 at 6:01 AM, Inderpal Singh
<inderpal.singh@linaro.org> wrote:

> GPIO driver strength settings are not preserved across suspend/resume
> for s5pc100, s5pv210 and Exynos platforms which has been the cause of
> mmc/sd card read/write failures after resume. Fix this by saving and
> restoring the GPIO driver strength register settings across suspend/resume.
>
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>

On a related theme: I am thinking about how to support preserving
drive strength (etc) across suspend/resume and deepsleep in the
pincontrol subsystem.

Currently I am playing with the idea to let pin groups have states,
as the different configurations seem to be 90% or so about very
specific sleep modes, so say:

pinconf_set_group_state("mmcgroup", PINCONF_STATE_ACTIVE);
pinconf_set_group_state("mmcgroup", PINCONF_STATE_SUSPENDED);
pinconf_set_group_state("mmcgroup", PINCONF_STATE_SLEEP);

This would then instruct each pin controller driver to configure
each pin apropriately for the given state, and that cross-references
to a table keeping track of the preset per-pin for each state.

My intuitive idea is that letting the core keep track of the state of
every pin and letting pin groups harness the settings for a group
of pins is the proper approach to the problem.

Do you think something like this will work for the S5P:s?

Yours,
Linus Walleij
