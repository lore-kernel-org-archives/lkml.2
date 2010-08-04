Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab0HDMlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:41:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58747 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab0HDMlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:41:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=b2hkV9Ha8Ab/AlQFrfAU2SIehMw891kHwH8zy+KJPlKsg2+r9QVFq7TWn+So5eBHHH
         rlcPL2jZE/MN+f4RPZSEh1lFnNyjsmHeTBPtbi7AOctUsEO45dPCPi4OmxMZGXhgM/VV
         dLAiwmXv6eVPfryj7G2x0f37jgFWU8mLZ84D0=
MIME-Version: 1.0
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Date: Wed, 4 Aug 2010 14:40:54 +0200
Message-ID: <AANLkTimGsN_ZfLzs8Ock0i4+bvNFTupBLjJb265jj-MW@mail.gmail.com>
Subject: Trust 1400WT pac207 based webcam cannot perform usbsuspend 
	(auto/forced) to save power
To: "Kernel," <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i have a Trust 1400WT usb webcam, identified by:
Bus 007 Device 002: ID 093a:2468 Pixart Imaging, Inc. Cammaestro
2.5DU/X-EYE/Orite SC-120/ICGear TravelCam/Easy Snap Snake Eye Webcam

dmesg shows:

pac207: Pixart Sensor ID 0x27 Chips ID 0x08
pac207: Pixart PAC207BCA Image Processor and Control Chip detected
(vid/pid 0x093A:0x2468)
input: pac207 as /devices/pci0000:00/0000:00:1d.2/usb7/7-1/input/input3
gspca: video0 created
gspca: found int in endpoint: 0x83, buffer_len=2, interval=50

It's correctly working with Linux apps but powertop shows it's active
100% of time.
Infact, even if i have autosuspend enabled (2 secs delay) it doesn't
sleep and i cannot even force it in off mode, just on.

/sys/bus/usb/devices/usb7/7-1/power

cat autosuspend
2
root@blight power # cat con
connected_duration  control
root@blight power # cat control
on
root@blight power # echo off > con
connected_duration  control
root@blight power # echo off > control
bash: echo: write error: Invalid argument
root@blight power # echo auto > control
root@blight power # echo on > control
root@blight power # cat con
connected_duration  control
root@blight power # cat control
on
root@blight power # echo auto > control

Is this a driver or hw issue?

Ready to test patches or provide more infos.
Please CC me i'm not subscribed.

Regards,

--

Patrizio Bassi
www.patriziobassi.it
http://piazzadelpopolo.patriziobassi.it
