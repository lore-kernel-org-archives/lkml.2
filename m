Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab2IUTFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:05:32 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4998 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608Ab2IUTFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:05:30 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <505CBA6E.3030304@broadcom.com>
Date: Fri, 21 Sep 2012 21:05:18 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827
 Thunderbird/15.0
MIME-Version: 1.0
To: "Stephen Warren" <swarren@wwwdotorg.org>
cc: "Wei Ni" <wni@nvidia.com>, krakesh@nvidia.com, ldewangan@nvidia.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 5/5] ARM: tegra: enable brcmfmac in defconfig
References: <1348217700-12309-1-git-send-email-wni@nvidia.com>
 <1348217700-12309-6-git-send-email-wni@nvidia.com>
 <505C7C27.2050108@broadcom.com> <505C93A1.2040801@wwwdotorg.org>
In-Reply-To: <505C93A1.2040801@wwwdotorg.org>
X-WSS-ID: 7C4266733PS1554509-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 06:19 PM, Stephen Warren wrote:
> On 09/21/2012 08:39 AM, Arend van Spriel wrote:
>> On 09/21/2012 10:55 AM, Wei Ni wrote:
>>> New options enabled:
>>> * CFG80211_WEXT: (dependency)
>>> * BRCMFMAC: wlan driver, enable as module.
>>>
>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>> ---
>>>    arch/arm/configs/tegra_defconfig |    2 ++
>>>    1 files changed, 2 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/arm/configs/tegra_defconfig
>>> b/arch/arm/configs/tegra_defconfig
>>> index adcf3c2..04b18ea 100644
>>> --- a/arch/arm/configs/tegra_defconfig
>>> +++ b/arch/arm/configs/tegra_defconfig
>>> @@ -73,6 +73,7 @@ CONFIG_BT_BNEP=y
>>>    CONFIG_BT_HIDP=y
>>>    CONFIG_BT_HCIBTUSB=m
>>>    CONFIG_CFG80211=y
>>> +CONFIG_CFG80211_WEXT=y
>>
>> Any particular reason for enabling this? The driver does not
>> specifically need it. The option only allows use of WEXT dependent
>> user-space tools like iwconfig and iwlist. At least it is not needed by
>> brcmfmac driver hence it does not select it.
>>
>> You indicate there is a dependency. Could you elaborate?
>
> "Dependency" probably isn't correct.
>
> However, the intent of tegra_defconfig is to provide a useful
> configuration for Tegra boards. Without the ability to use
> iwconfig/iwlist, enabling the wireless driver doesn't seem useful; how
> would someone configure the wireless connection?

Let me explain. CFG80211 provides a netlink api called NL80211 which is 
favorable over WEXT api. In user-space the iw tool is replacing iwconfig 
and iwlist. Also wpa_supplicant has support for both wext and nl80211.

CFG80211_WEXT basically provides an adaptation/compatibility layer that 
allows user-space tools to interact with cfg80211 drivers. However, it 
is intended to be phased out so I would not recommend putting it in a 
defconfig.

Gr. AvS


