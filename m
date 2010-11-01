Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0KAEvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 00:51:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45910 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab0KAEvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 00:51:05 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.188.124]
In-Reply-To: <4CCDE4EB.7060001@arndnet.de>
References: <4CCDA454.708@arndnet.de> <AANLkTin80pwnb1DX8OdZK3Wgsq0nj==G9VM3pahsmo0U@mail.gmail.com>
 <4CCDE4EB.7060001@arndnet.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 1 Nov 2010 06:50:43 +0200
Message-ID: <AANLkTik52SVa0SC_RtNtgFu2U9Gye7BKtQ7jNgMPKe=W@mail.gmail.com>
Subject: Re: regression: b43-sdio: probe of mmc0:0001:1 failed with error -16
To: Arnd Hannemann <arnd@arndnet.de>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 11:51 PM, Arnd Hannemann <arnd@arndnet.de> wrote:
>> In Daniel's scenario, mmc_sdio_init_card() fails because
>> mmc_send_relative_addr() returns -110.
>>
>> Can you please check out if that's the same thing you have too ?
>
> No, it seems to be the pm_runtime_get_sync in sdio_bus.c::sdio_bus_probe().

Yeah, this is just the symptom though - pm_runtime_get_sync tries to
power up the card, and eventually mmc_sdio_init_card() is called (by
mmc_sdio_resume which is invoked by mmc_resume_host).

On the XO-1.5 mmc_sdio_init_card() seems to fail due to
mmc_send_relative_addr() returning -110; this may suggest that
although mmc_power_off() and mmc_power_on() were called, we still
didn't have a full power reset, and the card/controller are left at a
weird state.

Can you please check out if that's the same failure in your case too ?

Thanks!
Ohad.
