Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab1IMSna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:43:30 -0400
Received: from claw.goop.org ([74.207.240.146]:35377 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab1IMSn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:43:29 -0400
Message-ID: <4E6FA44F.1050705@goop.org>
Date: Tue, 13 Sep 2011 11:43:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org> <m2bouo37by.fsf@bob.laptop.org> <4E6F8C24.3090207@goop.org> <m2wrdc1i5b.fsf@bob.laptop.org>
In-Reply-To: <m2wrdc1i5b.fsf@bob.laptop.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 10:12 AM, Chris Ball wrote:
> Hi Jeremy,
>
> On Tue, Sep 13 2011, Jeremy Fitzhardinge wrote:
>>> On Mon, Sep 12 2011, Jeremy Fitzhardinge wrote:
>>>> Since 2.6.39, the SD card slot in my Lenovo X220 has stopped working.  
>>>> When I insert a card with current linux.git kernel (3.1-rc6), I get:
>>>>
>>>> [ 3891.745549] mmc0: new SDHC card at address b368
>>>> [ 3891.790704] mmcblk0: mmc0:b368 PNY   7.51 GiB 
>>>> [ 3891.795568] mmc0: Got data interrupt 0x00200000 even though no data
>>>> operation was in progress.
>>> Please could you try reverting a3c7778f8153b9 "mmc: sdhci: R1B command
>>> handling + MMC_CAP_ERASE"?  We've had one other similar report that
>>> bisected to this patch.
>> The revert was not entirely trivial (below), but I'm fairly sure I got
>> it right, and it didn't help.
> Thanks very much for doing that, sorry it didn't help.
>
> There's another related patch for your controller:
>    https://bugs.launchpad.net/ubuntu/+source/linux/+bug/773524
>
> This was merged as 15bed0f2fa8e1d7db ("mmc: Added quirks for Ricoh
> 1180:e823 lower base clock frequency").  Perhaps you could check that
> this code is running for you?

Yes, that's already there.

> If it is running, and not helping, can I persuade you to try a full
> bisection?

OK, will do.

>   I don't think we have other reports of this bug, and the
> only other person who has reported something like it wasn't a kernel
> hacker.

That's interesting; the X220 is a pretty common machine these days, I
think.  I wonder if there's variations in the SD controller or something?

> Thanks!


    J
