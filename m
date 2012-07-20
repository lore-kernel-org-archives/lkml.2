Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab2GTDo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 23:44:26 -0400
Received: from smtprelay01.ispgateway.de ([80.67.29.23]:51001 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2GTDoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:44:24 -0400
X-Greylist: delayed 996 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2012 23:44:24 EDT
Message-ID: <5008CEC9.2050908@omicron.at>
Date: Fri, 20 Jul 2012 05:21:45 +0200
From: Christian Riesch <christian.riesch@omicron.at>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
References: <20120720120118.465056f267ab5c3ac5ea45c4@canb.auug.org.au>
In-Reply-To: <20120720120118.465056f267ab5c3ac5ea45c4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Df-Sender: Y2hyaXN0aWFuQHJpZXNjaC5hdA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sent again due to problems with email client]

Hi,

On 07/20/2012 04:01 AM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the net-next tree, today's linux-next build (powerpc
> pmac32_defconfig) failed like this:
>
> ERROR: "phy_disconnect" [drivers/net/usb/asix.ko] undefined!
> ERROR: "phy_stop" [drivers/net/usb/asix.ko] undefined!
> ERROR: "phy_ethtool_gset" [drivers/net/usb/asix.ko] undefined!
> ERROR: "mdiobus_unregister" [drivers/net/usb/asix.ko] undefined!
> ERROR: "phy_start_aneg" [drivers/net/usb/asix.ko] undefined!
> ERROR: "phy_print_status" [drivers/net/usb/asix.ko] undefined!
> ERROR: "phy_start" [drivers/net/usb/asix.ko] undefined!
> ERROR: "mdiobus_free" [drivers/net/usb/asix.ko] undefined!
> ERROR: "mdiobus_register" [drivers/net/usb/asix.ko] undefined!
> ERROR: "genphy_resume" [drivers/net/usb/asix.ko] undefined!
> ERROR: "phy_connect" [drivers/net/usb/asix.ko] undefined!
> ERROR: "phy_mii_ioctl" [drivers/net/usb/asix.ko] undefined!
> ERROR: "phy_ethtool_sset" [drivers/net/usb/asix.ko] undefined!
> ERROR: "mdiobus_alloc_size" [drivers/net/usb/asix.ko] undefined!
>
> Caused by commit 16626b0cc3d5 ("asix: Add a new driver for the AX88172A")
> and reverting that commit fixes the build.

Sorry about that. I missed the dependency of the new driver on phylib. A 
fix for this problem is already in net-next, see commit 215029375c83.

Thanks, Christian

>
> Thanks to Mikey for reporting this porblem.

