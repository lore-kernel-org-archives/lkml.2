Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0E1NDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:03:21 -0400
Received: from smtp-out.google.com ([74.125.121.35]:48501 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0E1NDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:03:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=BcTxhJF8xO2+aaDuwg5s2qB8lgCuHOpdzVvIthmzDKttvszZfNPO3jxo09iRf69sR
	hCkmP54FisaK1t8WkNWWg==
MIME-Version: 1.0
In-Reply-To: <20100528125728.GP9874@ghostprotocols.net>
References: <4bff964c.e88cd80a.3106.7d31@mx.google.com>
	<20100528125728.GP9874@ghostprotocols.net>
Date: Fri, 28 May 2010 15:03:15 +0200
Message-ID: <AANLkTin33AdxO_yzRlZUTzoV9JtqaNqfYR2kXhOvke1P@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf report -D print sampled CPU
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, tzanussi@gmail.com,
       Arun Sharma <aruns@google.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 2:57 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Fri, May 28, 2010 at 12:08:01PM +0200, Stephane Eranian escreveu:
>> It is useful to know on which CPU a sample was captured on.
>> The information is captured with perf record -R but it was
>> not printed out by perf report -D. This patch adds this.
>>
>> When -R is not used, cpu is set to -1to indicate that
>> the CPU is unknown (it is not captured).
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>
> It conflicts with Arun's patch for sorting by CPU that I started playing with
> yesterday, but in a good way, i.e. printing the CPU at that dump_printf spot
> was one of the changs I made in Arun's patch as well.
>
Yes, I realized that afterwards.

> [root@emilia linux-2.6-tip]# perf report -D | grep SAMPLE | head -6
> 0x10240 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 2 17252/17252: 0xffffffff81253362 period: 1894446
> 0x10268 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 2 17252/17252: 0xffffffff81253338 period: 1894446
> 0x10290 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 2 17252/17252: 0xffffffff8125300d period: 1905103
> 0x102b8 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 0 0/0: 0xffffffff8109117d period: 1838260
> 0x102e0 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 0 293/293: 0xffffffff8101ace6 period: 352697
> 0x10308 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 0 1763/1763: 0xffffffff8101ace6 period: 352697
> [root@emilia linux-2.6-tip]#
>
> I added it just before the pid/tid but prefixing it with "cpu: " is as good as
> doing it that way.
>
Fine. I think there needs to be some documenation explaining the structure
of the line here. I had to dig into the code to understand it.

> I'm applying both patches after some tests,
>
Thanks.
