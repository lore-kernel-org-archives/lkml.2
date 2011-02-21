Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1BUHwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 02:52:33 -0500
Received: from smtp-out.google.com ([74.125.121.67]:15267 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1BUHwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 02:52:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cbjq6+EP/+CYmjSORkVe4bZ84D/GHwrtIYCZe4/7Cn9tU1XZPysnrVVj+/Lh7qk5qk
         nZiJr4k250k9Qc9mOtyg==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=jJRhyMZXbs3Unr-U+J59rt4SxMQtT4KtCqWbe@mail.gmail.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-17-git-send-email-ccross@android.com>
	<AANLkTi=jJRhyMZXbs3Unr-U+J59rt4SxMQtT4KtCqWbe@mail.gmail.com>
Date: Sun, 20 Feb 2011 23:52:28 -0800
X-Google-Sender-Auth: yNXiuc37OQL1zsFk9BjtfViUsxU
Message-ID: <AANLkTin3wPBZtgFp-AvEFhKG3X9Q7B=xFN9jR6fGjr+i@mail.gmail.com>
Subject: Re: [PATCH v2 15/21] ARM: tegra: clock: Round rate before setting rate
From: Colin Cross <ccross@android.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 8:19 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> On Sat, Feb 19, 2011 at 2:26 PM, Colin Cross <ccross@android.com> wrote:
>
>> diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
>> index 8d01a49..9798585 100644
>> --- a/arch/arm/mach-tegra/clock.c
>> +++ b/arch/arm/mach-tegra/clock.c
>> @@ -86,6 +86,7 @@ static unsigned long clk_predict_rate_from_parent(struct clk *c, struct clk *p)
>>
>>        if (c->mul != 0 && c->div != 0) {
>>                rate *= c->mul;
>> +               rate += c->div / 2; /* round up */
>
> Shouldn't this be "rate += c->div - 1;"?
Yes, will fix
