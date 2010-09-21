Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab0IUSQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:16:32 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1382 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102Ab0IUSQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:16:30 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4C98F66C.809@broadcom.com>
Date: Tue, 21 Sep 2010 11:16:12 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: "Greg KH" <greg@kroah.com>
cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "Brett Rudley" <brudley@broadcom.com>,
        "Nohee Ko" <noheek@broadcom.com>,
        "Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH -next] staging: brcm80211 depends on MAC80211
References: <20100921170055.4512dd19.sfr@canb.auug.org.au>
 <20100921093549.a39a2a8d.randy.dunlap@oracle.com>
 <4C98EA0B.6050903@broadcom.com> <20100921180614.GA24227@kroah.com>
In-Reply-To: <20100921180614.GA24227@kroah.com>
X-WSS-ID: 608629F83KC113372582-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 11:06 AM, Greg KH wrote:
> On Tue, Sep 21, 2010 at 10:23:23AM -0700, Henry Ptasinski wrote:
>> On 09/21/2010 09:35 AM, Randy Dunlap wrote:
>>> From: Randy Dunlap<randy.dunlap@oracle.com>
>>>
>>> Fix brcm890211 build: it should depend on MAC80211.
>>> MAC80211 depends on CFG80211, which takes care of<regulatory_hint>
>>> below.
>>>
>>> ERROR: "ieee80211_rx_irqsafe" [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>> ERROR: "ieee80211_unregister_hw" [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>> ERROR: "ieee80211_stop_queues" [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>> ERROR: "ieee80211_wake_queues" [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>> ERROR: "ieee80211_stop_tx_ba_cb_irqsafe" [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>> ERROR: "ieee80211_tx_status_irqsafe" [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>> ERROR: "ieee80211_register_hw" [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>> ERROR: "regulatory_hint" [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>> ERROR: "ieee80211_alloc_hw" [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>> ERROR: "ieee80211_free_hw" [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>> ERROR: "ieee80211_start_tx_ba_cb_irqsafe" [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>>
>>> Signed-off-by: Randy Dunlap<randy.dunlap@oracle.com>
>>> Cc: Brett Rudley<brudley@broadcom.com>
>>> Cc: Henry Ptasinski<henryp@broadcom.com>
>>> Cc: Nohee Ko<noheek@broadcom.com>
>>> ---
>>>   drivers/staging/brcm80211/Kconfig |    2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- linux-next-20100921.orig/drivers/staging/brcm80211/Kconfig
>>> +++ linux-next-20100921/drivers/staging/brcm80211/Kconfig
>>> @@ -1,6 +1,6 @@
>>>   menuconfig BRCM80211
>>>   	tristate "Broadcom 802.11 WLAN driver for bcm43xx chips"
>>> -	depends on PCI&&   WLAN
>>> +	depends on PCI&&   WLAN&&   MAC80211
>>>   	select WIRELESS_EXT
>>>   	select WEXT_PRIV
>>>   	default N
>>>
>>
>> Actually, I think that should be something like:
>>
>> diff --git a/drivers/staging/brcm80211/Kconfig
>> b/drivers/staging/brcm80211/Kconf
>> index 6b74685..228ec37 100644
>> --- a/drivers/staging/brcm80211/Kconfig
>> +++ b/drivers/staging/brcm80211/Kconfig
>> @@ -1,6 +1,6 @@
>>   menuconfig BRCM80211
>>          tristate "Broadcom 802.11 WLAN driver for bcm43xx chips"
>> -       depends on PCI&&  WLAN
>> +       depends on WLAN
>>          select WIRELESS_EXT
>>          select WEXT_PRIV
>>          default N
>> @@ -9,6 +9,6 @@ menuconfig BRCM80211
>>
>>   config BRCM80211_PCI
>>          bool "Broadcom 802.11 WLAN NIC driver"
>> -       depends on BRCM80211
>> +       depends on BRCM80211&&  PCI&&  MAC80211
>>          default y
>>
>>
>> Our fullmac sdio driver is going to use the brcm80211 framework, and
>> it'll only need CFG80211.
>
> Care to send this in a patch-format that I can apply it (i.e. proper
> changelog entry, reported-by:, signed-off-by:, etc.)?

Yes, as soon as I figure out the full fix.  There's a build error if 
BRCM80211 is set and BRCM80211_PCI is not set (somebody pointed this out 
a couple days ago) that I'd like to resolve also.

- Henry


