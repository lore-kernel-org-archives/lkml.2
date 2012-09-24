Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab2IXRsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:48:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48254 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab2IXRsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:48:31 -0400
Message-ID: <50609CEC.1050001@wwwdotorg.org>
Date: Mon, 24 Sep 2012 11:48:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Wei Ni <wni@nvidia.com>, krakesh@nvidia.com, ldewangan@nvidia.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 5/5] ARM: tegra: enable brcmfmac in defconfig
References: <1348217700-12309-1-git-send-email-wni@nvidia.com> <1348217700-12309-6-git-send-email-wni@nvidia.com> <505C7C27.2050108@broadcom.com> <505C93A1.2040801@wwwdotorg.org> <505CBA6E.3030304@broadcom.com>
In-Reply-To: <505CBA6E.3030304@broadcom.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 01:05 PM, Arend van Spriel wrote:
> On 09/21/2012 06:19 PM, Stephen Warren wrote:
>> On 09/21/2012 08:39 AM, Arend van Spriel wrote:
>>> On 09/21/2012 10:55 AM, Wei Ni wrote:
>>>> New options enabled:
>>>> * CFG80211_WEXT: (dependency)
>>>> * BRCMFMAC: wlan driver, enable as module.
>>>>
>>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>>> ---
>>>>    arch/arm/configs/tegra_defconfig |    2 ++
>>>>    1 files changed, 2 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/arch/arm/configs/tegra_defconfig
>>>> b/arch/arm/configs/tegra_defconfig
>>>> index adcf3c2..04b18ea 100644
>>>> --- a/arch/arm/configs/tegra_defconfig
>>>> +++ b/arch/arm/configs/tegra_defconfig
>>>> @@ -73,6 +73,7 @@ CONFIG_BT_BNEP=y
>>>>    CONFIG_BT_HIDP=y
>>>>    CONFIG_BT_HCIBTUSB=m
>>>>    CONFIG_CFG80211=y
>>>> +CONFIG_CFG80211_WEXT=y
>>>
>>> Any particular reason for enabling this? The driver does not
>>> specifically need it. The option only allows use of WEXT dependent
>>> user-space tools like iwconfig and iwlist. At least it is not needed by
>>> brcmfmac driver hence it does not select it.
>>>
>>> You indicate there is a dependency. Could you elaborate?
>>
>> "Dependency" probably isn't correct.
>>
>> However, the intent of tegra_defconfig is to provide a useful
>> configuration for Tegra boards. Without the ability to use
>> iwconfig/iwlist, enabling the wireless driver doesn't seem useful; how
>> would someone configure the wireless connection?
> 
> Let me explain. CFG80211 provides a netlink api called NL80211 which is
> favorable over WEXT api. In user-space the iw tool is replacing iwconfig
> and iwlist. Also wpa_supplicant has support for both wext and nl80211.
> 
> CFG80211_WEXT basically provides an adaptation/compatibility layer that
> allows user-space tools to interact with cfg80211 drivers. However, it
> is intended to be phased out so I would not recommend putting it in a
> defconfig.

OK, I suppose that I'd expect to use a given kernel's defconfig with a
fairly recent distro, so switching to "iw" is reasonable, and so
removing that defconfig entry is reasonable. I'll just remove that line
when applying these patches unless there's any other need for a re-spin.

