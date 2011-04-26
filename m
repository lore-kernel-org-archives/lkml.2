Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1DZOWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:22:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36849 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab1DZOWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:22:13 -0400
MIME-Version: 1.0
In-Reply-To: <4DB6C89F.10903@csr.com>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
	<1302116833-24540-2-git-send-email-per.forlin@linaro.org>
	<4DA81F42.3070208@csr.com>
	<BANLkTimaTe0qD5sbEJj88YRv2DZv=1oxTQ@mail.gmail.com>
	<4DB6C89F.10903@csr.com>
Date: Tue, 26 Apr 2011 16:22:12 +0200
Message-ID: <BANLkTinVL7NJpgGF0KZAdmqgyu2pXyKFkA@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] mmc: add none blocking mmc request function
From: Per Forlin <per.forlin@linaro.org>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2011 15:29, David Vrabel <david.vrabel@csr.com> wrote:
> On 20/04/11 08:17, Per Forlin wrote:
>>
>>> Using a MMC request queue has other benefits -- it allows multiple users
>>> without having to claim/release the host.  This would be useful for
>>> (especially multi-function) SDIO.
>>
>> You mean claim and release would be done only within the mmc core. The
>> timed saved here would equal the time it takes to release and claim
>> the host.
>> Claim and release can also be used for power management to indicate if
>> any client is using the host, if not the power can be switched off.
>
> Isn't there a separate runtime power management API that different from
> claim/release?
>
I misunderstood. I thought you meant that the claim() and release()
were not needed if having an internal request queue in core.c.
Please discard my comment.

>> I just want to make sure I understand the multi-function SDIO case, I
>> haven't done any work with SDIO.
>> Can the SDIO functions compete over the same claim_host at the same time?
>> Example: if function 1 claims the host, function 2 and function 3 also
>> want to claim the host but have to wait for function 1 to release the
>> host.
>
> This is the case.   Each function driver has to claim exclusive access
> to the host.
>
>> What is the extra benefit of having the internal request queue for
>> multi function SDIO?
>
> It reduces the delays between commands if multiple drivers are sending
> commands.  I estimated performance improvements with 2-3% from just
> removing the need to claim/release in one particular SDIO function
> driver.  Performance improvements for multi-function cards would be a
> bit more (5% perhaps?).
>
Your estimates are promising.

> The more important benefit is the simplification of the API.
I agree. I will make a prototype for this. I don't think I will be
able to find time for this until middle of May. I let know you when I
have patches.

>
> David
Thanks,
Per
