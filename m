Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2GZLT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:19:28 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:51636 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab2GZLT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:19:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120726111030.GU3099@opensource.wolfsonmicro.com>
References: <1343298603-25442-1-git-send-email-kishon@ti.com>
	<20120726111030.GU3099@opensource.wolfsonmicro.com>
Date: Thu, 26 Jul 2012 16:49:21 +0530
Message-ID: <CAAe_U6LhrBnsU9nC0yXqyNmEjmDfrvYP5BYhAOhJiGxLZbk_Qw@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: regulator: add error checks for exported APIs
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: lrg@ti.com, balbi@ti.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 26, 2012 at 4:40 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jul 26, 2012 at 04:00:03PM +0530, Kishon Vijay Abraham I wrote:
>
>> Added error checks for exported APIs in regulator framework so that
>> incorrect use of these APIs does not result in a crash.
>
> The commit (especially the subject) should be more descriptive, it's not
> that we're missing error checks it's that you're handling garbage passed
> in from the user a bit more gracefully.
>
> I'm not sure how useful this is as-is -  if you're not checking your
> errors you're not checking your errors so it's probably just pushing the
> robustness failures around, especially since...
>
>> +     if (IS_ERR_OR_NULL(regulator))
>> +             return -ENODEV;
>
> ...this is too quiet, this should at the very least be generating a loud
> warning so people can see there's a problem (probably with WARN_ON so we
> can see what called it).  Can you respin with something noisier please?

Sure. I'll respin a new version.
>
> Also NULL is a valid regulator (though we don't use it right now).
I see a lot of dereferencing *regulator*. How is it supposed to work
when *regulator* is NULL?

Thanks
Kishon
