Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0E1Xmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 19:42:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33126 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0E1Xmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 19:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tIdje1tyIOeCMk+n+1PkkgqSnxyNoLYvjFC+sxKFAmpH7nwaIwMFSqyz2k71h2cNf2
         5oNYpcGfKgAhRv+CXOhJjEK+ZtRnFVw7P3txhI09z3KJWo3jrvPrIDhQyV+329s6izAD
         cyUlkwKLLuokaRsD7j/hOU58KsseuwUWu43Yw=
MIME-Version: 1.0
In-Reply-To: <4BFFCF39.3010507@nokia.com>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
	<20100528114123.GA22947@srcf.ucam.org>
	<4BFFB681.1000105@nokia.com>
	<AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
	<4BFFC5DF.5030504@nokia.com>
	<AANLkTikKGeGHHL6AYC7uBuT7Zihj7lozfidWQ8zRHwab@mail.gmail.com>
	<4BFFCF39.3010507@nokia.com>
Date: Sat, 29 May 2010 02:42:35 +0300
Message-ID: <AANLkTinyh1YLmL6miVAxvkh9RMYDY5JChA-_f7oN0zvb@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Igor Stoppa <igor.stoppa@nokia.com>
Cc: ext Brian Swetland <swetland@google.com>,
       ext Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "tytso@mit.edu" <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 5:12 PM, Igor Stoppa <igor.stoppa@nokia.com> wrote:
> ext Brian Swetland wrote:
>> How is it flawed?  Serious question.
>
> I would avoid repeating all the good arguments given so far, but to make it
> short:
>
> * I believe runtime PM is a much better starting point (at least for the
> type of HW targeted at mobile devices) because it mimics an always-on system
> toward userspace, which requires less disruption in the way apps are
> designed

I agree.

If I understand correctly, if we have a perfect user-space that only
does work when strictly needed and trying to do it in bursts, then we
would be reaching the lowest power state, and there would be no need
for suspend. The problem is that Android's user-space is pretty far
from that, so they said "let's segregate user-space and go to lower
power mode anyway".

If that's true, then this problem can be fixed in user-space, and in
fact, it already is on N900. Good behaving applications are
asynchronous, use g_timeout_add_seconds() to align bursts of work at
the same second intervals, and don't do polls directly, but use GLib's
mainloop. Same as in GNOME desktop. It seems there are other methods
to align multiple processes for longer periods of time, but that code
is closed and I can't find much information.

> * QoS is closer to the apps pov: fps if it is a media player or a game,
> transfer speed if it is a file manager, bandwidth if it is a network app,
> etc
> The app is required to express its opinion by using a format that it
> understands better and is less system dependent.
> Actually the kernel should only be concerned with 2 parameters at most for
> any given operation: latency and bandwidth/throughput

I think this information can be obtained dynamically while the
application is running, and perhaps the limits can be stored. It would
be pretty difficult for the applications to give this kind of
information because there are so many variables.

For example, an media player can tell you: this clip has 24 fps, but
if the user is moving the time slider, the fps would increase and drop
very rapidly, and how much depends at least on the container format
and type of seek.

A game or a telephony app could tell you "I need real-time priority"
but so much as giving the details of latency and bandwidth? I find
that very unlikely.

Cheers.

-- 
Felipe Contreras
