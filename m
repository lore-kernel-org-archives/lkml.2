Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab0IUR1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:27:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28205 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081Ab0IUR1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:27:22 -0400
Message-ID: <4C98EA8C.9070805@oracle.com>
Date: Tue, 21 Sep 2010 10:25:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Henry Ptasinski <henryp@broadcom.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "gregkh@suse.de" <gregkh@suse.de>,
        Brett Rudley <brudley@broadcom.com>, Nohee Ko <noheek@broadcom.com>
Subject: Re: [PATCH -next] staging: brcm80211 depends on MAC80211
References: <20100921170055.4512dd19.sfr@canb.auug.org.au> <20100921093549.a39a2a8d.randy.dunlap@oracle.com> <4C98EA0B.6050903@broadcom.com>
In-Reply-To: <4C98EA0B.6050903@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/10 10:23, Henry Ptasinski wrote:
> On 09/21/2010 09:35 AM, Randy Dunlap wrote:
>> From: Randy Dunlap<randy.dunlap@oracle.com>
>>
>> Fix brcm890211 build: it should depend on MAC80211.
>> MAC80211 depends on CFG80211, which takes care of<regulatory_hint>
>> below.
>>
>> ERROR: "ieee80211_rx_irqsafe" [drivers/staging/brcm80211/brcm80211.ko]
>> undefined!
>> ERROR: "ieee80211_unregister_hw"
>> [drivers/staging/brcm80211/brcm80211.ko] undefined!
>> ERROR: "ieee80211_stop_queues"
>> [drivers/staging/brcm80211/brcm80211.ko] undefined!
>> ERROR: "ieee80211_wake_queues"
>> [drivers/staging/brcm80211/brcm80211.ko] undefined!
>> ERROR: "ieee80211_stop_tx_ba_cb_irqsafe"
>> [drivers/staging/brcm80211/brcm80211.ko] undefined!
>> ERROR: "ieee80211_tx_status_irqsafe"
>> [drivers/staging/brcm80211/brcm80211.ko] undefined!
>> ERROR: "ieee80211_register_hw"
>> [drivers/staging/brcm80211/brcm80211.ko] undefined!
>> ERROR: "regulatory_hint" [drivers/staging/brcm80211/brcm80211.ko]
>> undefined!
>> ERROR: "ieee80211_alloc_hw" [drivers/staging/brcm80211/brcm80211.ko]
>> undefined!
>> ERROR: "ieee80211_free_hw" [drivers/staging/brcm80211/brcm80211.ko]
>> undefined!
>> ERROR: "ieee80211_start_tx_ba_cb_irqsafe"
>> [drivers/staging/brcm80211/brcm80211.ko] undefined!
>>
>> Signed-off-by: Randy Dunlap<randy.dunlap@oracle.com>
>> Cc: Brett Rudley<brudley@broadcom.com>
>> Cc: Henry Ptasinski<henryp@broadcom.com>
>> Cc: Nohee Ko<noheek@broadcom.com>
>> ---
>>   drivers/staging/brcm80211/Kconfig |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-next-20100921.orig/drivers/staging/brcm80211/Kconfig
>> +++ linux-next-20100921/drivers/staging/brcm80211/Kconfig
>> @@ -1,6 +1,6 @@
>>   menuconfig BRCM80211
>>       tristate "Broadcom 802.11 WLAN driver for bcm43xx chips"
>> -    depends on PCI&&  WLAN
>> +    depends on PCI&&  WLAN&&  MAC80211
>>       select WIRELESS_EXT
>>       select WEXT_PRIV
>>       default N
>>
> 
> Actually, I think that should be something like:
> 
> diff --git a/drivers/staging/brcm80211/Kconfig
> b/drivers/staging/brcm80211/Kconf
> index 6b74685..228ec37 100644
> --- a/drivers/staging/brcm80211/Kconfig
> +++ b/drivers/staging/brcm80211/Kconfig
> @@ -1,6 +1,6 @@
>  menuconfig BRCM80211
>         tristate "Broadcom 802.11 WLAN driver for bcm43xx chips"
> -       depends on PCI && WLAN
> +       depends on WLAN
>         select WIRELESS_EXT
>         select WEXT_PRIV
>         default N
> @@ -9,6 +9,6 @@ menuconfig BRCM80211
> 
>  config BRCM80211_PCI
>         bool "Broadcom 802.11 WLAN NIC driver"
> -       depends on BRCM80211
> +       depends on BRCM80211 && PCI && MAC80211
>         default y
> 
> 
> Our fullmac sdio driver is going to use the brcm80211 framework, and
> it'll only need CFG80211.

OK, makes sense.  Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
