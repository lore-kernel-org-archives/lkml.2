Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab1CCNxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 08:53:39 -0500
Received: from mail.solarflare.com ([216.237.3.220]:58501 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab1CCNxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 08:53:38 -0500
Subject: Re: [RFC PATCH] net/core: fix skb handling on netif serves for
 both bridge and vlan
From: Ben Hutchings <bhutchings@solarflare.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>
In-Reply-To: <1299149713-18740-1-git-send-email-dfeng@redhat.com>
References: <1299149713-18740-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 03 Mar 2011 13:53:34 +0000
Message-ID: <1299160414.4277.49.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2011 13:53:37.0513 (UTC) FILETIME=[652A4D90:01CBD9AA]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17988.004
X-TM-AS-Result: No--12.929100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 18:55 +0800, Xiaotian Feng wrote:
> Consider network topology as follows:
> 
> eth0  eth1
>  |_____|
>     |
>   bond0 --- br0
>     |
>   vlan0 --- br1
> 
> bond0 serves for both br0 and vlan0, if a vlan tagged packet was sent
> to br1 through bond0, bridge handling code is seeing the packet on bond0
> and handing it off to my "legacy" bridge before vlan_tx_tag_present
> and vlan_hwaccel_do_receive even haven't a chance to look at it.
[...]

This used to work if the underlying device (bond0 in your example)
implemented VLAN tag extraction, because the VLAN group would be checked
before the bridge.  But it never worked for devices without VLAN tag
extraction.  Perhaps we should just prevent this configuration.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

