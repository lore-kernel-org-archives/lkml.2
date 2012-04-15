Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab2DOFNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 01:13:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52745 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2DOFNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 01:13:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120414192638.31fa501d@debxo>
References: <alpine.LNX.2.00.1204150049270.15578@swampdragon.chaosbits.net>
	<20120414192638.31fa501d@debxo>
Date: Sat, 14 Apr 2012 23:13:52 -0600
X-Google-Sender-Auth: _w3zhGuM0Y3aapqKVs1smLUyUTk
Message-ID: <CAKipaEoXyQ6VmUg3W3n3ZrEvo7Gs-yo1+WCAcuOqDaTr2KpJ_A@mail.gmail.com>
Subject: Re: [PATCH] staging: olpc_dcon.c: checkpatch.pl and style fixups
From: Jordan Crouse <jordan@cosmicpenguin.net>
To: Andres Salomon <dilinger@queued.net>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@googlemail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 8:26 PM, Andres Salomon <dilinger@queued.net> wrote:
> On Sun, 15 Apr 2012 00:53:04 +0200 (CEST)
> Jesper Juhl <jj@chaosbits.net> wrote:
>
>> This patch removes the few checkpatch.pl issues that are currently
>> reported for this file.
>>
>> It makes these changes:
>>
>> 1. Quoted strings that were broken over multiple lines are put on a
>>    single line for easier grep'ability.
>>
>> 2. Add missing level to a printk().
>>
>> 3. A few casts have had their space between the cast and variable
>>    removed.
>>
>
> These first three look fine.
>
>
>> 4. Two msleep() calls with times <= 20 have been changed to
>>    usleep_range() calls instead since msleep(<=20) may sleep for 20ms
>>    (on 100Hz kernels for instance).
>>    Picking a value for the lower bound of the range was easy, that was
>>    just the value passed to msleep(). As for picking the upper bound
>>    of the sleep I just went with two times the lower bound, for no
>>    other reason than the fact that in both cases that value was <=20ms
>>    and the end result will in any case be closer to the intention than
>>    a 20ms sleep.
>
>
> That msleep(1) was replaced with a longer msleep and fewer dcon_read
> attempts in OLPC's XO-1.75 kernel.  The msleep(10) should probably be
> a shorter usleep (though we'd need to test it).  In general, this
> stuff was done to work around bugs in the dcon, and the timing of these
> bugs appears to differ (probably due to smbus timing) between the
> various OLPC platforms - XO-1 (x86 amd geode), XO-1.5 (x86 via), and
> XO-1.75 (arm armada 610).
>
> Given that, I'd prefer to leave these alone and figure out the proper
> values later (with lots of testing).  Mind resubmitting with the
> msleep changes removed?

For what little authority I might still have 3 years later, I ACK the other
changes and agree with Andres about the timing.  The Geode numbers
were arrived upon after careful testing and consultation with various
witch doctors.

Jordan
