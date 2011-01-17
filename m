Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1AQGq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 01:46:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59005 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab1AQGqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 01:46:11 -0500
MIME-Version: 1.0
In-Reply-To: <4D33E00E.5050802@wytron.com.tw>
References: <1254981838-20584-1-git-send-email-thomas@wytron.com.tw>
 <1295243200-28230-1-git-send-email-thomas@wytron.com.tw> <20110117165958.f89e8220.sfr@canb.auug.org.au>
 <4D33E00E.5050802@wytron.com.tw>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 16 Jan 2011 23:45:51 -0700
X-Google-Sender-Auth: D7Rml386BOcRPVVPm_9rftY88S8
Message-ID: <AANLkTi=D4Rcxbei2oo+EHc6X1O-2Oo+VWHAasK_JLj5W@mail.gmail.com>
Subject: Re: [PATCH v2] spi: New driver for Altera SPI
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Brownell <dbrownell@users.sourceforge.net>,
        nios2-dev@sopc.et.ntust.edu.tw, Mike Frysinger <vapier@gentoo.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 11:22 PM, Thomas Chou <thomas@wytron.com.tw> wrote:
> On 01/17/2011 01:59 PM, Stephen Rothwell wrote:
>>>
>>> +/*
>>> + * struct altera_spi_platform_data - platform data of the Altera SPI
>>> + * @interrupt: use intrrupt driven data transfer.
>>> + */
>>> +struct altera_spi_platform_data {
>>> +       int interrupt;
>>> +};
>>
>> Is there some reason that this struct definition cannot just be placed
>> in spi_altera.c and so save a whole extra file (and its inclusion)?
>>
>
> Hi Stephen,
>
> It is needed for board configuration file to attach this platform data,
> which is used to choose between interrupt driven data transfer or polling
> method. The data transfer rate is usually faster for polling, as interrupt
> overhead is higher.

In this case, that decision could simply be made based on whether or
not the device has an irq resource.  No irq == polled mode.

g.
