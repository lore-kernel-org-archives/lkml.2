Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0ETNsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 09:48:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57096 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab0ETNsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 09:48:47 -0400
Message-ID: <4BF53C1E.9040305@zytor.com>
Date: Thu, 20 May 2010 06:41:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: mingo@redhat.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Use read() instead of lseek() in 	trace_event_read.c:skip()
References: <1273032130.6383.28.camel@tropicana>	 <tip-cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d@git.kernel.org> <AANLkTikqkbScJOVxynoOzejKnaNIucrAczgtGIDqXLCO@mail.gmail.com>
In-Reply-To: <AANLkTikqkbScJOVxynoOzejKnaNIucrAczgtGIDqXLCO@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 06:39 AM, Pekka Enberg wrote:
> On Thu, May 20, 2010 at 3:54 PM, tip-bot for Tom Zanussi
> <tzanussi@gmail.com> wrote:
>> Commit-ID:  cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d
>> Gitweb:     http://git.kernel.org/tip/cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d
>> Author:     Tom Zanussi <tzanussi@gmail.com>
>> AuthorDate: Tue, 4 May 2010 23:02:10 -0500
>> Committer:  Frederic Weisbecker <fweisbec@gmail.com>
>> CommitDate: Thu, 20 May 2010 08:37:17 +0200
>>
>> perf: Use read() instead of lseek() in trace_event_read.c:skip()
>>
>> This is a small fix for a problem affecting live-mode, introduced
>> recently:
>>
>> root@tropicana:~# perf trace rwtop
>> perf trace started with Perl
>> script /root/libexec/perf-core/scripts/perl/rwtop.pl
>>
>>  Fatal: did not read header event
>>
>> commit d00a47cce569a3e660a8c9de5d57af28d6a9f0f7 added a skip()
>> function to skip over e.g. header_page, but this doesn't work for
>> live mode.  This patch re-implements skip() to use read() instead of
>> lseek() to fix that.
> 
> Out of curiosity: why doesn't lseek() work and why can't we fix that?

Presumably because we're reading from a nonseekable stream?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

