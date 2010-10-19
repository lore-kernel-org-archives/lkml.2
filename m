Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab0JSVC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:02:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46408 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691Ab0JSVC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:02:57 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <87r5fmxghm.fsf@deeprootsystems.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com> <87r5fmxghm.fsf@deeprootsystems.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 19 Oct 2010 23:02:37 +0200
Message-ID: <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
Subject: Re: [PATCH 3/3] omap: add hwspinlock device
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 7:03 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
>> +postcore_initcall(hwspinlocks_init);
>
> Any reason this needs to be a postcore_initcall?  Are there users of
> hwspinlocks this early in boot?

i2c-omap, which is subsys_initcall (the I2C bus is shared between the
A9 and the M3 on some OMAP4 boards).

And to allow early board code to reserve specific hwspinlock numbers
for predefined use-cases, we probably want to be before arch_initcall.

> The I2C   Probaly subsys or even device_initcall
> is more appropriate here.
>
> I would've suspected that any users of hwspinlocks will be dependent on
> drivers for the other cores (e.g. syslink) which would likely be
> initialized much later.
>
> Kevin
>
