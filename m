Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab3AIL5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:57:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab3AIL5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:57:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/3] ARM: ux500: Turn on the 'heartbeat' LED trigger
Date: Wed, 9 Jan 2013 11:56:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
References: <1357725965-27342-1-git-send-email-lee.jones@linaro.org> <20130109110840.GD31678@gmail.com> <20130109111209.GH3931@n2100.arm.linux.org.uk>
In-Reply-To: <20130109111209.GH3931@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301091156.55644.arnd@arndb.de>
X-Provags-ID: V02:K0:KFMirDnDx/4DOPEY0t84vSX2Kni6B25GBAXiIHRYbi6
 MB8llfdWQySoHmEnfdTNqiXe1IOy6uPCZxfigUR7WxgPShtcCy
 waCLQ8d0ySMh9Ys58ZrVDVcGRS3F0wjHIgkdFJbh218KX6gGii
 C34EP1s99mEuYcJsIVijGajQY1FQX7Y4yC5A9U6JZmAEdLhU2a
 lA8cnYHfQ8uSGu+g52sHiaLI5VJy74iijjXOfd3dAXRvxxr8CU
 +54vQD1vVW0d2aZltxrnyjDlmb7/yUuAKzR+MNrnogmnuxSdRM
 Hl/HBotiRMtFAN9LtWk9nXJRgS96peItUpWF2BjDfsCbrtc2jP
 ygLo+HLYBV/A/r0MQHS0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Russell King - ARM Linux wrote:
> > If so, that's wrong, as it covers many more boards than just Snowball
> > and this is only applicable on the Snowball board. So how else can
> > I enable this feature?
> 
> And why is it wrong to enable an optional feature in a defconfig which some
> boards using that defconfig may want?
> 
> It's less wrong than forcing user selectable options to be mandatorily
> selected.

Right. The change I suggested fixes the build errors but doesn't actually
make the intended behavior correct. Just using a configuration file is the
right solution here.

It may be a good use case for the "suggest" Kconfig statement I brought
up before: Rather than having snowball hard enable the LEDS subsystem,
it could 'suggest LEDS_CORE' in order to change the default for that
option, but still let users disable it if they want to.

	Arnd
