Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2CARvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:51:35 -0500
Received: from mail.solarflare.com ([216.237.3.220]:26922 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754736Ab2CARve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:51:34 -0500
Message-ID: <1330624289.2609.36.camel@bwh-desktop>
Subject: Re: [PATCH v2 1/7] net: validate MAC address directly in
 dev_set_mac_address()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: "David S. Miller" <davem@davemloft.net>,
        Eilon Greenstein <eilong@broadcom.com>,
        Danny Kukawka <dkukawka@suse.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Jiri Pirko <jpirko@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        Randy Dunlap <rdunlap@xenotime.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 1 Mar 2012 17:51:29 +0000
In-Reply-To: <1330620747-4047-2-git-send-email-danny.kukawka@bisect.de>
References: <1330620747-4047-1-git-send-email-danny.kukawka@bisect.de>
	 <1330620747-4047-2-git-send-email-danny.kukawka@bisect.de>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18742.005
X-TM-AS-Result: No--13.908800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-01 at 17:52 +0100, Danny Kukawka wrote:
> Validate the given MAC address directly in dev_set_mac_address()
> if a .ndo_validate_addr function is available before calling
> the .ndo_set_mac_address function.
> 
> Changed .ndo_validate_addr to take a second parameter containing
> a sockaddr struct to be checked instead of the net_device dev_addr.
> The behaviour of .ndo_validate_addr is now: if the second parameter
> is NULL the net_device->dev_addr gets validate, if != NULL
> the given parameter/sockaddr gets validated instead.
[...]

The caller is assumed to have validated the address family, so why not
just pass a pointer to the hardware address (u8 *), and get rid of the
special case for NULL?

That is, dev_set_mac_address would call:
	ops->ndo_validate_addr(dev, sa->sa_data);
and dev_open would call:
	ops->ndo_validate_addr(dev, dev->dev_addr);

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

