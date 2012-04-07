Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2DGRpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 13:45:44 -0400
Received: from antcom.de ([188.40.178.216]:49503 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab2DGRpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 13:45:43 -0400
Message-ID: <4F807D41.5000008@antcom.de>
Date: Sat, 07 Apr 2012 19:45:37 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH v2] gpio: Device tree support for LPC32xx
References: <1333497518-25838-1-git-send-email-stigge@antcom.de> <20120407035327.9D7923E246E@localhost> <4F80460E.50605@antcom.de> <CAKON4OxuP6AytcJDtDvbTaho4vFvUTQ0VfJiBnN5QEbK1xo1XQ@mail.gmail.com>
In-Reply-To: <CAKON4OxuP6AytcJDtDvbTaho4vFvUTQ0VfJiBnN5QEbK1xo1XQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/12 19:17, jonsmirl@gmail.com wrote:
>> Please consider how the groups are specified in
>> drivers/gpio/gpio-lpc32xx.c. They each have different numbers of lines
>> and GPIO / GPI / GPO functionality. So they also have different callback
>> sets, and we need to do separate gpiochip_add()s which leads to the
>> separate gpio-bank specifications in the dtsi file. Separate enabling of
>> those banks via OF are a nice by-product.
> 
> When you have six banks of 32b registers with sparse, active GPIOs in
> the banks, is there any advantage to saying bank one has 8 gpios, bank
> 2 has 14, bank 3 has 2, etc in the gpiochip?  Or just just register
> them as six banks of 32 GPIOs without indicating which are
> valid/invalid?

I think it is a good idea to only register GPIOs that are real when we
already have many (~100) instead of registering hundreds of invalid
extra ones (that will _always_ be invalid for this very driver).

Also corresponds nicely to the hardware specs when there are banks of
odd sizes which can be found registered accordingly in the kernel.

Roland
