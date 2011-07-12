Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab1GLABl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 20:01:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9838 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1GLABk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 20:01:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=PNF7nxh4JcmMM7RaC9Bo7xunHw8zBjhuhaut4j8gTqUYpL3CAQs3CobGzvoasFvvI
	AcLp4YJLY8i8C1p4xnhGg==
MIME-Version: 1.0
In-Reply-To: <20110707092802.GA2486@arm.com>
References: <1302822031-6752-1-git-send-email-sjg@chromium.org>
	<4DA7A914.5020804@codeaurora.org>
	<BANLkTikcY-xzjd0W77UfWWoO8ibjKNXQGg@mail.gmail.com>
	<BANLkTin_TpzdQS96SPKUNye6vb2b55Qc4A@mail.gmail.com>
	<143ea9b1bb96e613d534caa7cb3a1e2d.squirrel@www.codeaurora.org>
	<20110426014741.GB28721@quad.lixom.net>
	<BANLkTikHT2E=76jMLbzmQm_CiUw8rA3cCA@mail.gmail.com>
	<20110706200607.GS8286@n2100.arm.linux.org.uk>
	<20110707092802.GA2486@arm.com>
Date: Mon, 11 Jul 2011 17:01:22 -0700
X-Google-Sender-Auth: unNiX8knvJdkYL2jPquhweJyP8g
Message-ID: <CAPnjgZ1-wPW1WyR0nC1R5BkLSwc54evb5gV0dpSEOM4duS4omg@mail.gmail.com>
Subject: Re: [PATCH v4] ARM: Use generic BUG() handler
From: Simon Glass <sjg@chromium.org>
To: Dave Martin <dave.martin@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Stephen Boyd <sboyd@codeaurora.org>,
        anish singh <anish198519851985@gmail.com>,
        lak <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, lk <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resent, without html, sorry]

Hi Russell & Dave,

On Thu, Jul 7, 2011 at 2:28 AM, Dave Martin <dave.martin@linaro.org> wrote:
> On Wed, Jul 06, 2011 at 09:06:07PM +0100, Russell King - ARM Linux wrote:
>>
>> Sorry, I've finally got back to looking at this.
>>
>> +               ".pushsection .rodata.str, \"aMS\", 1\n"        \
>>
>> According to my gas manual:
>>
>> | 7.88 `.pushsection NAME [, SUBSECTION] [, "FLAGS"[, @TYPE[,ARGUMENTS]]]'
>> | ...
[snip]
>> It appears that the TYPE argument is missing.  As the GAS manual says
>> its required, then I think it really ought to be there.  Any comment?
>
> I guess type should be %progbits.  That's what the compiler generates for
> the assembler input in similar situations.
>
> Interestingly, gas does not require this argument and seems to default to
> progbits anyway ... but it seems best to do what the manual says.
>

Thanks for this. I will update the patch and resend to the list.

Regards,
Simon

> Cheers
> ---Dave
>
