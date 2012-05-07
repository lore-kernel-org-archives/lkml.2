Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab2EGUUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:20:20 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59687 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab2EGUUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205072117330.6271@ionos>
References: <1336321508-20981-1-git-send-email-krzysztof.wilczynski@linux.com> <alpine.LFD.2.02.1205072117330.6271@ionos>
From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Date: Mon, 7 May 2012 21:19:38 +0100
X-Google-Sender-Auth: dEcY3lcwb9zS66Hus9pW1Jf-f5Y
Message-ID: <CAC52Y8Ywm7+apVm0Lef4i_Y3Cnb083rg6uXLew-Esa8YH0zKJA@mail.gmail.com>
Subject: Re: [PATCH] gpio: langwell: Prevent possible NULL pointer dereference
 in the demux handler.
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[...]
>> -     chip->irq_eoi(data);
>> +     if (data)
>> +             chip->irq_eoi(data);
>
> And how does data, which is always set as long as the interrupt exist
> prove that the chip has an eoi function?

It won't, a very good point. And as you told me (IRC) this has to be
solved on a more generic level (core handlers), and possibly
abstracted from the drivers. I will do and read through the code of
core handlers to learn more. Thanks for pointing it out and help so
far :)

KW
