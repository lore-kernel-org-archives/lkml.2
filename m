Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422887Ab2LGQpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:45:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:38814 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422760Ab2LGQpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:45:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,239,1355126400"; 
   d="scan'208";a="228071998"
Message-ID: <50C21D21.5040101@intel.com>
Date: Fri, 07 Dec 2012 08:45:21 -0800
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Joseph Gasparakis <joseph.gasparakis@intel.com>, davem@davemloft.net,
        shemminger@vyatta.com, chrisw@sous-sol.org, gospo@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry@broadcom.com, saeed.bishara@gmail.com,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH v3 1/4] net: Add support for hardware-offloaded encapsulation
References: <1354845419-22483-1-git-send-email-joseph.gasparakis@intel.com>  <1354845419-22483-2-git-send-email-joseph.gasparakis@intel.com> <1354874847.20838.49.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1354874847.20838.49.camel@deadeye.wl.decadent.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 02:07 AM, Ben Hutchings wrote:
> On Thu, 2012-12-06 at 17:56 -0800, Joseph Gasparakis wrote:
>> This patch adds support in the kernel for offloading in the NIC Tx and Rx
>> checksumming for encapsulated packets (such as VXLAN and IP GRE).
> [...]
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -1063,6 +1063,8 @@ struct net_device {
>>  	netdev_features_t	wanted_features;
>>  	/* mask of features inheritable by VLAN devices */
>>  	netdev_features_t	vlan_features;
>> +	/* mask of features inherited by encapsulating devices */
>> +	netdev_features_t	hw_enc_features;
> [...]
> 
> How will the networking core know *which* encapsulations this applies
> to?  I notice that your implementation in ixgbe does not set
> NETIF_F_HW_CSUM here, so presumably the hardware will parse headers to
> find which ranges should be checksummed and it won't cover the next
> encapsulation protocol that comes along.
> 
> Ben.
> 

Actually the offload is generic to any encapsulation that does not
compute a checksum on the inner headers.  So as long as you can treat
the outer headers as one giant L2 header you can pretty much ignore what
is in there as long as the inner network and transport header values are
set.  There are a number of tunnels that fall into that category since
most just use IP as the L2 and the L3 usually doesn't contain any checksum.

Thanks,

Alex




