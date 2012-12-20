Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2LTJR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:17:29 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45500 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2LTJRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:17:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121220075010.GD2691@gmail.com>
References: <1355928161-8082-1-git-send-email-linus.walleij@stericsson.com>
	<20121220013218.A55E93E0AD7@localhost>
	<20121220075010.GD2691@gmail.com>
Date: Thu, 20 Dec 2012 10:17:17 +0100
Message-ID: <CACRpkdZwaTRDD9ZsOcPx+=TfNT0m=5-t6w32195k3Kp=PqvnFA@mail.gmail.com>
Subject: Re: [PATCH] mfd: db8500-prcmu: fix irqdomain usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Anmar Oueja <anmar.oueja@linaro.org>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 8:50 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 20 Dec 2012, Grant Likely wrote:
>>
>> This looks wrong. It probably works at the moment, but calling
>> irq_create_mapping when trying to process an IRQ is backwards. There
>> certainly shouldn't be any processing of an irq that isn't already
>> mapped. irq_find_mapping() should be used instead.
>
> But irq_create_mapping() calls irq_find_mapping() if the irq is
> already mapped? Or are you saying that if it isn't already mapped
> then there is an issue somewhere else earlier in the code?

I've submitted a v2 patch making the changes I think Grant is
fishing for..

Basically irq_create_mapping() should be in slowpath and
irq_find_mapping() in fastpath with the semantics that
the former has to be called at least once before the other
is ever called.

This is not quite trivial to use ... irqdomain seems like it
will bite us repeatedly for the next few years.

Yours,
Linus Walleij
