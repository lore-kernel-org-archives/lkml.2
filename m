Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab1KIQZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:25:14 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:35511 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753260Ab1KIQZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:25:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMBACmpuk4Y9geI/2dsb2JhbAAMHBqEfaN6hB4BAQEBAyNWEAsOCgICBSECAg8CRgYNAQcBAYgGI6UmkkCBMIc5gRYEiAyeKU4
X-IronPort-AV: E=Sophos;i="4.69,484,1315195200"; 
   d="scan'208";a="147165515"
Message-ID: <4EBAA967.10403@teksavvy.com>
Date: Wed, 09 Nov 2011 11:25:11 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/usb/asix:  resync from vendor's copy
References: <4EA89972.5060101@teksavvy.com>  <20111026.194045.2019668159403582571.davem@davemloft.net>  <4EA8B283.3010105@teksavvy.com>  <20111026.221719.2216112919297458522.davem@davemloft.net>  <4EB19BBE.5050602@teksavvy.com> <1320266549.2782.21.camel@bwh-desktop>
In-Reply-To: <1320266549.2782.21.camel@bwh-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-02 04:42 PM, Ben Hutchings wrote:
> On Wed, 2011-11-02 at 15:36 -0400, Mark Lord wrote:
> [...]
>> First cut (for review) at updating the in-kernel asix usb/network driver
>> from the latest vendor GPL version of the driver, obtained from here:
>>
>>   http://www.asix.com.tw/download.php?sub=searchresult&PItemID=84&download=driver
..
>> --- linux-3.0/drivers/net/usb/asix.c	2011-10-12 17:59:03.000000000 -0400
>> +++ linux/drivers/net/usb/asix.c	2011-11-01 19:00:50.051289683 -0400
> [...]
...
>> +	.set_tx_csum		= ax88772b_set_tx_csum,
>> +	.get_tx_csum		= ax88772b_get_tx_csum,
>> +	.get_rx_csum		= ax88772b_get_rx_csum,
>> +	.set_rx_csum		= ax88772b_set_rx_csum,
>> +};
> 
> The various ethtool operations for offload flags are being (or have
> been) removed.  The driver must set net_device::hw_features and
> implement net_device_ops::ndo_set_features instead.

Okay, I see what to do for the rx_csum stuff, based on other drivers.

But is there anything to replace the tx_csum stuff,
or should I just remove it entirely without a substitute?

(thanks).

