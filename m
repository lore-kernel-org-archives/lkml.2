Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab0E1HXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:23:23 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:52878 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab0E1HXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:23:18 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.589
Message-ID: <4BFF6F5C.2040603@tremplin-utc.net>
Date: Fri, 28 May 2010 09:23:08 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Airlie <airlied@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Ragwitz <rafl@debian.org>, Arjan Opmeer <arjan@opmeer.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.35-rc0
References: <20100520165243.GA20861@core.coreip.homeip.net> <alpine.LFD.2.00.1005271837050.11382@i5.linux-foundation.org> <AANLkTiklv48cDWNqKlFfh5RVtxxNH8shH_JjDypPgeHA@mail.gmail.com> <alpine.LFD.2.00.1005272108210.11382@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005272108210.11382@i5.linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 28-05-10 06:12, Linus Torvalds schreef:
> 
> 
> On Fri, 28 May 2010, Dave Airlie wrote:
>>
>> Was this in GNOME?
>>
>> Does System->Preferences->Mouse have a touchpad tab? do it have tapping off?
> 
> Bingo! Yup, that turns a totally useless piece-of-crap touchpad into a 
> perfectly cromulent one!
> 
> Too bad that the default behavior made it act so horribly bad. 
Hi,
Good to hear it was just a userspace problem. Actually on my Mini 10, to
get it with all the nice feature I have this in a script:

for DEVICE in "SynPS/2 Synaptics TouchPad" "ETPS/2 Elantech Touchpad"; do
if xinput --list "$DEVICE" > /dev/null 2>/dev/null ; then
xinput --set-prop "$DEVICE" "Synaptics Two-Finger Scrolling" 1 1
xinput --set-prop "$DEVICE" "Synaptics Tap Action" 0 0 0 0 1 2 3
xinput --set-prop "$DEVICE" "Synaptics Tap Move" 1000
xinput --set-prop "$DEVICE" "Synaptics Edge Scrolling" 1 1 0
xinput --set-prop "$DEVICE" "Synaptics Scrolling Distance" 100 100
xinput --set-prop "$DEVICE" "Synaptics Circular Scrolling" 1
xinput --set-prop "$DEVICE" "Synaptics Circular Scrolling Trigger" 3
fi
done


Currently, using the native mode, compared to the emulated imps/2, just
gives you the circular scrolling and the horizontal two-finger scrolling
(which is for me already enough to make it worth). However, once we
fully understand the protocol, and more precisely, on which device to
use one of the three sub-protocols, it should be able to also provide:
 * gesture with three fingers (soon)
 * palm detection thanks to touch width measurement (soon)
 * pitch-to-zoom (needs userspace update, so not so soon)

Cheers,
Eric
