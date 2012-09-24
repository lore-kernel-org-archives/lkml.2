Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2IXOSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:18:08 -0400
Received: from science.horizon.com ([71.41.210.146]:59699 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755452Ab2IXOSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:18:06 -0400
Date: 24 Sep 2012 10:18:05 -0400
Message-ID: <20120924141805.28256.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mpn@google.com, vda.linux@googlemail.com
Subject: Re: [PATCH 1/4] lib: vsprintf: Optimize division by 10 for small integers.
Cc: hughd@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <xa1tzk4g64cx.fsf@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Nazarewicz <mpn@google.com> wrote:
> On Fri, Aug 03 2012, George Spelvin <linux@horizon.com> wrote:
>> Shrink the reciprocal approximations used in put_dec_full4
>> based on the comments in put_dec_full9.
>
> Have you verified that the comment is correct?

I rechecked all the validity limits myself.

>>  	r      = (q * 0xcd) >> 11;

> If you are changing everything, this could also be changed to:
>
>	r      = (q * 0x67) >> 10;
>
> no?

Also in those comments is a statement I did *not* recheck, as it didn't
affect correctness, saying that 0xcd produces shorter code than 0x67 on
x86 (if the code is generated using shifts and adds).

That's why I left it that way.
