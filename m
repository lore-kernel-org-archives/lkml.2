Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab2J2PYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:24:43 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62316 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2J2PYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:24:41 -0400
MIME-Version: 1.0
In-Reply-To: <1351524186.24721.29.camel@twins>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-5-git-send-email-eranian@google.com>
	<1351524186.24721.29.camel@twins>
Date: Mon, 29 Oct 2012 16:24:41 +0100
Message-ID: <CABPqkBQEcPdDKgR6nSvcJQ4WcSJNzi8LS+QO9yTsLfdjigijuA@mail.gmail.com>
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load Latency
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 4:23 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-10-29 at 16:15 +0100, Stephane Eranian wrote:
>> +EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x100b,umask=0x1,ldlat=3");
>> +EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
>
> I haven't fully grokked the macro magic yet, but event=0x100b seems
> wrong, event only takes 8 bit on Intel.

Yeah, my bad. I messed up on this one. should be:
event=0x0b,umask=0x10,ldlat=3
