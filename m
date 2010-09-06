Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0IFL1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:27:15 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35328 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab0IFL1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:27:14 -0400
MIME-Version: 1.0
X-Originating-IP: [81.243.35.243]
In-Reply-To: <201009061243.00479.trenn@suse.de>
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com>
	<20100904081801.GA19876@elte.hu>
	<AANLkTinrRoi6y1fKUevu2O-Diac5B2r8RftTWUigQZOh@mail.gmail.com>
	<201009061243.00479.trenn@suse.de>
Date: Mon, 6 Sep 2010 13:27:13 +0200
Message-ID: <AANLkTik8_ixOcFy=c4hPZknyUqPYB+2hzQTNK9wVok4q@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Thomas Renninger <trenn@suse.de>
Cc: discuss@lesswatts.org, linux-pm@lists.linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 6, 2010 at 12:42 PM, Thomas Renninger <trenn@suse.de> wrote:
...
>> I will re-start a thread with the full patch and with both lkml and
>> linux-omap in Cc.
> discuss@lesswatts.org and linux-pm@lists.linux-foundation.org
> are also lists where people could be interested in such stuff.
>
> Could you explain a bit what these ARM specific power domains are then, please.
Sure. This is OMAP specific but could easily be used on all platforms.
To make it short, the OMAP chip is organized in power domains (16 in
OMAP3) where you can adjust the power supply voltage. In each power
domain you have different clocks that you can enable, disable or
change the rate of. In order to reach an efficient low power mode you
need to ensure that all clocks in a clock domain are idled or cut off
(automatically by the HW or with the intervention of SW drivers).

The HW complexity requires the tracing of all those clocks/power
states, that is why new events are proposed.

> One idea I had after seeing these:
> Would it make sense to additionally add one or several device power perf event(s)?
> bluetooth, wireless, usb, cameras, whatever, could register it by name,
> like you've done it with the power domains.
> E.g. I had a problem with 2.6.31 where bluetooth was powered up/activated at
> boot time, while it got activated ondemand before. Cost me some Watts and quite
> some time to find that out.
> Showing perf power events when bluetooth gets activated and put into lower power
> states again (and the same for other devices), sounds like a good idea?
That makes sense. The proposed clock/power events can be used by any
device, might it be chipset internal or external. Of course a proper
API or naming convention is needed.

>
>     Thomas
>

Hope this helps,
Jean
