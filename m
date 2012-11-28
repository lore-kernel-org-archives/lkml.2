Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab2K1PBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:01:15 -0500
Received: from smtp181.dfw.emailsrvr.com ([67.192.241.181]:36999 "EHLO
	smtp181.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab2K1PBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:01:13 -0500
Message-ID: <50B6273B.1000007@calxeda.com>
Date: Wed, 28 Nov 2012 09:01:15 -0600
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 6/6 v6] cpufreq, highbank: add support for highbank cpufreq
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1354046672-7392-1-git-send-email-mark.langsdorf@calxeda.com> <1354046672-7392-7-git-send-email-mark.langsdorf@calxeda.com> <20121128023240.GA28170@S2100-06.ap.freescale.net> <50B60E9C.9000405@calxeda.com> <20121128145759.GB28170@S2100-06.ap.freescale.net> <20121128151741.GC28170@S2100-06.ap.freescale.net>
In-Reply-To: <20121128151741.GC28170@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 09:17 AM, Shawn Guo wrote:
> On Wed, Nov 28, 2012 at 10:58:02PM +0800, Shawn Guo wrote:
>> On Wed, Nov 28, 2012 at 07:16:12AM -0600, Mark Langsdorf wrote:
>>> I'd
>>> have to move most of the logic of hb_set_target() into
>>> clk_highbank.c:clk_pll_set_rate() and then add extra logic for when
>>> cpufreq is not enabled/loaded.
>>
>> You only need to move hb_voltage_change() into cpu clock's .set_rate()
>> hook with no need of checking if cpufreq is enabled or not.
>>
> Need to also check whether frequency or voltage should be changed first
> in .set_rate() though.

Yes, that's entirely what I meant when I said that I would need to move
most of the hb_set_target() logic into .set_rate(). I would also need to
account for retries if the voltage set operation fails, which it
sometimes does.

The ECME handles changing the voltage but doesn't look like a voltage
regulator. Amongst other things, by design it doesn't export meaningful
voltage information to Linux. I tried to get cpufreq-clk0 to work with
the Highbank design and it ended up being much easier and more sane to
create a separate driver.

--Mark Langsdorf
Calxeda, Inc.

