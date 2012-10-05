Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab2JEUxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:53:47 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:65530 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932918Ab2JEUxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:53:42 -0400
Message-ID: <1349470415.2819.1.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] mlx4: set carrier off after register netdev
From: Ben Hutchings <bhutchings@solarflare.com>
To: Min Zhang <mzhang@mvista.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 5 Oct 2012 21:53:35 +0100
In-Reply-To: <alpine.LNX.2.00.1210051058420.16216@linux-acr3.site>
References: <alpine.LNX.2.00.1210051058420.16216@linux-acr3.site>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 11:28 -0700, Min Zhang wrote:
> ifconfig mlx4_en port reported RUNNING even though the link was down.
> 
> mlx4_en_init_netdev didn't initialize the dev operstate properly so
> the operstate stayed as default IF_OPER_UNKNOWN, then ifconfig treated
> the UNKNOWN as RUNNING state for backward compatiblity per RFC2863.
> 
> The fix calls netif_carrier_off which is supposed to set operstate
> after register_netdev. Calling it before register_netdev has no effect
> since the dev->state is still NETREG_UNINITIALIZED
> 
> Tested by removing the physical link signal to the mellanox 10G port,
> modprobe mlx4_en, then ifconfig up. Verify there is no RUNNING status.
[...]

This was supposed to be fixed by:

commit 8f4cccbbd92f2ad0ddbbc498ef7cee2a1c3defe9
Author: Ben Hutchings <bhutchings@solarflare.com>
Date:   Mon Aug 20 22:16:51 2012 +0100

    net: Set device operstate at registration time

Does that not work for mlx4_en, for some reason?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

