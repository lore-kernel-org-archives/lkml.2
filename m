Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab1ATPoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:44:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:43922 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881Ab1ATPoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:44:54 -0500
Message-ID: <4D385866.3060405@kernel.org>
Date: Thu, 20 Jan 2011 18:44:38 +0300
From: Denis Kirjanov <dkirjanov@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net
Subject: Re: [PATCH] perftools: Fix build error
References: <20110120093246.GA8031@hera.kernel.org> <20110120114719.GD23661@elte.hu>
In-Reply-To: <20110120114719.GD23661@elte.hu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 20 Jan 2011 15:44:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 02:47 PM, Ingo Molnar wrote:
> 
> * Denis Kirjanov <dkirjanov@kernel.org> wrote:
> 
>> Fix perftools build error (ppc64 box) with PERF_VERSION = 2.6.38.rc1.47.g12fcdb
>> CC builtin-top.o
>> cc1: warnings being treated as errors
>> builtin-top.c: In function 'print_sym_table':
>> builtin-top.c:540: error: format '%Ld' expects type 'long long int', but argument 2 has type '__u64'
>>
>> Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
>> ---
>>  tools/perf/builtin-top.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>> index 05344c6..8202a2e 100644
>> --- a/tools/perf/builtin-top.c
>> +++ b/tools/perf/builtin-top.c
>> @@ -537,7 +537,7 @@ static void print_sym_table(void)
>>  	if (nr_counters == 1 || !display_weighted) {
>>  		struct perf_evsel *first;
>>  		first = list_entry(evsel_list.next, struct perf_evsel, node);
>> -		printf("%Ld", first->attr.sample_period);
>> +		printf("%Ld", (unsigned long long)first->attr.sample_period);
> 
> Wouldnt %Lu solve this in a cleaner way?
> 
> Thanks,
> 
> 	Ingo
> 
I think that cleaner way is to use PRIu64.


>From 492bf54effdf8c154e76c4ca734f27ce1db46df6 Mon Sep 17 00:00:00 2001
From: Denis Kirjanov <dkirjanov@kernel.org>
Date: Thu, 20 Jan 2011 18:34:56 +0300
Subject: [PATCH] perftools: Fix build error

    CC perf.o
    CC builtin-top.o
cc1: warnings being treated as errors
builtin-top.c: In function 'print_sym_table':
builtin-top.c:540: error: format '%Ld' expects type 'long long int', but argument 2 has type '__u64'
make: *** [builtin-top.o] Error 1


Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---
 tools/perf/builtin-top.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 05344c6..a7bc50b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -40,6 +40,7 @@
 #include <stdio.h>
 #include <termios.h>
 #include <unistd.h>
+#include <inttypes.h>
 
 #include <errno.h>
 #include <time.h>
@@ -537,7 +538,7 @@ static void print_sym_table(void)
 	if (nr_counters == 1 || !display_weighted) {
 		struct perf_evsel *first;
 		first = list_entry(evsel_list.next, struct perf_evsel, node);
-		printf("%Ld", first->attr.sample_period);
+		printf("%" PRIu64, first->attr.sample_period);
 		if (freq)
 			printf("Hz ");
 		else
-- 
1.7.3.4

