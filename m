Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266Ab2JYTsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:48:52 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:26743 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760244Ab2JYTss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:48:48 -0400
Message-ID: <1351194525.2662.21.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] tilegx: fix some issues in the SW TSO support
From: Ben Hutchings <bhutchings@solarflare.com>
To: Chris Metcalf <cmetcalf@tilera.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2012 20:48:45 +0100
In-Reply-To: <1351193806.2662.18.camel@bwh-desktop.uk.solarflarecom.com>
References: <201210251737.q9PHbgev032681@farm-0012.internal.tilera.com>
	 <1351187513.2662.9.camel@bwh-desktop.uk.solarflarecom.com>
	 <508981E1.4030600@tilera.com>
	 <1351193806.2662.18.camel@bwh-desktop.uk.solarflarecom.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 20:36 +0100, Ben Hutchings wrote:
[...]
> There's a simple way to test this - configure the 'attacker' host and
> interface like this:
> 
> # ip link set $IFACE mtu 128
> # sysctl net.ipv4.route.min_adv_mss=88
> 
> and then use something like netperf to generate a high bandwidth stream
> of TCP traffic toward it from the tilegx interface.

Also you would need to run some other traffic in parallel (multiple
streams to the 'attacker' and some more normal streams) to ensure there
is real contention.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

