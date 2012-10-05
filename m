Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab2JEKgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:36:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54616 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab2JEKgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:36:14 -0400
MIME-Version: 1.0
Date: Fri, 5 Oct 2012 12:36:04 +0200
Message-ID: <CABPqkBRCjd5=9t1URNXQvu8GbAHMjf3ixKtb6BV7ebBTZDLF1A@mail.gmail.com>
Subject: [RFC] perf: perf_event_attr anon unions and static initializer issue
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am writing a little test program for the perf_event API which is using
hardcoded events. Some of those events (SNBEP uncore events) require
a value for config1. I was naively assuming, one could simply do:

struct perf_event_attr attr = { .config = 0x1234, .config1 = 0x456 };

However this does not work with gcc version < 4.6 apparently. Don't
know how this even works with other compilers. I looked online and
I could not really find a good way of solving this that would be portable
across compiler versions.

If we name those unions, then this will break lots of existing programs.
We'd have to create a "named" version of perf_event_attr and then
memcpy() at runtime. Or simply initialize the .config1 and such fields at
runtime from a separate table.

Does anyone have a better solution to propose?
