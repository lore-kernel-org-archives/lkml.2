Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0K2GHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 01:07:00 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43215 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0K2GG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 01:06:58 -0500
Content-Type: text/plain; charset=UTF-8
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/6] perf: Add timestamp to COMM and MMAP events
From: Ian Munsie <imunsie@au1.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-reply-to: <20101125154718.GE15875@ghostprotocols.net>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com> <1290490544-14349-4-git-send-email-imunsie@au1.ibm.com> <1290510512.2072.387.camel@laptop> <20101123124121.GA11101@ghostprotocols.net> <20101125154718.GE15875@ghostprotocols.net>
Date: Mon, 29 Nov 2010 17:06:53 +1100
Message-Id: <1291009409-sup-4332@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Arnaldo Carvalho de Melo's message of Fri Nov 26 02:47:18 +1100 2010:
> Ian,
> 
>     Please take a look at:
> 
> http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=shortlog;h=refs/heads/perf/sample_type_id_all

Overall it looks pretty good, except (running on a 64way Power7 system):

$ taskset 2 perf record -T ./test 10000000
$ perf report -D|grep PERF_RECORD
<SNIP>
     1009028 0x9c70 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0xfefdfe8 period: 1 cpu:-1
     1010032 0x9c98 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0xfefdf6c period: 1 cpu:-1
     1011060 0x9cc0 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0x100007dc period: 1 cpu:-1
     1012082 0x9ce8 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0xfefe024 period: 1 cpu:-1
     1013112 0x9d10 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0xfefde64 period: 1 cpu:-1
     1014150 0x9d38 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0xfefdec8 period: 1 cpu:-1
     1015184 0x9d60 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0xfefde64 period: 1 cpu:-1
     1016202 0x9d88 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0xfefdf58 period: 1 cpu:-1
     1017230 0x9db0 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0x100007e4 period: 1 cpu:-1
     1018254 0x9dd8 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0xfefde64 period: 1 cpu:-1
     1019292 0x9e00 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0xfefdf3c period: 1 cpu:-1
     1020330 0x9e28 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0x100007e4 period: 1 cpu:-1
     1021390 0x9e50 [0x30]: PERF_RECORD_THROTTLE: unhandled!
     1021682 0x9e80 [0x28]: PERF_RECORD_SAMPLE(IP, 2): 5563/5563: 0x10000e2c period: 1 cpu:-1
     5160466 0x9ea8 [0x30]: PERF_RECORD_UNTHROTTLE: unhandled!
   251846992 0x9ed8 [0x30]: PERF_RECORD_EXIT(5563:5563):(5563:5563)
   251848132 0x9f08 [0x30]: PERF_RECORD_EXIT(5563:5563):(5563:5563)
   251848944 0x9f38 [0x30]: PERF_RECORD_EXIT(5563:5563):(5563:5563)
   251849684 0x9f68 [0x30]: PERF_RECORD_EXIT(5563:5563):(5563:5563)
   251850428 0x9f98 [0x30]: PERF_RECORD_EXIT(5563:5563):(5563:5563)
   251851164 0x9fc8 [0x30]: PERF_RECORD_EXIT(5563:5563):(5563:5563)
18446744073707910238 0x9ff8 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000038a38 period: 1 cpu:-1
18446744073707913124 0xa020 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc0000000000394a8 period: 1 cpu:-1
18446744073707913946 0xa048 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000039524 period: 1 cpu:-1
18446744073707914612 0xa070 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000008a5c period: 1 cpu:-1
18446744073707915242 0xa098 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000008af0 period: 1 cpu:-1
18446744073707915894 0xa0c0 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000008b4c period: 1 cpu:-1
18446744073707916926 0xa0e8 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc00000000012b754 period: 1 cpu:-1
18446744073707917932 0xa110 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc00000000002c13c period: 1 cpu:-1
18446744073707918894 0xa138 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000008ac0 period: 1 cpu:-1
18446744073707919814 0xa160 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000008b34 period: 1 cpu:-1
18446744073707920708 0xa188 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc00000000012b74c period: 1 cpu:-1
18446744073707921612 0xa1b0 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000048270 period: 1 cpu:-1
18446744073707922550 0xa1d8 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000047d84 period: 1 cpu:-1
18446744073707923488 0xa200 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc00000000012b7d0 period: 1 cpu:-1
18446744073707924446 0xa228 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc00000000012b27c period: 1 cpu:-1
18446744073707925426 0xa250 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc00000000012b460 period: 1 cpu:-1
18446744073707926370 0xa278 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc00000000012b43c period: 1 cpu:-1
18446744073707927332 0xa2a0 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc00000000012b460 period: 1 cpu:-1
18446744073707928302 0xa2c8 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc00000000012b43c period: 1 cpu:-1
18446744073707929300 0xa2f0 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000037ae0 period: 1 cpu:-1
18446744073707930302 0xa318 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000125ae8 period: 1 cpu:-1
18446744073707929794 0xa340 [0x28]: PERF_RECORD_COMM: test:5563
18446744073707931268 0xa368 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc0000000000a38d8 period: 1 cpu:-1
18446744073707932268 0xa390 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000127c7c period: 1 cpu:-1
18446744073707933238 0xa3b8 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000127cf0 period: 1 cpu:-1
18446744073707934226 0xa3e0 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000127d7c period: 1 cpu:-1
18446744073707935176 0xa408 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 5563/5563: 0xc000000000127e90 period: 1 cpu:-1
<SNIP>

This goes away if PERF_SAMPLE_CPU is added to the mix so that the
timestamps are offset from the first event of *their* CPU, otherwise
time-epoch can go negative, as it has done here.

I'm not sure that using per CPU epochs really makes much sense either -
if the first event on CPU1 happens (say) 10 minutes after the first
event on CPU0 the timestamps printed out by perf report -D would not
correlate, even for events that occurred within seconds of each other.


This also doesn't provide the userspace code to process every event in
order (to ensure that COMM and MMAP events have been processed prior to
any relevant samples), so the bug I was working on is still present, but
it does provide the ABI changes necessary to enable us fix it.

I'm happy to rebase the userspace side of my patches on top of this tree
to resolve that - I was extending the existing infrastructure to order
samples to handle other events as well.

Cheers,
-Ian
