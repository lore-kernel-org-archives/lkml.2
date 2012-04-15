Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab2DOC0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 22:26:51 -0400
Received: from lunge.queued.net ([173.255.254.236]:51839 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab2DOC0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 22:26:49 -0400
Date: Sat, 14 Apr 2012 19:26:38 -0700
From: Andres Salomon <dilinger@queued.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Jordan Crouse <jordan@cosmicpenguin.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@googlemail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: olpc_dcon.c: checkpatch.pl and style fixups
Message-ID: <20120414192638.31fa501d@debxo>
In-Reply-To: <alpine.LNX.2.00.1204150049270.15578@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204150049270.15578@swampdragon.chaosbits.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2012 00:53:04 +0200 (CEST)
Jesper Juhl <jj@chaosbits.net> wrote:

> This patch removes the few checkpatch.pl issues that are currently
> reported for this file.
> 
> It makes these changes:
> 
> 1. Quoted strings that were broken over multiple lines are put on a
>    single line for easier grep'ability.
> 
> 2. Add missing level to a printk().
> 
> 3. A few casts have had their space between the cast and variable
>    removed.
> 

These first three look fine.


> 4. Two msleep() calls with times <= 20 have been changed to
>    usleep_range() calls instead since msleep(<=20) may sleep for 20ms
>    (on 100Hz kernels for instance).
>    Picking a value for the lower bound of the range was easy, that was
>    just the value passed to msleep(). As for picking the upper bound
>    of the sleep I just went with two times the lower bound, for no
>    other reason than the fact that in both cases that value was <=20ms
>    and the end result will in any case be closer to the intention than
>    a 20ms sleep.


That msleep(1) was replaced with a longer msleep and fewer dcon_read
attempts in OLPC's XO-1.75 kernel.  The msleep(10) should probably be
a shorter usleep (though we'd need to test it).  In general, this
stuff was done to work around bugs in the dcon, and the timing of these
bugs appears to differ (probably due to smbus timing) between the
various OLPC platforms - XO-1 (x86 amd geode), XO-1.5 (x86 via), and
XO-1.75 (arm armada 610). 

Given that, I'd prefer to leave these alone and figure out the proper
values later (with lots of testing).  Mind resubmitting with the
msleep changes removed?
