Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab1HRECL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 00:02:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43752 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab1HRECG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 00:02:06 -0400
MIME-Version: 1.0
In-Reply-To: <CA+XFjipsVukKYchfmDv48PAKsD2PUxT+7E8epRuKFynGwk=Bag@mail.gmail.com>
References: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com>
 <CA+XFjipM1Qup3bcJos_ikwzoaWoa3GdYqK0WBUqEHBNR6V6LfQ@mail.gmail.com>
 <CAG1a4rsyfPrrrf-mzt3HAM6YHHjaHTcd2rbtYiwqLkUCP=j8pQ@mail.gmail.com> <CA+XFjipsVukKYchfmDv48PAKsD2PUxT+7E8epRuKFynGwk=Bag@mail.gmail.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Thu, 18 Aug 2011 00:01:34 -0400
Message-ID: <CAG1a4rvQTA7UgxLOxu_cC88grjHttyjPD_4kyDhb7Y9FcBBkLQ@mail.gmail.com>
Subject: Re: [PATCH] ath9k: make driver usable standalone
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Iwconfig and iwlist are themselves deprecated. Iw is the new wireless
> configuration tool.

I've just tried to use iw and it didn't quite work for me. Maybe it's
interfering with something installed in Ubuntu by default but
connect/disconnect commands didn't seem to do anything. And why these
commands can be executed only as root?
Well, maybe in Ubuntu 11.10 it will work better.


Pavel


2011/8/17 Gábor Stefanik <netrolller.3d@gmail.com>:
> 2011/8/17 Pavel Ivanov <paivanof@gmail.com>:
>>> WIRELESS_EXT is not required for configuring wireless on recent
>>> kernels - in fact, the WEXT API is deprecated in favor of nl80211 now.
>>
>> Since what version it's deprecated? Do user-space tools know about this new API?
>>
>> Neither iwconfig nor iwlist worked for me without WIRELESS_EXT.
>>
>>
>> Pavel
>>
>
> Iwconfig and iwlist are themselves deprecated. Iw is the new wireless
> configuration tool.
>
>>
>> 2011/8/17 Gábor Stefanik <netrolller.3d@gmail.com>:
>>> On Wed, Aug 17, 2011 at 5:28 AM, Pavel Ivanov <paivanof@gmail.com> wrote:
>>>> When ath9k is the only wireless driver included in the build
>>>> WIRELESS_EXT configuration option becomes undefined. Because of that
>>>> driver becomes essentially unusable as you can't actually connect to
>>>> any WiFi network. By including WIRELESS_EXT into Kconfig we ensure
>>>> that build with ath9k and without other drivers (having WIRELESS_EXT
>>>> selected in their Kconfig) is actually usable.
>>>
>>> WIRELESS_EXT is not required for configuring wireless on recent
>>> kernels - in fact, the WEXT API is deprecated in favor of nl80211 now.
>>>
>>>>
>>>> Signed-off-by: Pavel Ivanov <paivanof@gmail.com>
>>>> ---
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig
>>>> b/drivers/net/wireless/ath/ath9k/Kconfig
>>>> index d9c08c6..2573f77 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/Kconfig
>>>> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
>>>> @@ -11,6 +11,7 @@ config ATH9K
>>>>        select LEDS_CLASS
>>>>        select NEW_LEDS
>>>>        select ATH9K_COMMON
>>>> +       select WIRELESS_EXT
>>>>        ---help---
>>>>          This module adds support for wireless adapters based on
>>>>          Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
