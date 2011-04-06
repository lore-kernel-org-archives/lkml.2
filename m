Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab1DFOeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:34:31 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:41582 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab1DFOea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ws8sVDwxyl9X2F2xsPbODRjM7EHNWyHyjVDKQsr1FZPBPaAPEcffuTOxnRDKzZ3Hn5
         6YvxDVrt+CF1ETPg867ThVPPPV1PsI5hz32PtmKYdwv6EmVTX4bvZ7uEVf44n8Inz5Hm
         +GhI2ApxjrTIhz9YD9YJIK7kFgWxmfy5DmFLk=
Message-ID: <4D9C79F1.2060308@gmail.com>
Date: Wed, 06 Apr 2011 08:34:25 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
References: <4D8B79E6.2050603@gmail.com> <4D8C6B1B.70409@hitachi.com> <4D8CAE74.9080805@gmail.com> <4D906450.1040809@hitachi.com> <4D909BBB.5020500@gmail.com> <20110401151313.GC2335@nowhere> <4D96072E.4060902@gmail.com> <20110406121501.GA1867@nowhere> <20110406140958.GA4987@ghostprotocols.net> <1302099301.2225.1381.camel@twins> <20110406143003.GD1867@nowhere>
In-Reply-To: <20110406143003.GD1867@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/06/11 08:30, Frederic Weisbecker wrote:
> On Wed, Apr 06, 2011 at 04:15:01PM +0200, Peter Zijlstra wrote:
>> On Wed, 2011-04-06 at 11:09 -0300, Arnaldo Carvalho de Melo wrote:
>>>> What we seem to need for that is to bring a pagefault tracepoint. We had
>>>> propositions for that in the past, but work on this is in pause mode it
>>>> seems. 
>>
>> Huh, whot? You can get that using PERF_COUNT_SW_PAGE_FAULT and
>> PERF_SAMPLE_ADDR.
> 
> Where are we doing that? I can't find the code that handles it.

That's what the other email thread was about, and the solution is just
that - perf record -e faults -c 1 -d ... Then it comes to dumping the
information. That's easy with the current perf-script.
