Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2EDCOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 22:14:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47767 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab2EDCOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 22:14:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120503.215020.954262287222794218.davem@davemloft.net>
References: <20120503215748.GA18995@kroah.com>
	<87sjfgafqj.fsf@sejong.aot.lge.com>
	<20120503.215020.954262287222794218.davem@davemloft.net>
Date: Thu, 3 May 2012 22:14:03 -0400
Message-ID: <CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
Subject: Re: perf build failure on Linus's tree
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: namhyung.kim@lge.com, gregkh@linuxfoundation.org, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        jolsa@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 3, 2012 at 9:50 PM, David Miller <davem@davemloft.net> wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> Date: Fri, 04 May 2012 10:37:24 +0900
>
>> Hi,
>>
>> On Thu, 3 May 2012 14:57:48 -0700, Greg KH wrote:
>>> Linus's tree right now (3.4.rc5.67.gac001.dirty) gives me the following
>>> build error when I try to build perf:
>>>     CC util/parse-events-flex.o
>>> <stdout>: In function ‘yy_get_next_buffer’:
>>> <stdout>:1510:3: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
>>> util/parse-events.l: In function ‘parse_events_lex’:
>>> util/parse-events.l:122:1: error: ignoring return value of ‘fwrite’, declared with attribute warn_unused_result [-Werror=unused-result]
>>> cc1: all warnings being treated as errors
>>>
>>> Do you really want to ensure that flex's build warnings fail the build?
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Can't reproduce it on my Fedora 17 box:
>
> Because your glibc headers probably don't have the warn_unused_result attribute
> in the extern declaration of fwrite() like Greg's do.
>
`tools/perf/Makefile' adds -D_FORTIFY_SOURCE=2 on the compiler's
command line, which in turn adds `__attribute__
((__warn_unused_result__))' to fwrite(3)'s prototypes, via `__wur'. I
double checked by pre-processing `util/parse-events-flex.c' with the
same arguments used by perf. fwrite(3) ends up being declared as:

extern size_t fwrite (__const void *__restrict __ptr, size_t __size,
        size_t __n, FILE *__restrict __s) __attribute__
((__warn_unused_result__));

So it is definitively enabled, and used, on Fedora.

Above tests were done on Fedora 15/x86_64 and Fedora 16/x86_64, `perf'
build without any issue there too.

my 0.2c,
 - Arnaud
