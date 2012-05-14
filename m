Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab2ENUCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:02:14 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:34297 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757521Ab2ENUCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:02:13 -0400
Message-ID: <4FB164C1.2080409@fold.natur.cuni.cz>
Date: Mon, 14 May 2012 22:02:09 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Kamal Mostafa <kamal@canonical.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mario Limonciello <mario_limonciello@dell.com>
Subject: Re: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
References: <1337023652-11661-1-git-send-email-kamal@canonical.com>
In-Reply-To: <1337023652-11661-1-git-send-email-kamal@canonical.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamal Mostafa wrote:
> From: Mario Limonciello <mario_limonciello@dell.com>
> 
> On Dell XPS 13z (L321X) and 15z (L502X), switching off Bluetooth also
> disables wifi due to improper improper BIOS interaction with dell-laptop.
> Add those models to the rfkill blacklist.
> 
> BugLink: https://bugs.launchpad.net/bugs/901410

I was curious whether this also happens with Dell Vostro 3550 and seems not:

# rfkill list
0: dell-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: dell-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
2: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
# rfkill block 1
# rfkill list
0: dell-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: dell-bluetooth: Bluetooth
        Soft blocked: yes
        Hard blocked: no
2: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
# rfkill block 0
# rfkill list
0: dell-wifi: Wireless LAN
        Soft blocked: yes
        Hard blocked: no
1: dell-bluetooth: Bluetooth
        Soft blocked: yes
        Hard blocked: no
2: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
# iwconfig 
tun0      no wireless extensions.

eth0      no wireless extensions.

lo        no wireless extensions.

wlan0     IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          
#
# rfkill unblock 1
# rfkill unblock 0
# rfkill list
0: dell-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: dell-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
2: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
#


Now, after doing once Fn+F2 to disable the device(s):

# rfkill list
0: dell-wifi: Wireless LAN
        Soft blocked: yes
        Hard blocked: yes
1: dell-bluetooth: Bluetooth
        Soft blocked: yes
        Hard blocked: yes
2: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: yes
#

Another press of Fn+F2 enables both at once:

# rfkill list
0: dell-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: dell-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
2: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
4: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
#

BIOS A09 here, linux-3.4-rc7.


Just do not know why I still get those "Unknown key pressed" messages:

[ 2652.048353] atkbd serio0: Unknown key pressed (translated set 2, code 0x88 on isa0060/serio0).
[ 2652.048363] atkbd serio0: Use 'setkeycodes e008 <keycode>' to make it known.
[ 2652.103556] iwlwifi 0000:09:00.0: RF_KILL bit toggled to disable radio.
...cut...
[ 3249.854374] atkbd serio0: Unknown key pressed (translated set 2, code 0x88 on isa0060/serio0).
[ 3249.854385] atkbd serio0: Use 'setkeycodes e008 <keycode>' to make it known.
[ 3250.030173] iwlwifi 0000:09:00.0: RF_KILL bit toggled to enable radio.



Regards,
Martin
