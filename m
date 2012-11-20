Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab2KTUir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:38:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43133 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2KTUiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:38:46 -0500
Message-ID: <50ABEA52.6070405@wwwdotorg.org>
Date: Tue, 20 Nov 2012 13:38:42 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Josh Cartwright <josh.cartwright@gmail.com>
CC: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 1/2] clocksource: add common of_clksrc_init() function
References: <1353439206-1654-1-git-send-email-swarren@wwwdotorg.org> <20121120201026.GF6280@kryptos>
In-Reply-To: <20121120201026.GF6280@kryptos>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 01:10 PM, Josh Cartwright wrote:
> On Tue, Nov 20, 2012 at 12:20:05PM -0700, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> It is desirable to move all clocksource drivers to drivers/clocksource,
>> yet each requires its own initialization function. We'd rather not
>> pollute <linux/> with a header for each function. Instead, create a
>> single of_clksrc_init() function which will determine which clocksource
>> driver to initialize based on device tree.
>>
>> Inspired by a similar patch for drivers/irqchip by Thomas Petazzoni.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> v3: Use a linker section to replace manually maintained table.
>> v2: New patch.
>>
> [..]
>> --- /dev/null
>> +++ b/drivers/clocksource/clksrc-of.c

>> +void __init clocksource_of_init(void)
...
>> +	for ( ; table < stop; table++) {
>> +		for_each_matching_node(np, *table) {
>> +			match = of_match_node(*table, np);
>> +			init_func = match->data;
>> +			init_func();
> 
> Hmm.  Am I crazy, or does this for_each_matching_node()/of_match_node()
> pattern end up walking the match table twice, unnecessarily?

Yes, that's true.

> I'm wondering if we can come up with a for_each_matching_node_id() macro
> that also provides a pointer to the matching of_device_id...

Good idea; I'll do that.
