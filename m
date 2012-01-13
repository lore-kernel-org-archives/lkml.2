Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab2AMNuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:50:20 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41625 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2AMNuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:50:19 -0500
Message-ID: <4F1036CD.3090608@linaro.org>
Date: Fri, 13 Jan 2012 17:51:09 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@nokia.com>
CC: linaro-dev@lists.linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: use usleep_range() in mmc_delay()
References: <4EF18310.6080801@linaro.org> <alpine.DEB.2.00.1201131514490.31704@kernel.research.nokia.com>
In-Reply-To: <alpine.DEB.2.00.1201131514490.31704@kernel.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 05:22 PM, Aaro Koskinen wrote:

> Anyway, I think the change is good. On systems with multiple MMC devices
> the boot/probe can spend 100-200 ms alone just doing busylooping delays. I
> think e.g. in mmc_rescan() the code uses frequently mmc_delay(10).

I'm worrying about this:

mmc_delay(DIV_ROUND_UP(card->ext_csd.sa_timeout, 10000))

since I have no ideas about typical values for this timeout.
If it may be too small (<=10 us), using usleep_range() makes no sense.

Dmitry
