Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2JELtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:49:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36956 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab2JELtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:49:45 -0400
MIME-Version: 1.0
In-Reply-To: <1349434879.14388.35.camel@twins>
References: <CABPqkBRCjd5=9t1URNXQvu8GbAHMjf3ixKtb6BV7ebBTZDLF1A@mail.gmail.com>
	<1349434879.14388.35.camel@twins>
Date: Fri, 5 Oct 2012 13:49:44 +0200
Message-ID: <CABPqkBTjwEp+wO_PW6xtazYiZXA-ogsmKVOd2-JJgbh47sHcQA@mail.gmail.com>
Subject: Re: [RFC] perf: perf_event_attr anon unions and static initializer issue
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 1:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-10-05 at 12:36 +0200, Stephane Eranian wrote:
>
>> struct perf_event_attr attr = { .config = 0x1234, .config1 = 0x456 };
>
>> Does anyone have a better solution to propose?
>
>
>   struct perf_event_attr attr = {
>         .config = 0x1234,
>         { .config1 = 0x5678 },
>   };
>
> sometimes works, but apparently not in this case.. its a bit unfortunate
> indeed. EDG based compilers and the latest C std use your version --
> hence also 4.6 supporting it.
>
> Yeah, I'm afraid we're stuck with this until a future where modern C
> isn't modern anymore.

Yeah, unfortunately.
I ended up creating a separate table for config1 and initializing attr.config1
at runtime. That way it works regardless of the compiler....
