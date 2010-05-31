Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab0EaFcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 01:32:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:32769 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab0EaFcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 01:32:46 -0400
Message-ID: <4C034F55.1090807@nokia.com>
Date: Mon, 31 May 2010 08:55:33 +0300
From: Igor Stoppa <igor.stoppa@nokia.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: ext Felipe Contreras <felipe.contreras@gmail.com>
CC: ext Brian Swetland <swetland@google.com>,
       ext Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "tytso@mit.edu" <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>	<20100527220949.GB10602@srcf.ucam.org>	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>	<20100527223605.GB11364@srcf.ucam.org>	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>	<20100528043114.GC26177@thunk.org>	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>	<20100528114123.GA22947@srcf.ucam.org>	<4BFFB681.1000105@nokia.com>	<AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>	<4BFFC5DF.5030504@nokia.com>	<AANLkTikKGeGHHL6AYC7uBuT7Zihj7lozfidWQ8zRHwab@mail.gmail.com>	<4BFFCF39.3010507@nokia.com> <AANLkTinyh1YLmL6miVAxvkh9RMYDY5JChA-_f7oN0zvb@mail.gmail.com>
In-Reply-To: <AANLkTinyh1YLmL6miVAxvkh9RMYDY5JChA-_f7oN0zvb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2010 05:31:56.0903 (UTC) FILETIME=[95CAB770:01CB0082]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Felipe Contreras wrote:

> I think this information can be obtained dynamically while the
> application is running,

yes, that was the idea

>  and perhaps the limits can be stored. It would
> be pretty difficult for the applications to give this kind of
> information because there are so many variables.
>
> For example, an media player can tell you: this clip has 24 fps, but
> if the user is moving the time slider, the fps would increase and drop
> very rapidly, and how much depends at least on the container format
> and type of seek.
>   

I doubt that belongs to typical QoS. Maybe the target could be to be 
able to decode a sequence of i-frames?
> A game or a telephony app could tell you "I need real-time priority"
> but so much as giving the details of latency and bandwidth? I find
> that very unlikely.
>   

from my gaming days the games were still evaluated in fps ... maybe i 
made the wrong assumption?

A telephony app should still be able to tell if it's dropping audio frames.

In all cases there should be some device independent limit - like: what 
is the sort of degradation that is considered acceptable by the typical 
user?

Tuning might be offered, but at least this should set some sane set of 
defaults.

igor
