Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab0EJUD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:03:29 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22022 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab0EJUD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:03:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Kyx39TvJ0xfiFFh6fbhku8TDYNwtp4EFZ1sDCy4I/IjM5RhU/ib344YC2+o4ed0WV
	xtgY7EcSVBGfxeujyLPjg==
MIME-Version: 1.0
In-Reply-To: <1273506739.5605.3407.camel@twins>
References: <AANLkTilxN7Lq8yywpsz8voqYo0hqOX0DGcoqHmAdmFW_@mail.gmail.com>
	 <1273506739.5605.3407.camel@twins>
Date: Mon, 10 May 2010 22:03:22 +0200
Message-ID: <AANLkTinNDC2g79VzfKjpm0bN1LOE5OeuVxvacjrNsz7s@mail.gmail.com>
Subject: Re: [BUG] perf_event: crash in perf_output_begin
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 5:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-05-10 at 17:33 +0200, Stephane Eranian wrote:
>> Hi,
>>
>> While testing 2.6.34-rc7 I ran into the following issue when
>> using BTS sampling on Intel Core. It seems like something
>> is not terminated properly. I am sampling BTS per-thread
>> on a test program, then hit CTRL-C, one second later my
>> machine crashes while running bash. Crash dump below:
>>
>> [  750.249109] general protection fault: 0000 [#1] SMP
>> [  750.249270] CPU 3
>> [  750.249270] Pid: 6132, comm: bash Not tainted 2.6.34-rc7-tip+ #46
>
> Can you try and reverting 4fd38e4595e2f6c9d27732c042a0e16b2753049c, I
> spend most of the day chasing that, and I can't say I'm much wiser.
>

It seems to avoid my problem. So that means with STATE_FREE, some code
path is exercised differently and there is leftover state that
generates spurious
interrupts, as if some event_sched_out() code was not executed.
