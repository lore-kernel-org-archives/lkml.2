Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1BPPKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:10:13 -0500
Received: from mout.perfora.net ([74.208.4.194]:54220 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1BPPKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:10:09 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Stephen Wilson <wilsons@start.ca>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David =?utf-8?Q?H=C3=A4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] rc: do not enable remote controller adapters by default.
References: <m3aahwa4ib.fsf@fibrous.localdomain>
	<1297862209.2086.18.camel@morgan.silverblock.net>
Date: Wed, 16 Feb 2011 10:09:44 -0500
In-Reply-To: <1297862209.2086.18.camel@morgan.silverblock.net> (Andy Walls's
	message of "Wed, 16 Feb 2011 08:16:49 -0500")
Message-ID: <m3ei78j9s7.fsf@fibrous.localdomain>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V02:K0:X9uzKy9c31Tcdjzj1Ew9vMc+v8UiJlQPXVN+WbZyU50
 aPoCPJ87rtnF20szLdSYiq/3V2/LDBDKzYVYUdaJXMUtLiYPUi
 3jWeWnVJpbhDgUFwr1MN3Ht0g27l5LNhvYa+qdJdFDk+bgK0Ql
 wqZCEqoPvFWowdYynzTE7j8VNGA4C9Eih3zHAV41WHb8y+gV2X
 PUXgyFSoerbpk5KoT1pVy2z9TSpqS5yHEWwbKaTeHo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Walls <awalls@md.metrocast.net> writes:

> On Wed, 2011-02-16 at 01:16 -0500, Stephen Wilson wrote:
>> Having the RC_CORE config default to INPUT is almost equivalent to
>> saying "yes".  Default to "no" instead.
>>
>> Signed-off-by: Stephen Wilson <wilsons@start.ca>
>
> I don't particularly like this, if it discourages desktop distributions
> from building RC_CORE.  The whole point of RC_CORE in kernel was to have
> the remote controllers bundled with TV and DTV cards "just work" out of
> the box for end users.  Also the very popular MCE USB receiver device,
> shipped with Media Center PC setups, needs it too.

A similar argument can be made for any particular feature or device that
just works when the functionality is enabled :)

> Why exactly do you need it set to "No"?

It is not a need.  I simply observed that after the IR_ to RC_ rename
there was another set of drivers being built which I did not ask for.

It struck me as odd that because basic keyboard/mouse support was
enabled I also got support for DTV card remote controls.

I don't think there are any other driver subsystems enabling themselves
based on something as generic as INPUT (as a dependency it is just fine,
obviously).

Overall, it just seems like the wrong setting to me.  Is there another
predicate available that makes a bit more sense for RC_CORE other than
INPUT?  Something related to the TV or DTV cards perhaps?


Take care,

>
> Regards,
> Andy
>
>> ---
>>  drivers/media/rc/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
>> index 3785162..8842843 100644
>> --- a/drivers/media/rc/Kconfig
>> +++ b/drivers/media/rc/Kconfig
>> @@ -1,7 +1,7 @@
>>  menuconfig RC_CORE
>>  	tristate "Remote Controller adapters"
>>  	depends on INPUT
>> -	default INPUT
>> +	default n
>>  	---help---
>>  	  Enable support for Remote Controllers on Linux. This is
>>  	  needed in order to support several video capture adapters.
>> --
>> 1.7.3.5
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
steve
