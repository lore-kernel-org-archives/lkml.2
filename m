Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1CEXpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 18:45:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45724 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab1CEXpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 18:45:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bOfQ8jpJQ+Ztu8o7VWuINSRuC5tch4RlLtWLiF6LWZ+vOF10zsQKLHPBbuGoYlkm3y
         jAncUMu5nWak73iGQWLaDdrBlFoEnAOdJ12CYPOJBARF//c9Fxpogt1bf6qyNreZSA/l
         dHRdu+kL1+UZdj7K72cPYvYLkL9+4oSJlztLM=
MIME-Version: 1.0
In-Reply-To: <1299334144.3826.8.camel@jlt3.sipsolutions.net>
References: <AANLkTin0PGOfHr3AvQk-BAhyMY7ihYMU1-wX4RJG=1YT@mail.gmail.com>
	<20110304134648.GB9866@tuxdriver.com>
	<1299251879.24333.3.camel@wwguy-ubuntu>
	<AANLkTinfCc0e4BtBxoq7MHtgv54HJk-yU=gQj9Xm_=R9@mail.gmail.com>
	<AANLkTi=+jfk5+tWewwnx+SHj+FQAXd03sPC3mDW32GUK@mail.gmail.com>
	<AANLkTikUE-LLSBNH=cNmPZ+Wenff5RxKcfK0kJXp9Wk+@mail.gmail.com>
	<1299334144.3826.8.camel@jlt3.sipsolutions.net>
Date: Sat, 5 Mar 2011 23:45:45 +0000
Message-ID: <AANLkTikQHUq95e9=3tG5WrayaxUu+K1FdAftJ3y72BTn@mail.gmail.com>
Subject: Re: 2.6.38-rc7, iwlagn crash
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wwguy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 March 2011 14:09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2011-03-05 at 09:45 +0000, Mathias Burén wrote:
>
>> I compiled my own kernel (downloaded 2.6.37-rc8 source, applied the
>> apparmor patch required for Ubuntu, copied over the config, make
>> oldconfig, enabled iwlwifi debug in menuconfig then compiled it),
>> booted it and loaded iwlagn with debug=0x43fff. Then I attempted the
>> same thing (Ubuntu Adhoc, no wireless security, trying to connect with
>> the phone).
>>
>> The entire dmesg can be found here:
>> http://www.privatepaste.com/download/49e6ead6c7
>
> So the warning is gone now?
>
> johannes
>
>

I got it again, with the newly compiled kernel. However, I've been
trying for 20 minutes now and when I load iwlagn with the debug
parameter I can't seem to get the warning. I was monitoring dmesg with
"watch --interval=1 "dmesg|tail -n40"" but I never saw the warning. As
soon as I removed the module, and inserted it again without the debug
option I could reproduce the warning. Here are some dmesg logs:

no debug, crash 1: http://www.privatepaste.com/download/06539404a8
no debug, crash 2: http://www.privatepaste.com/download/a6be5f5c81
debug, attempting to connect (network found but no IP received):
http://www.privatepaste.com/download/0dcea94fb0
debug, attempting to connect (network found but no IP received) 2:
http://www.privatepaste.com/download/f3bcc0a8ab
debug, attempting to connect (network found but no IP received) 3:
http://www.privatepaste.com/download/5ad33c21cd

So for whatever reason when debug is enabled I don't get the warning.
I'll try one last time with and without debug now just to confirm...

Hm, I've been trying for ages to reproduce the crash (with or without
debug enabled), however the "UbuntuAdhoc" network appears very rarely
on the phone (and I get a notification every other second on the
laptop "UbuntuAdhoc disconnected"). The few times the network appears
on the phone I've tried to connect, then I get this:

Attempting to connect:

[ 2273.874563] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2273.874729] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 2275.716984] iwlagn 0000:03:00.0: Error sending
REPLY_TX_LINK_QUALITY_CMD: time out after 500ms.
[ 2275.725079] wlan0: Selected IBSS BSSID f6:98:ac:c4:66:25 based on
configured SSID
[ 2275.788313] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2275.789196] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2275.789324] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 2277.119589] wlan0: Selected IBSS BSSID f6:98:ac:c4:66:25 based on
configured SSID
[ 2277.170348] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2277.171164] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2277.171306] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 2278.488817] wlan0: Trigger new scan to find an IBSS to join
[ 2281.248817] wlan0: Selected IBSS BSSID f6:98:ac:c4:66:25 based on
configured SSID
[ 2281.250494] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2281.251432] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2282.751112] wlan0: Selected IBSS BSSID f6:98:ac:c4:66:25 based on
configured SSID
[ 2282.795959] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2282.796729] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2282.796896] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 2284.229258] wlan0: Selected IBSS BSSID f6:98:ac:c4:66:25 based on
configured SSID
[ 2284.263836] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2284.264583] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2284.264930] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 2285.666846] wlan0: Selected IBSS BSSID f6:98:ac:c4:66:25 based on
configured SSID
[ 2285.700889] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2285.701671] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2285.701813] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)

Obtaining IP address on phone:

[ 2423.981988] cfg80211: Found new beacon on frequency: 5785 MHz (Ch
157) on phy0
[ 2424.016521] cfg80211: Found new beacon on frequency: 5805 MHz (Ch
161) on phy0
[ 2426.182617] wlan0: Trigger new scan to find an IBSS to join
[ 2429.063958] wlan0: Creating new IBSS network, BSSID 12:e4:a7:81:4d:7c
[ 2429.074249] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2429.075213] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2429.531435] wlan0: no IPv6 routers present
[ 2430.418990] wlan0: Trigger new scan to find an IBSS to join
[ 2433.356034] wlan0: Selected IBSS BSSID 8a:e9:57:48:45:be based on
configured SSID
[ 2433.356515] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2433.357397] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2434.866178] wlan0: Selected IBSS BSSID 8a:e9:57:48:45:be based on
configured SSID
[ 2434.893583] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2434.894347] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2434.894484] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 2436.292923] wlan0: Selected IBSS BSSID 8a:e9:57:48:45:be based on
configured SSID
[ 2436.354619] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2436.355601] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2436.355770] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 2437.736175] wlan0: Selected IBSS BSSID 8a:e9:57:48:45:be based on
configured SSID
[ 2437.768543] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2437.769386] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2437.769559] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 2439.141544] wlan0: Selected IBSS BSSID 8a:e9:57:48:45:be based on
configured SSID
[ 2439.185032] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2439.185926] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2440.586132] wlan0: Selected IBSS BSSID 8a:e9:57:48:45:be based on
configured SSID
[ 2440.623583] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2440.624288] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2440.624393] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 2441.999051] wlan0: Selected IBSS BSSID 8a:e9:57:48:45:be based on
configured SSID
[ 2442.061302] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2442.062066] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[ 2442.062208] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)

Here's a dmesg with debug enabled when the phone found the network and
is trying to get an IP:
http://www.privatepaste.com/download/7b32b9608d

I finally produced another warning, this is when the phone was
scanning for networks, unfortunately again without debug enabled:
http://www.privatepaste.com/download/d41f26f916

I'm not sure this helps... I also uploaded the kernel config here:
http://www.privatepaste.com/58e1d350cb

Kind regards,
// Mathias
