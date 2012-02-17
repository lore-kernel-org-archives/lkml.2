Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2BQVDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:03:53 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54785 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2BQVDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:03:51 -0500
Date: Fri, 17 Feb 2012 16:02:46 -0500 (EST)
Message-Id: <20120217.160246.1152435667025162438.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, adobriyan@gmail.com, paul.gortmaker@windriver.com,
        richard.cochran@omicron.at, jkosina@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/10] ethoc: set addr_assign_type if
 random_ether_addr() used
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329493411-25750-9-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
	<1329493411-25750-9-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 13:02:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 16:43:29 +0100

> Set addr_assign_type correctly to NET_ADDR_RANDOM in case
> a random MAC address was generated and assigned to the netdevice.
> 
> Fixed ethoc_set_mac_address() to check if the given mac
> address is valid and set also dev_addr of the net_device.
> Check also the return value of ethoc_set_mac_address() in
> ethoc_probe().
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.
> 
> v2: set net_device->dev_addr in ethoc_set_mac_address(),
>     check if given address is valid
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied, but more coding style problems:

> +	if(!is_valid_ether_addr(mac))

Come on, "if[SPACE](..." always.

> +        

Trailing whitespace.

> +	if (ret) {
> +		dev_err(&netdev->dev, "failed to set MAC address\n");
> +		goto error;
> +	}
> +	

More tailing whitespace.
