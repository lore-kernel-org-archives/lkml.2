Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab1CAQ2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:28:41 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37026 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab1CAQ2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:28:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bMg3g3miNlfOdeqy6KueKjEx97x7W5M1L8Hlex6sDT0j0QNEixDutKf8we/Hzs4Hok
         F7C2Xpm8d9CHGxxoikwa4bFY7frw4NC/f/9RLv9ARLqdkac/z1VVIVZUaJf+b1s7tLFy
         /mDFqmwsDa2AtF64qZxaAtdyaQCarbb06tswA=
MIME-Version: 1.0
In-Reply-To: <4D6D1AA8.4060809@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
	<1298865151-23656-5-git-send-email-daahern@cisco.com>
	<AANLkTikwsuBGVfB6uu7=H0jbL+2YbbvX=ea6rLwNP8w-@mail.gmail.com>
	<4D6D004F.5010602@cisco.com>
	<AANLkTi=jmS80Rs13QiTmdA5iUXvNaSKxQ9Gpp2P2nqRU@mail.gmail.com>
	<4D6D1AA8.4060809@cisco.com>
Date: Tue, 1 Mar 2011 17:24:44 +0100
Message-ID: <AANLkTin_ShM+OA3QPxJ1Tc-EGf6enHg-d84Cdpg00=Op@mail.gmail.com>
Subject: Re: [PATCH 4/6] perf script: dump software events too
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/1 David Ahern <daahern@cisco.com>:
>
>
> On 03/01/2011 08:11 AM, Frederic Weisbecker wrote:
>>
>> Why shouldn't it be designed to dump software events? It's called print_event().
>> Its current version is rather something I would call "limited". But it
>> was not designed
>> to be limited.
>
> That's because its origins are trace specific. Per last week's thread,
> perf-script was perf-trace until Nov 2010. perf-script deals with
> tracepoints.

Right it has been first created to support tracing events. Now why
should it stay limited to them?

>> Ideally, we should have print_tracepoint_event() in
>> trace-event-parse.c, print_software_event()
>> where you want, and have print_event() in builtin-script.c that wraps on those.
>
>
> process_event does not take the event sample, it takes elements of it:
>
> struct scripting_ops {
> ...
>    void (*process_event) (int cpu, void *data, int size,
>                   unsigned long long nsecs, char *comm);
> ...
> };

What is the problem with changing a function prototype?
