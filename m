Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1HKO5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:57:23 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38074 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1HKO5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <4E43C363.3000103@suse.cz>
References: <1312067499.22074.59.camel@i7.infradead.org>
	<4E4280BA.9050109@suse.cz>
	<1312981658.2989.39.camel@i7.infradead.org>
	<CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>
	<1312985888.2989.46.camel@i7.infradead.org>
	<CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com>
	<1312993987.2989.53.camel@i7.infradead.org>
	<CACqU3MXC_eDqgWDwnVe8KsqoAMTPQNiP6YMHD5G+1sMBhMwXzA@mail.gmail.com>
	<1312999168.2989.61.camel@i7.infradead.org>
	<CACqU3MWB+4n5Acd-GboH5WbCzfZFiAc0wNvOkn_5O+--7jLE8A@mail.gmail.com>
	<1313002322.2989.88.camel@i7.infradead.org>
	<CACqU3MU2J25q-wWJ8LNcMkwi3uMigz_+0=XcrNiPC0TGiJHZqA@mail.gmail.com>
	<1313018232.2989.114.camel@i7.infradead.org>
	<CACqU3MVyjzr47N9v23SGaSjiEOGoEaP1-TZ4Z_RyVNgVXgPEwg@mail.gmail.com>
	<1313052168.18037.9.camel@i7.infradead.org>
	<4E4399B3.3020909@suse.cz>
	<1313061012.18037.17.camel@i7.infradead.org>
	<m3r54std0x.fsf@hase.home>
	<1313062813.18037.24.camel@i7.infradead.org>
	<4E43C363.3000103@suse.cz>
Date: Thu, 11 Aug 2011 10:57:21 -0400
Message-ID: <CACqU3MVUeHTZ+cQYucYd8TvGoUOrwVhpxVpho-fqz3MkBTCTMQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: David Woodhouse <dwmw2@infradead.org>, Andreas Schwab <schwab@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 11, 2011 at 7:56 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 11.8.2011 13:40, David Woodhouse wrote:
>> On Thu, 2011-08-11 at 13:15 +0200, Andreas Schwab wrote:
>>>> That would be cute, but I'm not sure how to undefine something set on
>>>> the command line:
>>>>
>>>> $ cat > Makefile <<EOF
>>>> undefine BAR
>>>
>>> override undefine BAR
>>
>> Thanks. So we don't really need to change the auto.conf syntax; we could
>> just do:
>>
>> $(foreach var, $(filter CONFIG_%,$(.VARIABLES)), $(eval override undefine $(var)))
>>
>> But still I suspect we might *not* want that for options set on the
>> command line. We *don't* want 'make CONFIG_FOO=y oldconfig bzImage' to
>> say 'you can't enable CONFIG_FOO' and then build the bzImage anyway.
>
> If you do
> $ echo 'CONFIG_FOO=y' >all.config
> $ make allnoconfig bzImage
> then it will also build bzImage even if kconfig wasn't able to set
> CONFIG_FOO=y. IMO printing a warning that CONFIG_FOO could not be set is
> sufficient, as long as CONFIG_FOO is consistently unset.
>
FWIW, this is the broken behavior I have been pointing all along...

If kconfig hard failed on such case, we would not need such Kbuild black-magic.

>From my point of view, if environment override there should be, it
should behave the same as the all.config logic and hard fail when an
override has not been met. Code wise, this would translate as backend
code path being the same.

 - Arnaud
