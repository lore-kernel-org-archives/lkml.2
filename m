Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2IXL1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:27:15 -0400
Received: from science.horizon.com ([71.41.210.146]:58799 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753611Ab2IXL1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:27:13 -0400
Date: 24 Sep 2012 07:27:12 -0400
Message-ID: <20120924112712.29480.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, vda.linux@googlemail.com
Subject: Re: [PATCH 1/4] lib: vsprintf: Optimize division by 10 for small integers.
Cc: hughd@google.com, linux-kernel@vger.kernel.org, mina86@mina86.com
In-Reply-To: <CAK1hOcOwRZs1dDV9Yw22zeVFSTHqScjXv302TEvDVuLgT7bJQg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +/* See comment in put_dec_full9 for choice of constants */
>>  static noinline_for_stack
>>  char *put_dec_full4(char *buf, unsigned q)
>>  {
>>         unsigned r;
>> -       r      = (q * 0xcccd) >> 19;
>> +       r      = (q * 0xccd) >> 15;
>>         *buf++ = (q - 10 * r) + '0';
>> -       q      = (r * 0x199a) >> 16;
>> +       q      = (r * 0xcd) >> 11;

> I would use 16-bit shifts instead of smaller ones.
> There may be CPUs on which "get upper half of 32-bit reg"
> operation is cheaper or smaller than a shift.

Good point, but wouldn't those CPUs *also* have multi-cycle multiply,
or have to synthesize it out of shift-and-add, in which case smaller
constants would save even more cycles?

I'm thinking original MC68010 here, which I'm not sure is even
meaningful any more.  ColdFire has single-cycle shifts.

Can you think of a processor where that would actually be
an improvement?
