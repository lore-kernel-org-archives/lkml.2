Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1F1UjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 16:39:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32960 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1F1Uiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 16:38:54 -0400
ORGANIZATION: Oracle Linux Engineering
USER-AGENT: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5)
 Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
Message-ID: <4E0A3BC8.6000504@oracle.com>
Date: Tue, 28 Jun 2011 13:38:32 -0700 (PDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: driverdevel <devel@driverdev.osuosl.org>, gregkh@suse.de,
        linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>, Joe Perches <joe@perches.com>,
        Naveen Singh <nsingh@atheros.com>
Subject: Re: staging: fix ath6kl build when CFG80211 is not enabled
References: <20110527130321.18a51d63.randy.dunlap@oracle.com>
 <20110628200656.GA7992@kroah.com>
In-Reply-To: <20110628200656.GA7992@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4E0A3BD6.0006:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/11 13:06, Greg KH wrote:
> On Fri, May 27, 2011 at 01:03:21PM -0700, Randy Dunlap wrote:
>>
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix build errors when CONFIG_CFG80211 is not enabled:
>>
>> drivers/built-in.o: In function `ar6k_cfg80211_deinit':
>> (.text+0x189b71): undefined reference to `cfg80211_scan_done'
>> drivers/built-in.o: In function `ar6k_cfg80211_deinit':
>> (.text+0x189b86): undefined reference to `wiphy_unregister'
>> drivers/built-in.o: In function `ar6k_cfg80211_deinit':
>> (.text+0x189b8d): undefined reference to `wiphy_free'
>> drivers/built-in.o: In function `ar6k_cfg80211_init':
>> (.text+0x18add7): undefined reference to `wiphy_new'
>> drivers/built-in.o: In function `ar6k_cfg80211_init':
>> (.text+0x18ae48): undefined reference to `wiphy_register'
>> drivers/built-in.o: In function `ar6k_cfg80211_tkip_micerr_event':
>> (.text+0x18ae95): undefined reference to `cfg80211_michael_mic_failure'
>> drivers/built-in.o: In function `ar6k_cfg80211_scan_node':
>> (.text+0x18afb5): undefined reference to `__ieee80211_get_channel'
>> drivers/built-in.o: In function `ar6k_cfg80211_scan_node':
>> (.text+0x18afd2): undefined reference to `cfg80211_inform_bss_frame'
>> drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
>> (.text+0x18b046): undefined reference to `cfg80211_ibss_joined'
>> drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
>> (.text+0x18b176): undefined reference to `cfg80211_connect_result'
>> drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
>> (.text+0x18b190): undefined reference to `cfg80211_disconnected'
>> drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
>> (.text+0x18b291): undefined reference to `cfg80211_get_bss'
>> drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
>> (.text+0x18b457): undefined reference to `cfg80211_put_bss'
>> drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
>> (.text+0x18b4fa): undefined reference to `cfg80211_roamed'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: Luis R. Rodriguez <mcgrof@gmail.com>
>> Cc: Joe Perches <joe@perches.com>
>> Cc: Naveen Singh <nsingh@atheros.com>
>> ---
>>  drivers/staging/ath6kl/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- linux-next-20110517.orig/drivers/staging/ath6kl/Kconfig
>> +++ linux-next-20110517/drivers/staging/ath6kl/Kconfig
>> @@ -1,6 +1,7 @@
>>  config ATH6K_LEGACY
>>  	tristate "Atheros AR6003 support (non mac80211)"
>>          depends on MMC && WLAN
>> +	depends on CFG80211
> 
> Is this still needed in the next linux-next release?

It's already there, isn't it?

config ATH6K_LEGACY
	tristate "Atheros AR6003 support (non mac80211)"
        depends on MMC && WLAN
	depends on CFG80211
        select WIRELESS_EXT
        select WEXT_PRIV


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
