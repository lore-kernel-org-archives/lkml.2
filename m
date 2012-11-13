Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab2KMRSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:18:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19516 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab2KMRSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:18:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 13 Nov 2012 09:18:47 -0800
Message-ID: <50A28055.7040606@nvidia.com>
Date: Tue, 13 Nov 2012 22:46:05 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: Add locked version of regulator_put
 to	avoid deadlock
References: <1352198049-5941-1-git-send-email-ldewangan@nvidia.com> <20121106111256.GA2512@opensource.wolfsonmicro.com> <20121106113138.GB10080@opensource.wolfsonmicro.com> <20121113163040.GA19089@opensource.wolfsonmicro.com>
In-Reply-To: <20121113163040.GA19089@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012 10:00 PM, Charles Keepax wrote:
> When regulator_register fails and exits through the scrub path the
> regulator_put function was called whilst holding the
> regulator_list_mutex, which is also locked from regulator_put, causing
> deadlock.
>
> This patch adds a locked version of the regulator_put function which can
> be safely called whilst holding the mutex, replacing the aforementioned
> call.
>
> Signed-off-by: Charles Keepax<ckeepax@opensource.wolfsonmicro.com>
> Cc: Laxman Dewangan<ldewangan@nvidia.com>
> ---
>
> I hope this isn't bad etiquette but I took the liberaty of fixing up
> the patch as per the comments and taking into account the removal of
> my original patch. Apologies if this is not the done thing, do let
> me know if you would rather submit a version yourself but I
> thought best to address the issue and get a fix in.

This looks fine.
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
