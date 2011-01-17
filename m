Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab1AQQAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 11:00:50 -0500
Received: from mail.solarflare.com ([216.237.3.220]:46575 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1AQQAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 11:00:48 -0500
Subject: Re: 2.6.37 regression: adding main interface to a bridge breaks
 vlan interface RX
From: Ben Hutchings <bhutchings@solarflare.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jesse@nicira.com, Herbert Xu <herbert@gondor.hengli.com.au>
In-Reply-To: <4D32FC1C.3010905@simon.arlott.org.uk>
References: <4D32FC1C.3010905@simon.arlott.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 17 Jan 2011 16:00:44 +0000
Message-ID: <1295280044.6264.5.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jan 2011 16:00:47.0232 (UTC) FILETIME=[B43E4800:01CBB65F]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17898.005
X-TM-AS-Result: No--4.399300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-16 at 14:09 +0000, Simon Arlott wrote:
> [    1.666706] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 16, addr 00:e0:81:4d:2b:ec
> [    1.666767] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt gbit lnktim msi desc-v3
> 
> I have eth0 and eth0.3840 which works until I add eth0 to a bridge.
> While eth0 is in a bridge (the bridge device is up), eth0.3840 is unable
> to receive packets. Using tcpdump on eth0 shows the packets being
> received with a VLAN tag but they don't appear on eth0.3840. They appear
> with the VLAN tag on the bridge interface.
[...]

This means the behaviour is now consistent, whether or not hardware VLAN
tag stripping is enabled.  (I previously pointed out the inconsistent
behaviour in <http://thread.gmane.org/gmane.linux.network/149864>.)  I
would consider this an improvement.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

