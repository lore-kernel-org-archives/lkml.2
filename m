Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab0GMLt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 07:49:59 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:50066 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab0GMLt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 07:49:58 -0400
Message-ID: <4C3C52E2.1000801@ladisch.de>
Date: Tue, 13 Jul 2010 13:49:54 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Samuel Xu <samuel.xu.tech@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question on HPET timer reading from device driver?
References: <AANLkTimTN3FZjRAjFDV-3pSnwq9EEPzfs5-xXBH5KomO@mail.gmail.com>
In-Reply-To: <AANLkTimTN3FZjRAjFDV-3pSnwq9EEPzfs5-xXBH5KomO@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Xu wrote:
> While I failed to find a way to get time stamp value of HPET in Linux
> kenerl (I am doing a driver and want to know elapsed cycle from driver
> code).

The HPET is x86-specific any might not be available on every machine.

> I tried hpet_readl() from my driver code, while hit compiling error.

This function is intended for internal use by the kernel and not for
drivers, so it is not exported for modules.

You can hack your own accessor function by calling ioremap() on the HPET
address (0xfed00000 or 0xfefff000 or whatever) and reading from that
memory.

A more portable way to get a time stamp is getrawmonotonic().

> I also read the Linux Documentation of HPET, which contain a user mode
> demo app to generate a periodic timer via HPET, while missing the time
> stamp reading.

There is no ioctl for this; call mmap() on /dev/hpet and then read the
main counter value from offset 0xf0 of that memory.

A more portable way to get a time stamp is to use clock_gettime() with
CLOCK_MONOTONIC_RAW.


Regards,
Clemens
