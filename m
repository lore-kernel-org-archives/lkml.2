Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1FNPOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:14:31 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57848 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1FNPO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:14:29 -0400
Message-ID: <4DF77A2D.5010802@netstyle.com.ua>
Date: Tue, 14 Jun 2011 18:11:41 +0300
From: Yaroslav Fedevych <jafd@netstyle.com.ua>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0a1) Gecko/20110610 Thunderbird/7.0a1
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@linux.ie>
Subject: Re: drm-radeon failures on R600: patches still don't work
References: <BANLkTikzmp0BLefUPiiHZpK+48MYPeRE3A@mail.gmail.com> <20110612112124.GB1712@x4.trippels.de>
In-Reply-To: <20110612112124.GB1712@x4.trippels.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/11 14:21, Markus Trippelsdorf wrote:
> Hmm, maybe you're seeing a different problem. The issue that I saw was
> fixed by commit 428c6e3630 in the git tree (this is identical to the
> patch by Dave you're referring to above).
>
> Does a "git-revert fe6f0bd03d697835e76dd18d232ba476c65b8282" solve your
> problem?

As for spewing the log with "invalid textures", yes. I bisected it twice 
to exclude any pilot error.

As for other things... it's rather getting strange. Instead of garbled 
screen when starting X which was there before revert, and having ability 
to switch to a text VT to see the kernel message, the machine just... 
hangs. The cursor first freezes, then after a few seconds disappears, 
and that's it. After 30 seconds more, HDD stops spinning.

I thought there might be a kernel panic or something, but even if it is, 
the kernel cannot say anything. I fired up netconsole and tried to go 
with that, but to no avail. There was no message which could be a clear 
precursor to disaster.

I thought then that the kernel might manage to print at least something 
on the console. So as soon as I have seen the switch to graphics and the 
mouse cursor, I switched the VT immediately. After a while, the screen 
went black and that was it. It wasn't a particular service.

Even more curious thing is that even using Catalyst doesn't help: it 
invariably comes to this end. I have a pure text console boot, then it 
starts GDM, then there's a black screen with busy cursor spinning, I 
switch to the text console, after a few seconds I lose control over it, 
that is - the boot process freezes and the keyboard stops accepting 
input, then the switch to a black screen and that's it.

And the only reliable pre-requisite for this to happen is to launch X. 
In single-user, without X running, it would work for days, KMS or not.

I'm really not sure how to debug this. This behaviour started as soon as 
3.0.0-rc2 and is there as of today's git (3.0.0-rc3).

Also, I'm not sure that DRI is to blame, because the hangs occur on both 
open source and proprietary drivers.

As I have told before, netconsole does not show anything suspicious.

I cannot tell if SysRq would work because my laptop hasn't got a SysRq key.

I wonder if Gallium Mesa libs could, in a way, do these things. By the 
way, they work fine on 2.6.39...

The machine on which that happens is Thinkpad Edge 13, AMD model, BIOS 
v1.12, AMD RS780 (Radeon HD3200). What else do I need to supply? What 
debugging options to turn on?

I'm completely lost here and feel like a complete idiot.

Next I'm going to nuke my Gallium Mesa libraries and try to boot without 
them, but it's interesting anyway if anyone got similar symptoms.
