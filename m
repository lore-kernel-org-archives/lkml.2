Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2JWQ3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:29:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38080 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab2JWQ3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:29:44 -0400
Message-ID: <5086C5F5.4070801@wwwdotorg.org>
Date: Tue, 23 Oct 2012 10:29:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: Pavan Kunapuli <pkunapuli@nvidia.com>, linux@arm.linux.org.uk,
        cjb@laptop.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails
References: <1350976740-19284-1-git-send-email-pkunapuli@nvidia.com>  <1350976740-19284-3-git-send-email-pkunapuli@nvidia.com> <1350979047.20572.6.camel@tellur>
In-Reply-To: <1350979047.20572.6.camel@tellur>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 01:57 AM, Lucas Stach wrote:
> Am Dienstag, den 23.10.2012, 12:49 +0530 schrieb Pavan Kunapuli:
>> vmmc and vqmmc regulators control the voltage to
>> the host and device. Defer the probe if either of
>> them is not registered.
>
> Does this work with boards where we don't have any MMC supplies? Or are
> we just deferring the probe indefinitely there?
> 
> For boards that power MMC unconditionally, are we supposed to add dummy
> regulators to make them work with this patchset?

I believe that dummy (fixed) regulators are supposed to be provided in
all cases where the platform doesn't actually have one. The fact that
everything worked OK without them before this patch was most likely a
mistake/accident.
