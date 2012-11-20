Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab2KTS6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:58:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33941 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2KTS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:58:42 -0500
Message-ID: <50ABD2DE.6010601@wwwdotorg.org>
Date: Tue, 20 Nov 2012 11:58:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Josh Cartwright <josh.cartwright@gmail.com>
CC: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH V2 2/2] ARM: tegra: move timer.c to drivers/clocksource/
References: <1353371237-2482-1-git-send-email-swarren@wwwdotorg.org> <1353371237-2482-2-git-send-email-swarren@wwwdotorg.org> <20121120005036.GA6280@kryptos>
In-Reply-To: <20121120005036.GA6280@kryptos>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 05:50 PM, Josh Cartwright wrote:
> On Mon, Nov 19, 2012 at 05:27:17PM -0700, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Move arch/arm/mach-tegra/timer.c to drivers/clocksource/tegra20_timer.c
>> so that the code is co-located with other clocksource drivers, and to
>> reduce the size of the mach-tegra directory.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> v2: Rebase on ARM sys_timer rework, and addition of clocksource_of_init().
> [..]
>> diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
>> index aeec8d2..328d18f 100644
>> --- a/drivers/clocksource/clksrc-of.c
>> +++ b/drivers/clocksource/clksrc-of.c
>> @@ -20,6 +20,10 @@
>>  #include "clksrc-of.h"
>>  
>>  static const struct of_device_id clksrc_of_match[] __initconst = {
>> +	{
>> +		.compatible = "nvidia,tegra20-timer",
>> +		.data = tegra20_init_timer,
>> +	},
> 
> Shouldn't this be wrapped in #if ARCH_TEGRA?

Yes.

> I had suggested this with Thomas Petazzoni's consolidated irq_chip patch
> as well:
> 
> It seems like it would be a bit cleaner/easier to maintain if we relied
> on the linker to stitch together a clksrc_of_match table, based on what
> clocksources are being built into the image.  With that approach, at
> least, a public initialization header wouldn't have to be exposed, and
> this central table wouldn't have to be maintained (as more clocksrcs are
> added, I forsee [admittedly trivial] merge conflicts).
> 
> Thoughts?

I thought I'd wait for Thomas' revised patch and copy that, but it
turned out to be easier that I figured to implement. So, new revision
coming soon!
