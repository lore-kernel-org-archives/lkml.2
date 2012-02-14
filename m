Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab2BNDWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:22:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57464 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2BNDV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:21:58 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <201202140052.39979.arnd@arndb.de>
References: <4F394D34.6000604@atmel.com>
	<201202140052.39979.arnd@arndb.de>
Date: Mon, 13 Feb 2012 19:21:58 -0800
Message-ID: <CAOesGMgvTtsSFf0c_f_TN373kH=hkPYj5xqzARKCNgLkOFBq-g@mail.gmail.com>
Subject: Re: [GIT PULL] at91: fixes for 3.3-rc4
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ryan Mallon <rmallon@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 13, 2012 at 4:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 13 February 2012, Nicolas Ferre wrote:
>> Olof, Arnd,
>>
>> Here is the second "fixes" pull request. It collects a simple #ifdef fix, the
>> proper use of ioremap() in the RTC driver and a set of SMC related
>> modifications.
>> The SMC has been modified recently and has broken the pata_at91 driver. The
>> new accessors are fixing this situation. Finally, the old at91_ide driver is
>> removed because it is not maintained anymore, the IDE tree is frozen and PATA
>> should be used instead.
>>
>> I have also verified that it merges correctly with depends/rmk/for-armsoc and all
>> at91 related 3.4 material...
>>
>> You can find all this here:
>>
>> The following changes since commit d65b4e98d7ea3038b767b70fe8be959b2913f16d:
>
> Hmm, this is a bit bigger than I would have hoped for an -rc4 pull request.

Agreed.

> I've applied it now to the fixes branch because it seems necessary, I hope
> this doesn't come back to us in a bad way. Olof, please have a look over
> these patches as well. If you're ok with these, I'll send the entire batch
> to Linus.

I was going to suggest holding off the driver removal for the 3.4
merge window since we are soon at -rc4, but I suppose it could still
be OK.

As far as the other changes, the pull request was a bit vague on where
the breakage was introduced. If it was in the 3.3 merge window then
it's generally suitable for the -rc fixes branch. But I also see that
the original commit date on the 'ARM: at91: add accessor to manage
SMC' patch was back in November and it was posted originally in early
December.

Overall it almost looks like these patches are left over pieces from
the merge window, and not really bug fixes as such -- they just finish
off implementing features that were merged earlier. That's not what
the kernel -rc cycle is for -- it is there to deal with regressions,
not to merge the last pieces of features.


Anyway, given that the features going in broke some boards (at least
that's what it looks like to me), there's reason to pick them up. But
next time around, please avoid merging broken features when you know
there's fixes needed (some accidental regressions are inevitable of
course, of course, etc).


Thanks,

-Olof
