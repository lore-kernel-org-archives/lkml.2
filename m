Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1EJWwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:52:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64252 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1EJWwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:52:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w1HkruJxYwGQR/Ork2Ji+EiLDrY37iMVE9kDX05NUFlYtAsFTD4MVKVMQN9dkx02xw
         haXqgVWBxLJJqHhg0GPaDh1Hh5UFZnWShuiKOUN7jsmckgNnfvWYvNytOMOYmjVvEGHE
         1Hc02tUhJLJBIU6rYzD7Z3/KL9oAPv+qg8lac=
MIME-Version: 1.0
In-Reply-To: <1305067020.19586.130.camel@Joe-Laptop>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
	<1304365077.7792.40.camel@Joe-Laptop>
	<BANLkTi=XSevO72NqCYOYuketjE8XjeQU+A@mail.gmail.com>
	<1305067020.19586.130.camel@Joe-Laptop>
Date: Wed, 11 May 2011 00:52:20 +0200
X-Google-Sender-Auth: 7wMWZmArd1s7GUPZPGdStC2xycc
Message-ID: <BANLkTi=zDJLHUa2ogTeEkmdsbkhvGJCsEw@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/11 Joe Perches <joe@perches.com>:
> On Wed, 2011-05-11 at 00:18 +0200, Linus Walleij wrote:
>> 2011/5/2 Joe Perches <joe@perches.com>:
>> > On Mon, 2011-05-02 at 21:16 +0200, Linus Walleij wrote:
>> >> From: Linus Walleij <linus.walleij@linaro.org>
>> >> diff --git a/drivers/pinmux/core.c b/drivers/pinmux/core.c
>> > Trivial comments follow
>> >> +static inline int pin_is_valid(int pin)
>> >> +{
>> >> +     return ((unsigned)pin) < MACH_NR_PINS;
>> >> +}
>> > Couldn't pin just be declared unsigned or maybe u32?
>> No, because like in the GPIO subsystem you *may* want to send in invalid
>> pins, and those are identified by negative numbers.
>
> Then I think this is clearer and the compiler
> should produce the same code.
>
> static inline bool pin_is_valid(int pin)
> {
>        return pin >= 0 && pin < MACH_NR_PINS;
> }

Yes indeed, I'll fix. Can you propose a patch to the same pattern
found in include/asm-generic/gpio.h? It would bring equal
clarity there I believe.

Thanks!
Linus Walleij
