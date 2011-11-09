Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab1KIS1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 13:27:42 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:28189 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751275Ab1KIS1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:27:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAE7Fuk4Y9geI/2dsb2JhbAAMNoR9ow6FEAEBAQEDIwRRARALDgoCAgUWCwICCQMCAQIBRQYNAQcBAa1IkkSBMIc5gRYEiAyeKQ
X-IronPort-AV: E=Sophos;i="4.69,484,1315195200"; 
   d="scan'208";a="147201117"
Message-ID: <4EBAC61C.2020808@teksavvy.com>
Date: Wed, 09 Nov 2011 13:27:40 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH v2] drivers/net/usb/asix:  resync from vendor's copy
References: <4EA89972.5060101@teksavvy.com>  <20111026.194045.2019668159403582571.davem@davemloft.net>  <4EA8B283.3010105@teksavvy.com>  <20111026.221719.2216112919297458522.davem@davemloft.net>  <4EB19BBE.5050602@teksavvy.com>  <4EBAB8F5.1010101@teksavvy.com> <1320860857.2781.5.camel@bwh-desktop>
In-Reply-To: <1320860857.2781.5.camel@bwh-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-09 12:47 PM, Ben Hutchings wrote:
> On Wed, 2011-11-09 at 12:31 -0500, Mark Lord wrote:
> [...]
>> +static int ax88172_link_reset(struct usbnet *dev)
>> +{
>> +       u16 lpa;
>> +       u16 adv;
>> +       u16 res;
>> +       u8 mode;
>> +
>> +       mode = AX_MEDIUM_TX_ABORT_ALLOW | AX_MEDIUM_FLOW_CONTROL_EN;
>> +       lpa = ax8817x_mdio_read_le(dev->net, dev->mii.phy_id, MII_LPA);
>> +       adv = ax8817x_mdio_read_le(dev->net, dev->mii.phy_id, MII_ADVERTISE);
>> +       res = mii_nway_result(lpa|adv);
> [...]
> 
> The argument to mii_nway_result() must be lpa & adv (the intersection of
> supported modes, not the union!).


Excellent.  Fixed.
