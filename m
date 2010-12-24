Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab0LXN6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:58:16 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35321 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0LXN6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 08:58:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=YDXCdcTzdjU/Cfpy16CtJcFv2fB0awi3ukSDWv/ZJyL5foPCwkfE2Wn12WeFbTEhI6
         9P4+LJmKPhbZ7Yzq9cQZxNrKEMduMr8WA+DXUFBj41YdPoPrPiUxihmts0la/N00aCdx
         qFufGeNsM7HnndrSMU+7RXBmNtdaemKAKtJqc=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jochen Voss <voss@seehuhn.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: post-rc4 regression (bisected): blank screen on ASUS P5KPL-AM
Date: Fri, 24 Dec 2010 14:58:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
References: <20101220140615.GA3035@automatix>
In-Reply-To: <20101220140615.GA3035@automatix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012241458.07058.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar (or the same):
https://bugzilla.kernel.org/show_bug.cgi?id=25242

On poniedziałek, 20 grudnia 2010 o 15:06:16 Jochen Voss wrote:
> Hello,
> 
> My system, when booted with recent kernels, fails to show any output
> on the monitor.  The problem occurs very early during bootup (I never
> see anything after the messages from grub), the monitor indicates that
> there is no video signal at all and dmesg shows the following lines:
> 
> [    1.540465] usbhid: USB HID core driver
> [    2.490014] No connectors reported connected with modes
> [    2.490019] [drm] Cannot find any crtc or sizes - going 1024x768
> [    2.496064] Console: switching to colour frame buffer device 128x48
> [    2.497729] fb0: inteldrmfb frame buffer device
> 
> The machine seems fine otherwise: I can log in remotely and logging in
> from the console (by typing blindly without visual feedback) also
> works.
> 
> The problem is present in the current kernel as of this morning (I see
> it with commit 55ec86f848a5f872fd43f5d7206464a0af419110).  Bisection
> indicates that it is caused by the following commit.
> 
>     commit 541cc966915b6756e54c20eebe60ae957afdb537
>     Author: Chris Wilson <chris@chris-wilson.co.uk>
>     Date:   Mon Dec 6 11:24:07 2010 +0000
> 
> 	drm: Don't try and disable an encoder that was never enabled
> 
> 	Prevents code that assumes that the encoder is active when
> 	asked to be disabled from dying a horrible death.
> 
> 	Reported-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 	Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> 	Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> I verfied that the problem disappears when booting recent kernels
> (i.e. 55ec86f848a5f872fd43f5d7206464a0af419110) with the offending
> commit reverted.  The screen works again and the dmesg output now
> changes to
> 
> [    1.542515] usbhid: USB HID core driver
> [    1.547569] Console: switching to colour frame buffer device 210x65
> [    1.551558] fb0: inteldrmfb frame buffer device
> 
> Note that the one second wait which was present in the bad dmesg
> has now disappeared.
> 
> System information:
> 
>     ASUS P5KPL-AM mainboard (Intel G31 chipset)
>     Intel Core2 quad core CPU
>     Ubuntu 10.10
> 
> Appended files:
> 
>     dmesg.bad: dmesg for 55ec86f848a5f872fd43f5d7206464a0af419110
>     dmesg.good: dmesg for 55ec86... with
>         541cc966915b6756e54c20eebe60ae957afdb537 reverted
>     lspci: "lspci -v" output (on a good kernel)
> 
> I'd be happy to send further information or to try patches etc.
> 
> I hope this helps,
> Jochen

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
