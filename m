Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1C1Obc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:31:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37110 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1C1Obb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=G395PHwAJqN5xEwfDJOeEf+pK/+FoVIfP17oCcJUboP6FDExhyR1bvnYKS7RC5TN+x
         xuaIwQIuchIWBeJ7yhc/TxsOnDFr52HiChLa4cKTr69J0HD0m3YjwF7Rr4+7nDV/ywxY
         2HgvjaogMMFOdcdXfgjqpt+A8OOyyq3sTH/h0=
Message-ID: <4D909BBB.5020500@gmail.com>
Date: Mon, 28 Mar 2011 08:31:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6> <20110324113209.20235.61900.stgit@localhost6.localdomain6> <4D8B79E6.2050603@gmail.com> <4D8C6B1B.70409@hitachi.com> <4D8CAE74.9080805@gmail.com> <4D906450.1040809@hitachi.com>
In-Reply-To: <4D906450.1040809@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/11 04:34, Akihiro Nagai wrote:
>> from is sample->ip? to is sample->addr? In the above example
>> 0x39d3015260 is the value from sample->addr, 1526f is sample->ip which
>> resolves to _dl_next_ld_env_entry from /lib64/ld-2.13.so.
> Yes.
> In this example, resolved address is only sample->ip (branch from).
> We need the resolved address of sample->addr (branch to) too, because
> both of them are addresses of execution code.

Ok, now I understand. In that case add conversion of sample->addr to
symbols to perf-script.

>>
>>>
>>> Can perf-script do it by writing scripts?
>>
>> If you are pulling the data from a perf sample then you can accomplish
>> the same goal within perf-script.
> It seems that perf-script doesn't have the interface of converting
> sample->addr to symbol, pid, comm and others. Of course, we can add
> the interface to perf-script, and it could be another way to implement
> this function using perf-script.
> However, since BTS output usually becomes huge, it would be very slow
> to convert all the data by python/perl.

Custom fields are not run through python/perl; they are generated from
C-code. Take a look at tools/perf/builtin-script.c
