Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab2GESto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:49:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40002 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab2GEStm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:49:42 -0400
Message-ID: <4FF5E1C3.6070309@wwwdotorg.org>
Date: Thu, 05 Jul 2012 12:49:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux@arm.linux.org.uk, ccross@android.com, olof@lixom.net,
        pdeschrijver@nvidia.com
Subject: Re: [PATCH v3 0/6] Port Tegra to generic clk framework
References: <1341482120-3317-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1341482120-3317-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 03:55 AM, Prashant Gaikwad wrote:
> This patch set ports Tegra clock code to generic clock framework.

Unfortunately, this series causes some regressions, so I can't apply it
now. Given that, it won't make 3.6 since I won't be around to apply it.

I tested both Tegra's for-next, and next-20120705, both plus this
series, next-20120705 plus the fix for the common clock code
__clk_set_parent() issue.

The following all appeared to work OK:

Cardhu DT
Ventana DT
Seaboard DT
Springbank DT
Harmony DT
Harmony non-DT

However, the following failed, all(?) in ways that prevented the system
getting to the login prompt:

Whistler DT
AC100 DT
AC100 non-DT
Trimslice DT
Trimslice non-DT

(The one slight difference between the 2 branches I tested is that AC100
and Trimslice booted using DT passed in next-20120705 but failed only in
Tegra's for-next. Otherwise, all results were identical)

I'll try to investigate what the issues are since I imagine you don't
have access to these boards. But, I probably won't be able to fix this
until I return from vacation.
