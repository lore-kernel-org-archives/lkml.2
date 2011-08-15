Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1HOOwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:52:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37621 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1HOOwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:52:33 -0400
MIME-Version: 1.0
In-Reply-To: <4E48FB04.9010903@suse.cz>
References: <CACqU3MU2pjcqgYDjn=S2asdLamU0mity+kLizH_mbTtJU5Fh2A@mail.gmail.com>
	<1313341346-15605-1-git-send-email-lacombar@gmail.com>
	<4E48FB04.9010903@suse.cz>
Date: Mon, 15 Aug 2011 10:52:31 -0400
Message-ID: <CACqU3MWsHKnEwstzc-QQNXZZfFKR31RP0sdQmHmhgvdfrWXP-Q@mail.gmail.com>
Subject: Re: IS_ENABLED() and non-available symbols
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Rabin Vincent <rabin@rab.in>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/8/15 Michal Marek <mmarek@suse.cz>:
> On 14.8.2011 19:02, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Sun, Aug 14, 2011 at 12:55 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>> The solution is trivial, but I am not sure we want to go that way: we
>>> need to generated a __enabled_ entry for symbols for _all_ symbols in
>>> the configuration, even internal one
>>>
>> That should do the job...
>>
>>  -= NOT FOR MERGE =-
>>
>> Not-Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>>
>> ---
>>  scripts/kconfig/confdata.c |   42 +++++++++++++++++++++++++++++++-----------
>>  1 files changed, 31 insertions(+), 11 deletions(-)
>>
>>       for_all_symbols(i, sym) {
>> +             conf_write_symbol(out_h, sym, &header__enabled_printer_cb, NULL);
>> +
>>               sym_calc_value(sym);
>>               if (!(sym->flags & SYMBOL_WRITE) || !sym->name)
>>                       continue;
>
> I like the approach, it will work even with not visible symbols and
> still catch typos (which #ifdef does not protect against).
>
actually, the print should be after `sym_calc_value(sym)' to get the
value right..

> But with the
> patch as-is, the generated autoconf.h starts with lots of
>
> #define __enabled_CONFIG_(null) 1
> #define __enabled_CONFIG_(null)_MODULE 0
> #define __enabled_CONFIG_(null) 1
> #define __enabled_CONFIG_(null)_MODULE 0
> #define __enabled_CONFIG_(null) 0
>
that should be trivial to fix. Sunday morning patches...

I'd be interested to also know the cost of all those new symbols on
build time...

 - Arnaud
