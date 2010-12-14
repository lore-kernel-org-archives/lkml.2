Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687Ab0LNQ6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:58:47 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:48135 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759491Ab0LNQ6p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:58:45 -0500
MIME-Version: 1.0
In-Reply-To: <20101210114604.GB4228@pengutronix.de>
References: <1290205185-11956-1-git-send-email-bengardiner@nanometrics.ca>
	<cover.1291925752.git.bengardiner@nanometrics.ca>
	<67270e44ec792d1a684d6052f7aebbc8c538a6c1.1291925752.git.bengardiner@nanometrics.ca>
	<20101210114604.GB4228@pengutronix.de>
Date: Tue, 14 Dec 2010 11:58:39 -0500
Message-ID: <AANLkTimdw5crEJTdnObURp_kxqjwFas2RuDMewd=CqEG@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 2/3] spi_bitbang : get nsecs delay from cs during transfer
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 6:46 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Hi,
>
> thanks for the submission. It has some issues, though:

Hi Wolfram,

Thanks for the comments, I appreciate your interest in the RFC.

> On Thu, Dec 09, 2010 at 03:34:55PM -0500, Ben Gardiner wrote:
>
>> +             nsecs =
>> +#if defined(CONFIG_SLOWER_SPI_GPIO)
>> +                             !cs->nsecs ? cs->nsecs : 100;
>> +#else
>> +             100;
>> +#endif
>
> This coding style is very hard to read and gains nothing for it. Also,
> slower_spi should rather be a per-device than a config option.

Yes, now that you mention it the implementation looks very clunky.

I think it is starting to sink-in that a 'slower' spi gpio _driver_ is
needed. I can think of a couple different ways to make the CS-to-data
delay assigned to 'nsecs' a per-device feature:
1) a flag or 2) a function pointer in struct spi_bitbang. Were you
thinking of something else entirely?

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
