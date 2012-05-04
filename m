Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2EDOBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:01:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64238 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2EDOBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:01:17 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung.kim@lge.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/13] perf evlist: Fix creation of cpu map
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
	<1335417327-11796-8-git-send-email-namhyung.kim@lge.com>
	<4F996433.7040003@gmail.com> <1335474778.1497.14.camel@leonhard>
	<4F99BCAF.1080309@gmail.com> <87397qhvvx.fsf@sejong.aot.lge.com>
	<20120502184033.GD5745@infradead.org>
	<87fwbga8v7.fsf@sejong.aot.lge.com>
	<20120504133706.GA10068@infradead.org>
Date: Fri, 04 May 2012 22:53:29 +0900
In-Reply-To: <20120504133706.GA10068@infradead.org> (Arnaldo Carvalho de
	Melo's message of "Fri, 4 May 2012 10:37:06 -0300")
Message-ID: <87bom4xdba.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 4 May 2012 10:37:06 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, May 04, 2012 at 01:05:48PM +0900, Namhyung Kim escreveu:
>> On Wed, 2 May 2012 15:40:33 -0300, Arnaldo Carvalho de Melo wrote:
>> > Em Fri, Apr 27, 2012 at 09:16:18AM +0900, Namhyung Kim escreveu:
>> >> So as long as you set perf_event_paranoid to -1 or run perf test as
>> >> root, you cannot see the failure.
>> >
>> > Ok, as root try 'perf top', here I get, with this patch:
>> >
>> > [root@sandy ~]# perf top --stdio
>> > Warning:
>> > The sys_perf_event_open() syscall returned with 22 (Invalid argument).
>> > /bin/dmesg may provide additional information.
>> > No CONFIG_PERF_EVENTS=y kernel support configured?
>> > [root@sandy ~]#
>> >
>> > Skipping this one, will look again later.
>> >
>> Sorry. It is because perf top depends on an undefined behaviour that
>> if neither target nor command line argument was specified it'd open
>> events for all online cpus. In contrast, perf record and perf stat will
>> show the help message in this case.
>> 
>> This patch makes it clear that we have to prepare a sane target
>> configuration before opening a perf event fd. So I think we should fix
>> perf top to set top.target.system_wide to true by default.
>
> So please provide a preparatory patch for top before this one, ok?
>

Okay, will do.

Thanks,
Namhyung
