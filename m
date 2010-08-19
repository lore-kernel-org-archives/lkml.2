Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab0HSDVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 23:21:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47638 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0HSDVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 23:21:13 -0400
Message-ID: <4C6CA31D.6030407@canonical.com>
Date: Thu, 19 Aug 2010 11:21:01 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        David Woodhouse <dwmw2@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control rf/camera
 power
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com> <1282127719.2747.211.camel@localhost> <20100818155128.GA24363@darkside.kls.lan>
In-Reply-To: <20100818155128.GA24363@darkside.kls.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 11:51 PM, Mario 'BitKoenig' Holbe wrote:
> On Wed, Aug 18, 2010 at 11:35:19AM +0100, David Woodhouse wrote:
>> On Wed, 2010-08-18 at 09:36 +0100, Ike Panhc wrote:
>>> This driver is tested and work fine on Lenovo ideapad B550 and ideapad S10-3.
>> Works for me too (on S10-3); thanks.
> 
> It works for me too on S12 w/ VIA Nano - at least somehow... I have two
> issues with it:
> 
> 1st: the camera is not detected:
> 
> $ dmesg | grep -i cam
> [    3.062601] usb 1-4: Product: Lenovo EasyCamera
> [    7.828202] uvcvideo: Found UVC 1.00 device Lenovo EasyCamera (5986:0241)
> [    7.842987] input: Lenovo EasyCamera as /devices/pci0000:00/0000:00:10.4/usb1/1-4/1-4:1.0/input/input6
> $ lsusb | grep -i cam
> Bus 001 Device 002: ID 5986:0241 Acer, Inc BisonCam, NB Pro
> $ rfkill list
> 0: ideapad_wlan: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 1: ideapad_bluetooth: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 2: ideapad_killsw: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 3: hci0: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 4: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 
> Fn-Esc switches the Camera off and on, but there seems to be no soft
> killswitch for it. I have no idea how to parse through acpidump to find
> out whether there is some similar device listed or not.
rfkill for RF devices only. This driver will create an entry on sysfs to
control the camera power

You can find the entry by "find /sys/devices -name 'camera_power'"

> 
> 
> 2nd: both Bluetooth killswitches reproducibly disappear when I block
> ideapad_bluetooth either via Gnome bluetooth-applet or via rfkill block
> 1 and subsequently reboot. After the reboot rfkill list shows:
> 
> 0: ideapad_wlan: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 1: ideapad_killsw: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 2: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 
> Powering the machine off and on again restores both killswitches.
> Interesting is: this does not happen when I boot into single-user mode,
> rfkill block 1 there and reboot. In this case, both killswitches are
> back.
This is interesting. looks like the cfgbit will change on S12 if BIOS
remember it has to shutdown when booting. I will try if the same problem
happen on my ideapads.

> 
> 
> regards
>    Mario

