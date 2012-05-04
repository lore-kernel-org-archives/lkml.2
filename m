Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab2EDCZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 22:25:20 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57236 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2EDCZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 22:25:16 -0400
X-AuditID: 9c930179-b7c19ae000000486-ed-4fa33e0a27af
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf build failure on Linus's tree
References: <20120503215748.GA18995@kroah.com>
	<87sjfgafqj.fsf@sejong.aot.lge.com>
	<20120503.215020.954262287222794218.davem@davemloft.net>
	<CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
Date: Fri, 04 May 2012 11:24:14 +0900
In-Reply-To: <CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
	(Arnaud Lacombe's message of "Thu, 3 May 2012 22:14:03 -0400")
Message-ID: <87k40sadkh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 3 May 2012 22:14:03 -0400, Arnaud Lacombe wrote:
> Hi,
>
> On Thu, May 3, 2012 at 9:50 PM, David Miller <davem@davemloft.net> wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> Date: Fri, 04 May 2012 10:37:24 +0900
>>
>>> Hi,
>>>
>>> On Thu, 3 May 2012 14:57:48 -0700, Greg KH wrote:
>>>> Linus's tree right now (3.4.rc5.67.gac001.dirty) gives me the following
>>>> build error when I try to build perf:
>>>>     CC util/parse-events-flex.o
>>>> <stdout>: In function ‘yy_get_next_buffer’:
>>>> <stdout>:1510:3: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
>>>> util/parse-events.l: In function ‘parse_events_lex’:
>>>> util/parse-events.l:122:1: error: ignoring return value of ‘fwrite’, declared with attribute warn_unused_result [-Werror=unused-result]
>>>> cc1: all warnings being treated as errors
>>>>
>>>> Do you really want to ensure that flex's build warnings fail the build?
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> Can't reproduce it on my Fedora 17 box:
>>
>> Because your glibc headers probably don't have the warn_unused_result attribute
>> in the extern declaration of fwrite() like Greg's do.
>>
> `tools/perf/Makefile' adds -D_FORTIFY_SOURCE=2 on the compiler's
> command line, which in turn adds `__attribute__
> ((__warn_unused_result__))' to fwrite(3)'s prototypes, via `__wur'. I
> double checked by pre-processing `util/parse-events-flex.c' with the
> same arguments used by perf. fwrite(3) ends up being declared as:
>
> extern size_t fwrite (__const void *__restrict __ptr, size_t __size,
>         size_t __n, FILE *__restrict __s) __attribute__
> ((__warn_unused_result__));
>
> So it is definitively enabled, and used, on Fedora.
>
> Above tests were done on Fedora 15/x86_64 and Fedora 16/x86_64, `perf'
> build without any issue there too.
>
> my 0.2c,
>  - Arnaud

On my desktop:

$ make util/parse-events-flex.i
    CC util/parse-events-flex.i

$ grep -A1 'size_t fwrite' util/parse-events-flex.i
extern size_t fwrite (__const void *__restrict __ptr, size_t __size,
        size_t __n, FILE *__restrict __s) __attribute__ ((__warn_unused_result__));
--
extern size_t fwrite_unlocked (__const void *__restrict __ptr, size_t __size,
          size_t __n, FILE *__restrict __stream) __attribute__ ((__warn_unused_result__));


Thanks,
Namhyung
