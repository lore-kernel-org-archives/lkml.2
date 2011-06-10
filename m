Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab1FJEav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 00:30:51 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:63905 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1FJEau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 00:30:50 -0400
X-AuditID: b753bd60-a0a78ba0000050a4-fb-4df19c85bc3d
X-AuditID: b753bd60-a0a78ba0000050a4-fb-4df19c85bc3d
Message-ID: <4DF19C7D.2080403@hitachi.com>
Date: Fri, 10 Jun 2011 13:24:29 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -tip v4 0/7] perf: Introduce branch sub commands
References: <20110526050246.30011.86048.stgit@localhost6.localdomain6> <20110526132833.GC21815@nowhere> <4DDE7EAD.7000603@gmail.com> <4DE39C31.1070600@hitachi.com> <4DE3B724.3020203@gmail.com>
In-Reply-To: <4DE3B724.3020203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/31 0:26), David Ahern wrote:
> On 05/30/2011 07:31 AM, Akihiro Nagai wrote:
>>> The sample address can be converted to symbols and the output can be
>>> added to perf-script rather easily. Attached is an example. I was going
>>> to submit it back in April and got distracted. I'll rebase, move the
>>> addr->sym conversion to a function and submit later today.
>> OK.
>> I agreed with implementing it on perf script.
>> I'd like to try it.
>
> Updated patch. It applies on top of:
>    http://lkml.org/lkml/2011/5/27/385
It looks good.

>
> Hopefully for BTS you only have to change the sample_addr_correlates_sym
> function.
Yes.
I'd like to enhance perf-script like this:

# perf script -f ip,addr,comm,sym,dso

output format is:
<comm> <ip> <sym_ip> <dso_ip> <addr> <sym_addr> <dso_addr>

actual output sample is:
ls 0xffffffff81460b92 common_interrupt /lib/modules/3.0/build/vmlinux 0x0000003e9b000b20 _start /lib64/ld-2.13.so
ls 0x0000003e9b000b23 _start /lib64/ld-2.13.so 0x0000003e9b004540 _dl_start /lib64/ld-2.13.so
...

By specifying 'ip' and 'addr' together, perf-script resolves
symbol and dso's path about both of 'ip' and 'addr'.

>
> I still need to look into out why some of the addresses for page-faults
> are not resolving to symbols.
I'd like to improve it referring perf branch's source codes.

Thank you.

>
> David
