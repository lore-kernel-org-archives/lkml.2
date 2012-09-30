Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334Ab2I3Pqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 11:46:39 -0400
Received: from antcom.de ([188.40.178.216]:60375 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab2I3Pqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 11:46:38 -0400
Message-ID: <50686955.8040503@antcom.de>
Date: Sun, 30 Sep 2012 17:46:29 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Stijn Devriendt <highguy@gmail.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        bgat@billgatliff.com
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <CAOY=C6GG6jqqEAAGJjmDG-BFT2eq=9+ck+F_EOcthRgDCDv8=Q@mail.gmail.com> <50682402.8020402@antcom.de> <CAOY=C6FaLckRHSfAHvw2=J9xZEVFDZPL+1oKnKeGnpOGPFVB1w@mail.gmail.com> <506860C6.5020408@antcom.de> <CAOY=C6F1rHoGM0T9FqLYuVwzaidDZBzEf_uWn9mP8fmT1oURTQ@mail.gmail.com>
In-Reply-To: <CAOY=C6F1rHoGM0T9FqLYuVwzaidDZBzEf_uWn9mP8fmT1oURTQ@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/12 17:19, Stijn Devriendt wrote:
>> If I understand correctly, it's a violation (single-value should hold
>> for read and write).
>>
>> To solve it, I have the following in mind: /sys/.../gpiogroupXXX/
>> contains files "bit0" ... "bit31" which contain a gpio number each,
>> empty if "unconnected".
> 
> Unfortunately that means you can't atomically create a group.

I don't see a big advantage of having atomic create/request. Most
important is set/get, isn't it? I assume the following usage pattern:

* Create(request) - non atomic (maybe atomic but why not add GPIOs later?)
* Set - atomic
* Get - atomic
* ...

> It also creates a mess to keep ordering intact and to either
> keep the current pin state or override it at allocation-time.

Ordering should stay intact, and later add/delete operations could be
possible. I meant bit0 ... bit31 in the gpio block as such:

bit0  - "80"
bit1  - ""  (i.e. unconnected)
bit2  - "85"
bit3  - "2"
...
bit31 - ""

This scheme can support multiple gpio_chips, as discussed with Linus and
JC, which of course can't always guarantee real simultaneous I/O but
provide virtual I/O word access (32bit/64bit).

> Rules are rules, but why make the interface overly complex when
> the multi-value file is saner, cleaner and simpler?

Simply because they won't (and probably shouldn't) accept it mainline.

Roland
