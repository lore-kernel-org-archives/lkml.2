Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1DVFFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 01:05:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47273 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1DVFFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 01:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=iYxCtW+rWdUdIyeptmHoHO7hHFZByjulyvNLf8+JNX8lOIq+966Tin4BUTBA2hRXhv
         f8uYb+7DSgWT5jDcQU/gQrb5qyLI71ZbqjnW2MkW3XHECmNZ/r1ZBoEVo+2dfZYCvy0O
         eZdw2ITToTTP7WfB0I3TTGgbNrYny9eFo1LoM=
Message-ID: <4DB10C79.4020606@gmail.com>
Date: Fri, 22 Apr 2011 02:04:57 -0300
From: Daniel Hilst Selli <danielhilst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110325 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: brctl + broadcom wireless card == bug ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the thing

I create a bridge with
brctl addbr br0

make it up
ifconfig br0 promisc up

Hi people I'm having trouble to setting an bridge configuration. Seams
that brctl crashes my wl module.

Here is what I do..
add my wireless eth to it
brctl addif eth1 br0

and then try to get an ip from router
dhcpcd br0

What's happen here? I get an timeout error

Then I search in my wpa_gui, try to reconnect and get 'Association 
request to the driver failed'
and can't connect. So I do `modprobe -r wl && modprobe wl` that seams to 
work (I can connect) but after such
the eth1 seams to auto-detach from br0. To make it short..

brctrl addif eth1 br0 => breaks my wl module
modprobe -r wl && modprobe wl => makes eth1 desapear from br0


Seems a deadlock for me :-(

Details:
- my card is a broadcom: 12:00.0 Network controller: Broadcom 
Corporation Device 4727 (rev 01)
- the module is the broadcom proprietary module
- I'm using gentoo 2.36: Linux gentoo 2.6.36-gentoo-r8 #2 SMP Thu Apr 21 
11:46:16 BRT 2011 x86_64 Intel(R) Core(TM) i3 CPU M 370 @ 2.40GHz 
GenuineIntel GNU/Linux

-- 
"Do or do not... there is no try" Yoda Master
