Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1GZOHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:07:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58058 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1GZOHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:07:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110726111927.129270f7@lxorguk.ukuu.org.uk>
References: <alpine.LNX.2.00.1107242327030.7103@swampdragon.chaosbits.net>
	<4E2CC55B.5010307@gmail.com>
	<4E2CC6CC.5020204@gmail.com>
	<62472696.BtqhiR95vr@wuerfel>
	<20110725224250.7d6edb83@bob.linux.org.uk>
	<CAMeQTsY3T5sPCRYzf8-Xca8y_mWjXSUOOptxHZ2YK5YNL0uvuw@mail.gmail.com>
	<20110726111927.129270f7@lxorguk.ukuu.org.uk>
Date: Tue, 26 Jul 2011 16:07:07 +0200
Message-ID: <CAMeQTsYhLTPLUBGgBTQ=2xDjzw1aK2Oif+_aC+=hVikALuUXPg@mail.gmail.com>
Subject: Re: GMA500: ERROR: "__bad_udelay" undefined!
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Ryan Mallon <rmallon@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Opinions are cheap, generating a list of all the paths through the tree
> that can hit vblank waits is alas not, neither is verifying it on a pile
> of real hardware 8(

Yes, it certainly needs testing before being changed.

> Plus none of the Intel issued IMG drivers wait for a vblank event and in
> several cases it's quite clear that there is *no* vblank that can be
> waited for at that point, eg look at the MIPI interfaces.

I don't think there is a particular reason for that. They are based on an old
version of i915 that used to do it that way. i915 changed to polling pipestat
in 2.6.36.

If there is no vblank to be waited for, we shouldn't be doing
wait_for_vblank. If we're waiting for a pipe to turn off, there should be a
wait_for_pipe_disable, and so on..

> So unfortunately it's rather complicated to fix although working them
> through to make some of the msleeps is certainly doable - add a
> sleep_for_vblank() or similar and send patches as you verify each one is
> ok and test it perhaps ?
>
> Alan

What about catching vblanks in irq handler and using a wait queue in
sleep_for_vblank and do pipestat polling in wait_for_vblank? Then I can start
testing sleep vs wait. All current wait_for_vblanks should be replaced with
mdelay(20) and marked with a FIXME.

wait_for_pipe_disable can do mdelay(20) until something better comes up.

If that is ok with you, I'll send some patches.

Patrik
