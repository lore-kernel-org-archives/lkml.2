Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab2LKBUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 20:20:54 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:64463 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2LKBUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 20:20:53 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <1354264973-11214-1-git-send-email-a.kesavan@samsung.com>
References: <1354264973-11214-1-git-send-email-a.kesavan@samsung.com>
Date: Tue, 11 Dec 2012 10:20:51 +0900
X-Google-Sender-Auth: aeFbTayZoil2B9Y2jSbwdyuvxXo
Message-ID: <CAJ0PZbTTDdAXJ378R7CDO2=spx7WF_RpztG5ch7iFZWx-v3N2Q@mail.gmail.com>
Subject: Re: [PATCH RFC] PM/Devfreq: Add Exynos5-bus devfreq driver for Exynos5250.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: kyungmin.park@samsung.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, kgene.kim@samsung.com,
        jhbird.choi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 5:42 PM, Abhilash Kesavan <a.kesavan@samsung.com> wrote:
> Exynos5-bus device devfreq driver monitors PPMU counters and
> adjusts operating frequencies and voltages with OPP. ASV should
> be used to provide appropriate voltages as per the speed group
> of the SoC rather than using a constant 1.025V.
>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Cc: Jonghwan Choi <jhbird.choi@samsung.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

I've got a few general comments and questions on your patch.

> ---
> This code is based on Jonghwan Choi's <jhbird.choi@samsung.com> devfreq work
> for Exynos5250. This requires corresponding machine specific changes which
> will be posted once the driver is reviewed.
>
>  drivers/devfreq/Kconfig        |   10 +
>  drivers/devfreq/Makefile       |    1 +
>  drivers/devfreq/exynos5_bus.c  |  595 ++++++++++++++++++++++++++++++++++++++++
>  drivers/devfreq/exynos5_ppmu.c |  395 ++++++++++++++++++++++++++
>  drivers/devfreq/exynos5_ppmu.h |   26 ++
>  drivers/devfreq/exynos_ppmu.c  |   56 ++++
>  drivers/devfreq/exynos_ppmu.h  |   79 ++++++
>  7 files changed, 1162 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/devfreq/exynos5_bus.c
>  create mode 100644 drivers/devfreq/exynos5_ppmu.c
>  create mode 100644 drivers/devfreq/exynos5_ppmu.h
>  create mode 100644 drivers/devfreq/exynos_ppmu.c
>  create mode 100644 drivers/devfreq/exynos_ppmu.h

I understand that Exynos PPMU drivers seem not to be used (at least in
mainline Linux) widely and it'd be convinent for a bus driver to have
ppmu driver located in the same source directory.

However, I don't feel very comfortable to have ppmu drivers explicitly
landing in devfreq directory. Would it be possible to place them
somewhere else? (in drivers/misc, arch/arm/mach-exynos, or somewhere
appropriate?) If PPMU drivers really have nowhere to relocate, they
may be located along with its sole user (exynos5_bus.c) anyway.


> +
> +struct exynos5_bus_int_handle {
> +       struct list_head node;
> +       struct delayed_work work;
> +       bool boost;
> +       bool poll;
> +       unsigned long min;
> +};

It appears that "boost" is something may be handled by per-dev QoS.
It looks like that you are reimplementing the pm-qos infrastructure in
the driver.

Could you please implement this w/ per-dev QoS?
Or explain why this is required instead of per-dev PM-QoS?



Cheers,
MyungJoo


-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
