Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab0KAOeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 10:34:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43945 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab0KAOeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 10:34:16 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.188.124]
In-Reply-To: <4CCECD09.2010505@arndnet.de>
References: <4CCDA454.708@arndnet.de> <AANLkTin80pwnb1DX8OdZK3Wgsq0nj==G9VM3pahsmo0U@mail.gmail.com>
 <4CCDE4EB.7060001@arndnet.de> <AANLkTik52SVa0SC_RtNtgFu2U9Gye7BKtQ7jNgMPKe=W@mail.gmail.com>
 <4CCE74DB.8000206@arndnet.de> <AANLkTinhYqhcQor3PhTKoS3At3Tt2Qv5WAGSirfR8eNG@mail.gmail.com>
 <4CCECD09.2010505@arndnet.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 1 Nov 2010 16:33:54 +0200
Message-ID: <AANLkTim8bfNDacFLs-kmkmtQuxUb-1BEqTNVW1dGQZxd@mail.gmail.com>
Subject: Re: regression: b43-sdio: probe of mmc0:0001:1 failed with error -16
To: Arnd Hannemann <arnd@arndnet.de>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 4:22 PM, Arnd Hannemann <arnd@arndnet.de> wrote:
> It looks like this:
>
> root@ap4evb:~# modprobe b43
> [   36.023437] cfg80211: Calling CRDA to update world regulatory domain
> [   36.460937] sdio_bus_probe()
> [   36.468750] sdio_bus_probe() calling pm_runtime_get_sync()
> [   36.468750] mmc_power_restore_host() begin
> [   36.570312] mmc_sdio_power_restore() begin
> [   36.570312] mmc_sdio_init_card()
> [   36.578125] mmc_sdio_init_card() mmc_send_io_op_cond ret=-110

OK, thanks. CMD5 time outs. I suspect it's similar to what we have
with the XO-1.5: despite software calling mmc_power_off/on, the
hardware does not go through full power off/on cycle.

>> The interesting part is actually what happens after sdio_bus_probe(),
>> not before it.
>
> Actually nothing special happens after sdio_bus_probe()

The actual failure happens after it (in mmc_sdio_init_card).

> With your patch the problem goes away, thanks.

Thank you for testing this,
Ohad.
