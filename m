Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1HRW4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 18:56:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63958 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab1HRW4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 18:56:42 -0400
MIME-Version: 1.0
In-Reply-To: <1313699724.23920.18.camel@dcbw.foobar.com>
References: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com>
 <CA+XFjipM1Qup3bcJos_ikwzoaWoa3GdYqK0WBUqEHBNR6V6LfQ@mail.gmail.com>
 <CAG1a4rsyfPrrrf-mzt3HAM6YHHjaHTcd2rbtYiwqLkUCP=j8pQ@mail.gmail.com>
 <CA+XFjipsVukKYchfmDv48PAKsD2PUxT+7E8epRuKFynGwk=Bag@mail.gmail.com>
 <CAG1a4rvQTA7UgxLOxu_cC88grjHttyjPD_4kyDhb7Y9FcBBkLQ@mail.gmail.com>
 <1313695217.23920.4.camel@dcbw.foobar.com> <CAG1a4rvqdB8y9ARQ=FckArm3UVG7=LFqF25kqYUYL0Uw7QNV8g@mail.gmail.com>
 <1313699724.23920.18.camel@dcbw.foobar.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Thu, 18 Aug 2011 18:56:11 -0400
Message-ID: <CAG1a4ruH=ctPfAT0-axtckHds=SbjUWRV0Zb=ZTSM+QxV7PZ-w@mail.gmail.com>
Subject: Re: [PATCH] ath9k: make driver usable standalone
To: Dan Williams <dcbw@redhat.com>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
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

> Or, since I'm a NetworkManager developer, is there something that you're
> not sure how to make NM do, or are you just looking to experiment?

I want to make the wireless work when kernel is compiled without
WIRELESS_EXT. Last time I tried it Ubuntu (I guess I should say
NetworkManager) wasn't able to discover any wireless networks in our
area and wasn't able to connect to my default network. Was it supposed
to do that?


Pavel


On Thu, Aug 18, 2011 at 4:35 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Thu, 2011-08-18 at 15:30 -0400, Pavel Ivanov wrote:
>> > In the end, you probably want to be using wpa_supplicant instead of
>> > trying to configure stuff with iw directly.
>>
>> I see Ubuntu already have wpa_supplicant installed and running.
>> Although its command line is not what suggested in documentation and I
>> don't see configuration file /etc/wpa_supplicant.conf. Does that mean
>> it works somehow differently than stated in documentation? And also
>> does all this mean that even if I'll be able to make wpa_supplicant
>> work as I need I won't be able to control wireless connection using
>> the standard Ubuntu's icon and it won't show me its state correctly?
>
> NetworkManager is installed by default, and NM sends configuration to
> wpa_supplicant using a different control interface, not the config file.
> If you want to take the wifi interface out from NM's control, I think
> you can add the interface to /etc/network/interfaces and NM will then
> ignore it, and you can run wpa_supplicant manually with the '-i wlan0'
> option to point it to the right interface, and when you've got a config
> file, use '-c /path/to/config/file' to give it your configuration.
>
> Or, since I'm a NetworkManager developer, is there something that you're
> not sure how to make NM do, or are you just looking to experiment?
>
> Dan
>
>>
>> Pavel
>>
>>
>> On Thu, Aug 18, 2011 at 3:20 PM, Dan Williams <dcbw@redhat.com> wrote:
>> > On Thu, 2011-08-18 at 00:01 -0400, Pavel Ivanov wrote:
>> >> > Iwconfig and iwlist are themselves deprecated. Iw is the new wireless
>> >> > configuration tool.
>> >>
>> >> I've just tried to use iw and it didn't quite work for me. Maybe it's
>> >> interfering with something installed in Ubuntu by default but
>> >
>> > Ubuntu installs NetworkManager by default, so if you want to manually
>> > control the wifi card you'll have to tell NM to ignore the wifi device,
>> > or turn NM off temporarily.
>> >
>> >> connect/disconnect commands didn't seem to do anything. And why these
>> >> commands can be executed only as root?
>> >
>> > Because poking and configuring hardware is a privileged operation; tools
>> > like NetworkManager selectively poke holes through that wall and often
>> > require administrator passwords to do it, but at the end of the day its
>> > an operation that can affect security and stability, and that means it
>> > needs to be privileged.
>> >
>> > In the end, you probably want to be using wpa_supplicant instead of
>> > trying to configure stuff with iw directly.
>> >
>> > Dan
>> >
>> >> Well, maybe in Ubuntu 11.10 it will work better.
>> >>
>> >>
>> >> Pavel
>> >>
>> >>
>> >> 2011/8/17 Gábor Stefanik <netrolller.3d@gmail.com>:
>> >> > 2011/8/17 Pavel Ivanov <paivanof@gmail.com>:
>> >> >>> WIRELESS_EXT is not required for configuring wireless on recent
>> >> >>> kernels - in fact, the WEXT API is deprecated in favor of nl80211 now.
>> >> >>
>> >> >> Since what version it's deprecated? Do user-space tools know about this new API?
>> >> >>
>> >> >> Neither iwconfig nor iwlist worked for me without WIRELESS_EXT.
>> >> >>
>> >> >>
>> >> >> Pavel
>> >> >>
>> >> >
>> >> > Iwconfig and iwlist are themselves deprecated. Iw is the new wireless
>> >> > configuration tool.
>> >> >
>> >> >>
>> >> >> 2011/8/17 Gábor Stefanik <netrolller.3d@gmail.com>:
>> >> >>> On Wed, Aug 17, 2011 at 5:28 AM, Pavel Ivanov <paivanof@gmail.com> wrote:
>> >> >>>> When ath9k is the only wireless driver included in the build
>> >> >>>> WIRELESS_EXT configuration option becomes undefined. Because of that
>> >> >>>> driver becomes essentially unusable as you can't actually connect to
>> >> >>>> any WiFi network. By including WIRELESS_EXT into Kconfig we ensure
>> >> >>>> that build with ath9k and without other drivers (having WIRELESS_EXT
>> >> >>>> selected in their Kconfig) is actually usable.
>> >> >>>
>> >> >>> WIRELESS_EXT is not required for configuring wireless on recent
>> >> >>> kernels - in fact, the WEXT API is deprecated in favor of nl80211 now.
>> >> >>>
>> >> >>>>
>> >> >>>> Signed-off-by: Pavel Ivanov <paivanof@gmail.com>
>> >> >>>> ---
>> >> >>>>
>> >> >>>> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig
>> >> >>>> b/drivers/net/wireless/ath/ath9k/Kconfig
>> >> >>>> index d9c08c6..2573f77 100644
>> >> >>>> --- a/drivers/net/wireless/ath/ath9k/Kconfig
>> >> >>>> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
>> >> >>>> @@ -11,6 +11,7 @@ config ATH9K
>> >> >>>>        select LEDS_CLASS
>> >> >>>>        select NEW_LEDS
>> >> >>>>        select ATH9K_COMMON
>> >> >>>> +       select WIRELESS_EXT
>> >> >>>>        ---help---
>> >> >>>>          This module adds support for wireless adapters based on
>> >> >>>>          Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
