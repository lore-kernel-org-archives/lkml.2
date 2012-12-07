Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab2LGKHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 05:07:34 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:9124 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab2LGKHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 05:07:32 -0500
Message-ID: <1354874847.20838.49.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v3 1/4] net: Add support for hardware-offloaded
 encapsulation
From: Ben Hutchings <bhutchings@solarflare.com>
To: Joseph Gasparakis <joseph.gasparakis@intel.com>
CC: <davem@davemloft.net>, <shemminger@vyatta.com>, <chrisw@sous-sol.org>,
        <gospo@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dmitry@broadcom.com>,
        <saeed.bishara@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Date: Fri, 7 Dec 2012 10:07:27 +0000
In-Reply-To: <1354845419-22483-2-git-send-email-joseph.gasparakis@intel.com>
References: <1354845419-22483-1-git-send-email-joseph.gasparakis@intel.com>
	 <1354845419-22483-2-git-send-email-joseph.gasparakis@intel.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 17:56 -0800, Joseph Gasparakis wrote:
> This patch adds support in the kernel for offloading in the NIC Tx and Rx
> checksumming for encapsulated packets (such as VXLAN and IP GRE).
[...]
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1063,6 +1063,8 @@ struct net_device {
>  	netdev_features_t	wanted_features;
>  	/* mask of features inheritable by VLAN devices */
>  	netdev_features_t	vlan_features;
> +	/* mask of features inherited by encapsulating devices */
> +	netdev_features_t	hw_enc_features;
[...]

How will the networking core know *which* encapsulations this applies
to?  I notice that your implementation in ixgbe does not set
NETIF_F_HW_CSUM here, so presumably the hardware will parse headers to
find which ranges should be checksummed and it won't cover the next
encapsulation protocol that comes along.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

