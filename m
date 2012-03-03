Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2CCP32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 10:29:28 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49374 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab2CCP31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 10:29:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dsahern@gmail.com designates 10.68.135.201 as permitted sender) smtp.mail=dsahern@gmail.com; dkim=pass header.i=dsahern@gmail.com
Date: Sat, 03 Mar 2012 08:29:25 -0700
Subject: Re: perf_guest default bug
Message-ID: <o5nshbqsdnyur2ous7ufw681.1330788375323@email.android.com>
From: David Ahern <dsahern@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q23FTY0L023781

Right. And Ingo committed the kernel side patch. I can only recall those 3 fixes at the moment (first sips into the first cup of coffee :-)).

David

Sent from my ASUS Eee Pad

Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

>Em Sat, Mar 03, 2012 at 11:04:05AM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Fri, Mar 02, 2012 at 12:00:01PM -0700, David Ahern escreveu:
>> > Similar to my last email, this patch is not in urgent trees or
>> > Linus' yet the problem exists in Linus' tree:
>> > https://lkml.org/lkml/2012/2/17/82
>> > 
>> > $ /tmp/pbuild/perf record -a  -- sleep 1
>> > [ perf record: Woken up 1 times to write data ]
>> > [ perf record: Captured and wrote 0.319 MB perf.data (~13935 samples) ]
>> > Segmentation fault
>> > 
>> > Root cause is the perf_guest setting.
>> > 
>> > $ /tmp/pbuild/perf --version
>> > perf version 3.3.rc5.60.g203738
>> 
>> This one was tricky, IIRC, weren't follow up patches needed to plug some
>> extra problems?
>
>Yeah, just trying cherry picking it and trying it on an RHEL6.2 kernel
>and it didn't work because older kernels don't have
>attr.exclude_{guest,host}, so I had to also cherrypick:
>
>[acme@sandy linux]$ git cherry-pick
>0c9781280fb672ca09c997df3f14ba506bbdb977
>Finished one cherry-pick.
>[perf/urgent b5f81a4] perf tools: Handle kernels that don't support attr.exclude_{guest,host}
>
>- Arnaldo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
