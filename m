Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab2EaStR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:49:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51495 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752153Ab2EaStP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:49:15 -0400
Message-ID: <1338490153.5861.5.camel@joe2Laptop>
Subject: Re: [PATCH 1/3] drivers/net: Convert compare_ether_addr to
 ether_addr_equal
From: Joe Perches <joe@perches.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date: Thu, 31 May 2012 11:49:13 -0700
In-Reply-To: <20120531150124.119853l3a0cbvj40@www.81.fi>
References: <7c9881a67c52c2f218480b6742155b6d6928122d.1336618708.git.joe@perches.com>
	 <20120510173201.16131du3cg90nybo@www.81.fi>
	 <1336666288.22495.14.camel@joe2Laptop>
	 <20120510.123353.1458740731067514606.davem@davemloft.net>
	 <20120531150124.119853l3a0cbvj40@www.81.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 15:01 +0300, Jussi Kivilinna wrote:
> Quoting David Miller <davem@davemloft.net>:
> > From: Joe Perches <joe@perches.com>
> > Date: Thu, 10 May 2012 09:11:28 -0700
> >> On Thu, 2012-05-10 at 17:32 +0300, Jussi Kivilinna wrote:
> >>> Quoting Joe Perches <joe@perches.com>:
> >>> > Use the new bool function ether_addr_equal to add
> >>> > some clarity and reduce the likelihood for misuse
> >>> > of compare_ether_addr for sorting.
> >> []
> >>> > diff --git a/drivers/net/wireless/rndis_wlan.c
> >> []
> >>> > @@ -2139,7 +2139,7 @@ resize_buf:
> >>> >  	while (check_bssid_list_item(bssid, bssid_len, buf, len)) {
> >>> >  		if (rndis_bss_info_update(usbdev, bssid) && match_bssid &&
> >>> >  		    matched) {
> >>> > -			if (compare_ether_addr(bssid->mac, match_bssid))
> >>> > +			if (!ether_addr_equal(bssid->mac, match_bssid))
> >>>
> >>> While reviewing this, noticed that above original code is wrong. It
> >>> should be !compare_ether_addr. So do I push patch fixing this through
> >>> wireless-testing althought it will later cause conflict with this patch?
[]
> That line/compare was added as response to hardware bug, where bssid-list does
> not contain BSSID and other information of currently connected AP  
> (spec insists
> that device must provide this information in the list when connected). Lack
> bssid-data on current connection then causes WARN_ON somewhere in cfg80211.
> Workaround was to check if bssid-list returns current bssid and if it  
> does not,
> manually construct bssid information in other ways. And this  
> workaround worked,
> with inverse check. Which must mean that when hardware is experiencing the
> problem, it's actually returning empty bssid-list.
> 
> Inverse check causes workaround be activated when bssid-list returns only
> entry, currently connected BSSID. That does not cause problems in itself, just
> slightly more inaccurate information in scan-list.

Thanks.

That information would be useful in the
eventual commit message.

cheers, Joe

