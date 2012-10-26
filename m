Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965876Ab2JZSRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:17:50 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:20740 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965556Ab2JZSRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:17:49 -0400
Message-ID: <508AD3CB.8070303@tilera.com>
Date: Fri, 26 Oct 2012 14:17:47 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tilegx: fix some issues in the SW TSO support
References: <201210251737.q9PHbgev032681@farm-0012.internal.tilera.com>  <1351187513.2662.9.camel@bwh-desktop.uk.solarflarecom.com>  <508981E1.4030600@tilera.com>  <1351193806.2662.18.camel@bwh-desktop.uk.solarflarecom.com> <1351194525.2662.21.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1351194525.2662.21.camel@bwh-desktop.uk.solarflarecom.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 3:48 PM, Ben Hutchings wrote:
> On Thu, 2012-10-25 at 20:36 +0100, Ben Hutchings wrote:
> [...]
>> There's a simple way to test this - configure the 'attacker' host and
>> interface like this:
>>
>> # ip link set $IFACE mtu 128
>> # sysctl net.ipv4.route.min_adv_mss=88
>>
>> and then use something like netperf to generate a high bandwidth stream
>> of TCP traffic toward it from the tilegx interface.
> Also you would need to run some other traffic in parallel (multiple
> streams to the 'attacker' and some more normal streams) to ensure there
> is real contention.

Thanks!  I've filed a bugzilla within Tilera to come back and revisit this
- I think it's not a short-term problem so we'll find some time to look at
it in the future.  Or, someone reading this could try it themselves and
submit the patch :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

