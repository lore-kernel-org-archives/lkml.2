Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1DAKsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 06:48:23 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56030 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab1DAKsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 06:48:21 -0400
X-AuditID: b753bd60-a16f5ba000000ee4-f3-4d95ad6eaf5f
X-AuditID: b753bd60-a16f5ba000000ee4-f3-4d95ad6eaf5f
Message-ID: <4D95AD68.6030500@hitachi.com>
Date: Fri, 01 Apr 2011 19:48:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC PATCH] perf report: add sort by file lines
References: <1301391136.14111.98.camel@minggr.sh.intel.com>	 <1301392457.4859.74.camel@twins> <1301417155.3620.8.camel@localhost>	 <1301418183.2250.416.camel@laptop> <1301418404.2250.417.camel@laptop>	 <1301418533.2250.419.camel@laptop>	 <20110329174556.GC24129@ghostprotocols.net>  <4D92818A.8020405@hitachi.com> <1301554645.14111.215.camel@minggr.sh.intel.com>
In-Reply-To: <1301554645.14111.215.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/31 15:57), Lin Ming wrote:
>> So that what we need is a kind of the reverse compiler which generates
>> intermediate code (a sequence of register assignments) from
>> instruction code. That's not impossible task, but just hard and fun. :)
>> For that purpose, we'll need an instruction decoder and an evaluator
>> which allows us to trace the sequence of address dereferences.
> 
> I may borrow code from objdump to decode instruction.
> But not sure about the instruction evaluator, any hints?

I think using objdump is a fast path to make it.
But since we already have a decoder(insn.c) and an evaluator like code (in kvm)
inside the kernel, we'd better reuse it in user space tools too :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
