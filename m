Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab1CCFBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 00:01:30 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:51770 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab1CCFB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 00:01:29 -0500
Message-ID: <4D6F205F.5080209@st.com>
Date: Thu, 3 Mar 2011 10:30:15 +0530
From: pratyush <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        Viresh KUMAR <viresh.kumar@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>
Subject: Re: [PATCH V5 Resend] ST SPEAr: PCIE gadget suppport
References: <1298276455-23989-1-git-send-email-pratyush.anand@st.com> <20110223160632.0b21c550.akpm@linux-foundation.org>
In-Reply-To: <20110223160632.0b21c550.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/2011 5:36 AM, Andrew Morton wrote:
> On Mon, 21 Feb 2011 13:50:55 +0530
> Pratyush Anand <pratyush.anand@st.com> wrote:
> 
>> This is a configurable gadget. can be configured by configfs interface. Any
>> IP available at PCIE bus can be programmed to be used by host
>> controller.It supoorts both INTX and MSI.
>> By default, gadget is configured for INTX and SYSRAM1 is mapped to BAR0
>> with size 0x1000
>>
>> Changes since V4:
>> - All documentation related comments incorporated
>>
>> Changes since V3:
>> - support for multiple instances of such device
> 
> ^^ This doesn't seem to agree with the documentation.
> 

Will add a line in documentation for it.

>> ...
>>
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/configfs-spear-pcie-gadget
>> @@ -0,0 +1,30 @@
>> +What:		/config/pcie-gadget
>> +Date:		Feb 2011
>> +KernelVersion:	2.6.37
>> +Contact:	Pratyush Anand <pratyush.anand@st.com>
>> +Description:
>> +
>> +	Interface is used to configure selected dual mode PCIe controller
>> +	as device and then program its various registers to configure it
>> +	as a particular device type.
>> +	This interfaces can be used to show spear's PCIe device capability.
>> +
>> +	Nodes are only visible when configfs is mounted. To mount configfs
>> +	in /config directory use:
>> +	# mount -t configfs none /config/
>> +
>> +	/config/pcie-gadget/
>> +		link ... used to enable ltssm and read its status.
>> +		int_type ...used to configure and read type of supported
>> +			interrupt
>> +		no_of_msi ... used to configure number of MSI vector needed and
>> +			to read no of MSI granted.
>> +		inta ... write 1 to assert INTA and 0 to de-assert.
>> +		send_msi ... write MSI vector to be sent.
>> +		vendor_id ... used to write and read vendor id (hex)
>> +		device_id ... used to write and read device id (hex)
>> +		bar0_size ... used to write and read bar0_size
>> +		bar0_address ... used to write and read bar0 mapped area in hex.
>> +		bar0_rw_offset ... used to write and read offset of bar0 where
>> +			bar0_data will be written or read.
>> +		bar0_data ... used to write and read data at bar0_rw_offset.
> 
> What's the configfs naming scheme for the second and later devices?
> 

there would be pcie-gadget.n directory under /config for
nth PCIe Device Controller.

Regards
Pratyush

> 
> .
> 

