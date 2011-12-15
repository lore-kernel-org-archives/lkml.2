Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab1LOMlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 07:41:47 -0500
Received: from diyaorg.dp.ua ([82.207.88.73]:52332 "EHLO diyaorg.dp.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758745Ab1LOMlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 07:41:46 -0500
Message-ID: <4EE9EB08.7060701@oscada.org>
Date: Thu, 15 Dec 2011 14:41:44 +0200
From: Roman Savochenko <rom_as@oscada.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.1) Gecko/20110907 Thunderbird/6.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Regression-broken V4L2 radio API for BTTV cards (PV951)
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=KOI8-U
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, All

Start from kernel 2.6.39 my TV card's PV951 radio is not work.
On 2.6.38 it still fine work and form 2.6.39 to present it is not.
I have seen to source's different for BTTV code from 2.6.38 to 2.6.39
and have not seen any functional changes then the problem is generic for
radio API.

For test I call command "v4l2-ctl -d /dev/radio --all -L" on 2.6.32 and
3.1.4 kernel's versions:

***************** 2.6.32 (OK) *************************
[root@roman ~]# v4l2-ctl -d /dev/radio --all -L
Driver Info (not using libv4l2):
        Driver name   : bttv
        Card type     : BT878 radio (ProVideo PV951)
        Bus info      : PCI:0000:01:09.0
        Driver version: 0.9.18
        Capabilities  : 0x00010000
                Tuner
Video input : 0 (Radio: ok)
Audio input : 0 (Radio)
Frequency: 1040500 (65.031250 MHz)
Tuner:
        Name                 : Radio
        Capabilities         : 62.5 Hz stereo
        Frequency range      : 65.0 MHz - 108.0 MHz
        Signal strength/AFC  : 13%/0
        Current audio mode   : stereo
        Available subchannels: mono
                           mute (bool) : default=0 value=0



***************** 3.1.4 (Wrong) *************************
[root@roman ~]# v4l2-ctl -d /dev/radio --all -L
Driver Info (not using libv4l2):
        Driver name   : bttv
        Card type     : BT878 radio (ProVideo PV951)
        Bus info      : PCI:0000:01:09.0
        Driver version: 3.1.4
        Capabilities  : 0x00010000
                Tuner
Video input : 0 (Radio: ok)
Audio input : 0 (Radio)
Frequency: 0 (0.000000 MHz)
Tuner:
        Name                 : Radio
        Capabilities         : 62.5 kHz
        Frequency range      : 0.0 MHz - 0.0 MHz
        Signal strength/AFC  : 0%/0
        Current audio mode   : mono
        Available subchannels:
                           mute (bool) : default=0 value=0


Regards, Roman
