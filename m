Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1LGRVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:21:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54229 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638Ab1LGRVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:21:41 -0500
Date: Wed, 7 Dec 2011 17:23:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: hs@denx.de
Cc: Wolfgang Denk <wd@denx.de>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-watchdog@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Detlev Zundel <dzu@denx.de>
Subject: Re: [PATCH] RFC, watchdog: add generic wdt driver API
Message-ID: <20111207172311.37b3358a@lxorguk.ukuu.org.uk>
In-Reply-To: <4EDF099E.80207@denx.de>
References: <1322992423-21683-1-git-send-email-hs@denx.de>
	<20111204125928.GB5788@pengutronix.de>
	<20111204170810.8370625EA22@gemini.denx.de>
	<20111205122649.6fc6aed2@lxorguk.ukuu.org.uk>
	<4EDF099E.80207@denx.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   A chain can request to kill the registering process if the interval
>   elapses.  In this case a restarted process can register with the
>   driver giving the same identifier and reset the chain.  This is the
>   main reason why there is no association between chains and processes
>   or open device files.

How do genuinely unused chains get automatically cleaned up

>   Possible chain actions:
>   - ACTION_SIGNAL: sends a configurable signal to the process
>   - ACTION_KILL: sends the SIGKILL signal to the process

These two are the same (detail)

> starting point to integrate it? As this "chain API" would controlled
> through ioctl() calls maybe drivers/watchdog/watchdog_dev.c would be
> a good place... or a drivers/watchdog/watchdog_chain.c which gets the
> ioctl calls, watchdog_dev.c couldn't parse ...

It doesn't actually seem to have any connection at all with the kernel
watchdog drivers. I don't mean that as a criticism but what you are
describing seems to be some kind of software timer groups.

If you wanted to link it to a real watchdog presumably you'd just put the
watchdog pinging user space process in a group and set it to get killed
if the group triggered.

I'm not sure I understand why it can't be done cleanly in userspace
either.

If you have a daemon accepting unix domain connections then it can get
the pid of the other end and can kill it, or monitor incoming packets and
requests from it. If that process is also the one pinging the hardware
watchdog it can provide reboot protection against its own crashing. It
can also do much more flexible and interesting policy things like only
pinging the watchdog each time all the clients check in.

Alan
