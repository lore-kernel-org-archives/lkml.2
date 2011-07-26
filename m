Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1GZPFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:05:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:16450 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab1GZPFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:05:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,269,1309762800"; 
   d="scan'208";a="32461840"
Date: Tue, 26 Jul 2011 16:07:58 +0100
From: Alan Cox <alan@linux.intel.com>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Ryan Mallon <rmallon@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Subject: Re: GMA500: ERROR: "__bad_udelay" undefined!
Message-ID: <20110726160758.6ce05577@bob.linux.org.uk>
In-Reply-To: <CAMeQTsYhLTPLUBGgBTQ=2xDjzw1aK2Oif+_aC+=hVikALuUXPg@mail.gmail.com>
References: <alpine.LNX.2.00.1107242327030.7103@swampdragon.chaosbits.net>
	<4E2CC55B.5010307@gmail.com>
	<4E2CC6CC.5020204@gmail.com>
	<62472696.BtqhiR95vr@wuerfel>
	<20110725224250.7d6edb83@bob.linux.org.uk>
	<CAMeQTsY3T5sPCRYzf8-Xca8y_mWjXSUOOptxHZ2YK5YNL0uvuw@mail.gmail.com>
	<20110726111927.129270f7@lxorguk.ukuu.org.uk>
	<CAMeQTsYhLTPLUBGgBTQ=2xDjzw1aK2Oif+_aC+=hVikALuUXPg@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think there is a particular reason for that. They are based
> on an old version of i915 that used to do it that way. i915 changed
> to polling pipestat in 2.6.36.

Right but i915 is different hardware, and the two deviate more over
hardware generations.

> If there is no vblank to be waited for, we shouldn't be doing
> wait_for_vblank. If we're waiting for a pipe to turn off, there
> should be a wait_for_pipe_disable, and so on..

If someone can figure out how it works on things like MIPI yes.

> What about catching vblanks in irq handler and using a wait queue in
> sleep_for_vblank and do pipestat polling in wait_for_vblank? Then I
> can start testing sleep vs wait. All current wait_for_vblanks should
> be replaced with mdelay(20) and marked with a FIXME.

We don't have a useful IRQ handler currently (or page flipping which
also needs that). It might help for some cases but again in most of
these situations if you follow the code the CRT is disabled at the
point we wait so there isn't a vblank.

> wait_for_pipe_disable can do mdelay(20) until something better comes
> up.
> 
> If that is ok with you, I'll send some patches.

Go for it.

Alan
