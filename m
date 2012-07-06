Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab2GFQPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:15:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40085 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab2GFQPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:15:22 -0400
Message-ID: <4FF70F16.50205@wwwdotorg.org>
Date: Fri, 06 Jul 2012 10:15:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@ti.com" <mturquette@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH v3 0/6] Port Tegra to generic clk framework
References: <1341482120-3317-1-git-send-email-pgaikwad@nvidia.com> <4FF5E1C3.6070309@wwwdotorg.org> <4FF6F7CF.9000405@nvidia.com>
In-Reply-To: <4FF6F7CF.9000405@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 08:35 AM, Prashant Gaikwad wrote:
> On Friday 06 July 2012 12:19 AM, Stephen Warren wrote:
>> On 07/05/2012 03:55 AM, Prashant Gaikwad wrote:
>>> This patch set ports Tegra clock code to generic clock framework.
> <snip>
>> (The one slight difference between the 2 branches I tested is that AC100
>> and Trimslice booted using DT passed in next-20120705 but failed only in
>> Tegra's for-next. Otherwise, all results were identical)
>>
>> I'll try to investigate what the issues are since I imagine you don't
>> have access to these boards. But, I probably won't be able to fix this
>> until I return from vacation.
> 
> Stephen,
> 
> Can you please try removing "late_initcall(clk_disable_unused);" from
> drivers/clk/clk.c?
> It will keep unused clocks enabled. If it works then there should not be
> any regression in this patch series but need to enable some board
> specific clock.

On Whistler using next-20120705, that did help a bit; the board actually
boots to the login prompt in the usual amount of time rather than
hanging before even detecting the root filesystem.

However, there is obviously still some problem with I2C accesses, since
neither the pca953x nor wm8753 drivers are able to communicate with
their devices.

Re: the DT-vs-non-DT differences, it's most likely because only parts of
the clock initialization table are common (in common.c) and parts are in
board-${boardname}.c (for non-DT) or board-dt-tegra*.c (for DT). I'm
looking forward to when we can just put all the clock setup in the
board-specific .dts files:-)

I'll investigate more later (where most later might mostly be in 2 weeks
after I return from vacation)
