Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2CIV3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:29:23 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41968 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584Ab2CIV3V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:29:21 -0500
MIME-Version: 1.0
In-Reply-To: <4F5A6B6B.50703@wwwdotorg.org>
References: <1331324305-1649-1-git-send-email-swarren@wwwdotorg.org>
	<20120309203207.GB10835@windriver.com>
	<4F5A6B6B.50703@wwwdotorg.org>
Date: Fri, 9 Mar 2012 16:29:20 -0500
X-Google-Sender-Auth: sEw9QvwQcX_vyMhqbRJ4i4xjIno
Message-ID: <CAP=VYLpZv-g5ZqONzhk51nth3Wn=zHmcfytdEBH3ZX7CJKjaZw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Include <linux/bug.h> to prevent compile errors
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 3:43 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 03/09/2012 01:32 PM, Paul Gortmaker wrote:
>> [[PATCH] pinctrl: Include <linux/bug.h> to prevent compile errors] On 09/03/2012 (Fri 13:18) Stephen Warren wrote:
>>
>>> Macros in <linux/pinctrl/machine.h> call ARRAY_SIZE(), the definition of
>>> which eventually calls BUILD_BUG_ON_ZERO(), which is defined in
>>> <linux/bug.h>. Include that so that every .c file using the pinctrl macros
>>> doesn't have to do that itself.
>>
>> Which C files are failing?  The approach was to be adding it only
>> for headers with static inlines which use it, and add it to C files
>> that are actually *deploying* the macros.
>
> For me, the files that are failing haven't been committed upstream yet;
> I expect them to be very soon after the 3.4 merge window completes.
>
> However, I expect you'll see this issue with arch/arm/mach-u300/core.c,
> since it uses the same macros defined in pinctrl/machine.h that cause
> the problem for me, unless one of the include files there picks up bug.h
> already.
>
> As a general statement though, once pinctrl becomes more widely adopted,
> I expect to see many files start to use macros from pinctrl/machine.h,
> and hence implicitly use ARRAY_SIZE(), and hence even more implicitly
> depend on linux/bug.h. I don't think it's at all reasonable to force the
> author of every one of those files to track down 3 or 4 levels of header
> file dependencies to find that they need linux/bug.h even though they
> make no direct use of its features, when it's known that almost any user
> of pinctrl/machine.h is going to hit this issue.

There was a similar discussion before, where there was concern over
"every one of those files" but in the end the number is a fraction of
a percent.   There is no harm in the author knowing they are making
_use_ of BUG stuff -- in fact if you happened to be trying to write some
fault tolerant code, you might really be glad to know, so you could take
steps to avoid it....

Paul.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
