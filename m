Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1JDAfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:35:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55199 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1JDAfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:35:53 -0400
Date: Mon, 3 Oct 2011 17:35:49 -0700
From: mark gross <markgross@thegnar.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: markgross@thegnar.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: Re: [markgross@thengar.org: Re: [RFC] wake up notifications and
 suspend blocking (aka more wakelock stuff)]
Message-ID: <20111004003549.GA26888@mgross-G62>
Reply-To: markgross@thegnar.org
References: <20111002164849.GE14312@mgross-G62>
 <20111003093226.2b5e9c4d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003093226.2b5e9c4d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:32:26AM +0100, Alan Cox wrote:
> On Sun, 2 Oct 2011 09:48:49 -0700
> mark gross <markgross@thegnar.org> wrote:
> 
> > Forwarding to bigger group for discussion.
> 
> Looks clean enough - only question I have is do we need a separate
> 'suspend block' or can latency do it -suspend is a very very high latency
> event. I guess the suspend block is clearer in intent than abusing latency
> but I do wonder if the actual suspend path should also check latency
> constraints too. If I've asked for 5mS latency then suspend is a wrong
> choice!
> 
I don't think over loading the meaning of cpu_dma_latency would work
well for this.  If cpu_dma_latency constraint is > 5mS then EFAIL a
suspend attempt?  feels clunky.

If you use less than then anyone using a constraint (like some wifi
and audio) would block suspend.  also not so good.  


The poster child for needing this is the USB gadget device with
associated charging over USB.  Here we can't sleep because we'd have a
hard time meeting USB spec if we did.  Also, we don't want to sleep
while charging if charging is under OS control.  (checking temperature
is tricky while suspended.)

--mark

