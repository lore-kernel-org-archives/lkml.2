Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2GZBfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 21:35:14 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:44344 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab2GZBfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 21:35:11 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q6Q1YJa6002465, This message is released by code: ctaloc0852
Message-ID: <50109E9B.6080806@realsil.com.cn>
Date: Thu, 26 Jul 2012 09:34:19 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@amd.com>
CC: Borislav Petkov <bp@alien8.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Philip Rakity <prakity@marvell.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 1/3] drivers/misc: Add realtek card reader core driver
References: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn> <20120723163340.GA4105@x1.osrc.amd.com> <500DF89E.6090501@realsil.com.cn> <20120724064409.GA15735@liondog.tnic> <500E6126.4060604@realsil.com.cn> <20120724140709.GA13753@x1.osrc.amd.com> <500F59D7.2050508@realsil.com.cn> <20120725080415.GA21341@liondog.tnic> <20120725101601.GA8578@aarontestpc.amd.com>
In-Reply-To: <20120725101601.GA8578@aarontestpc.amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaron:

Thank you. I will modify our host per your suggestion.

BR,
wwang

于 2012年07月25日 18:16, Aaron Lu 写道:
> Hi Wei,
>
> We do not use MMC_CAP_MAX_CURRENT_* anymore, for your host, I would
> sugget you do something like this:
>
> static void realtek_init(struct realtek_sdmmc *host)
> {
> 	struct mmc_host *mmc = host->mmc;
> 	... ...
> 	/*
> 	 * since you have set MMC_CAP_MAX_CURRENT_800 in your
> 	 * original code, I assume your host can provide more than
> 	 * 800mA, and you've set the 1.8v support bit in your original
> 	 * code for the host, so I also set the max_current_180 to 800mA.
> 	 */
> 	mmc->max_current_330 = 800;
> 	mmc->max_current_180 = 800;
> 	... ...
> }
>
> Does this look right to you?
>
> Thanks,
> Aaron
>
>

