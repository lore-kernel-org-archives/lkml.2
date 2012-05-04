Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab2EDLkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 07:40:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60811 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2EDLkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 07:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120504103358.GD14230@opensource.wolfsonmicro.com>
References: <CAEqHmAstczdi2seTHFE0-jLK9fJaKosHjJyo4AJ7E9UKYBrVsg@mail.gmail.com>
	<20120430214718.GB4414@opensource.wolfsonmicro.com>
	<CAEqHmAsyJntRMqX+7NbQN0OmDXz6ZGh0LzAMp5KB=-cAMgpsJA@mail.gmail.com>
	<20120504103358.GD14230@opensource.wolfsonmicro.com>
Date: Fri, 4 May 2012 13:40:18 +0200
Message-ID: <CAEqHmAv+KTrJdiTL=76taTmu5YLYjukEiqk9UPbqCc-fDpQASw@mail.gmail.com>
Subject: Re: Linux 3.4-rc2 register mapping and paging on I2C device.
From: dd diasemi <dd.diasemi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Anthony Olech <Anthony.Olech@diasemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 12:33 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>
>> Below you can find my proposition of API for regmap paging support. It
>> is sufficient for my driver needs.
>> If you are OK with this proposition or you find any issues with it, let me know.
>
> Please submit an actual patch, this needs to be supported by things like
> the cache infrastructure as well.  One thing that's not obvious with
> just this is how things like register defaults and iterating all the
> known registers will work.
>
>> +config REGMAP_PAGING
>> +       bool
>
> No, this needs to work with both paged and non-paged devices.

Proposed implementation will extend virtually register range by number
of bits defined in .page_bits.
For example, for SPI register range 0 - 0x7F and 4 pages, we have
.page_bits = 2 and we define register mapping for range 0 - 0x1FF.
If .page_bits is not set and equal to 0, register range is going to be
defined as 0 - 0x7F and register mapping will work standard
(unchanged) way.

I plan to manage paging after caching and before actual address
formatting and bus write. The intention is to make register paging
transparent to regmap user and therefore it should cover situation,
when page boundaries are crossed by bulk read / write.
Proposed config flag - REGMAP_PAGING is here only to optimize kernel
compilation in case, when no drivers actually uses paging feature.

If you are asking about the details, I guess, comments may need to
improvement anyway to give a clearer view, how the API could be used,
right?

Kind Regards,
Krystian
