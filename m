Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0FCSSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:18:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31565 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0FCSSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:18:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=m6VVGmsnWrE4LlfISKLL+N8Aki+r5c18K8exYpf2gyV5LFf/3TpQUGEurxNLjj5IR
	Z8hhfMTepAyXPE82m8B2w==
MIME-Version: 1.0
In-Reply-To: <20100603181103.GB10469@ghostprotocols.net>
References: <AANLkTik2yNxwCHl7FZAyOG4Vt56RlLi59oZR5Jo6o9ox@mail.gmail.com>
	<20100603175445.GC8928@ghostprotocols.net>
	<20100603180613.GA10469@ghostprotocols.net>
	<20100603181103.GB10469@ghostprotocols.net>
Date: Thu, 3 Jun 2010 20:18:04 +0200
Message-ID: <AANLkTincvUH7p-aHsDZoThUQn_eZkdbq3A8bM5i5ytpo@mail.gmail.com>
Subject: Re: how to use perf annotate on the kernel
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, tzanussi@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf annotate __lock_acquire -k /home/eranian/perfmon/official/tip/build/vmlinux
build id event received for [kernel.kallsyms]:
5c110a704293a259fbe11158dc1b25107ad7a23e
build id event received for
/lib/modules/2.6.35-rc1-tip/kernel/arch/x86/kernel/cpu/cpufreq/mperf.ko:
cb5
build id event received for
/lib/modules/2.6.35-rc1-tip/kernel/drivers/cpufreq/cpufreq_ondemand.ko:
cdb5
Using /home/eranian/perfmon/official/tip/build/vmlinux for symbols
hist_entry__inc_addr_samples: ip=0xffffffff81073b36
0xffffffff81073b30 __lock_acquire: period++ [ip: 0xffffffff81073b36, 0x6] => 1
hist_entry__inc_addr_samples: ip=0xffffffff81073c94

But in the end I get:
objdump: '[kernel.kallsyms]': No such file


------------------------------------------------
 Percent |      Source code & Disassembly of [kernel.kallsyms]
------------------------------------------------


On Thu, Jun 3, 2010 at 8:11 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Thu, Jun 03, 2010 at 03:06:13PM -0300, Arnaldo Carvalho de Melo escreveu:
>> For instance, here using -vvv I get:
>>
>> [root@emilia ~]# perf annotate -vvv memcpy > /dev/null
>> build id event received for [kernel.kallsyms]: 310920b54cbbf242dbfa09052f652806d2c73821
>> build id event received for /lib64/libtinfo.so.5.7: cd9da7b5b1fcb25ee6b3762bb9fe62f782590fd5
>> Looking at the vmlinux_path (6 entries long)
>> No build_id in /root/.debug/.build-id/31/0920b54cbbf242dbfa09052f652806d2c73821, ignoring it
>> No build_id in vmlinux, ignoring it
>> No build_id in /boot/vmlinux, ignoring it
>> No build_id in /boot/vmlinux-2.6.35-rc1, ignoring it
>> Using /lib/modules/2.6.35-rc1/build/vmlinux for symbols
>> hist_entry__inc_addr_samples: ip=0xffffffff811ea69e
>> 0xffffffff811ea690 memcpy: period++ [ip: 0xffffffff811ea69e, 0xe] => 1
>> hist_entry__annotate: filename=/lib/modules/2.6.35-rc1/build/vmlinux, sym=memcpy, start=0xffffffff811ea690, end=0xffffffff811ea730
>> annotating [0x187e770] /lib/modules/2.6.35-rc1/build/vmlinux : [0x19b1f70]                         memcpy
>> Executing: objdump --start-address=0xffffffff811ea690 --stop-address=0xffffffff811ea730 -dS /lib/modules/2.6.35-rc1/build/vmlinux|grep -v /lib/modules/2.6.35-rc1/build/vmlinux|expand
>> [root@emilia ~]#
>>
>> I'm removing all vmlinux from the path so that I can reproduce what you see.
>
> [root@emilia ~]# mv /lib/modules/2.6.35-rc1/build/vmlinux /lib/modules/2.6.35-rc1/build/vmlinux.OFF
> [root@emilia ~]# perf annotate -vvv memcpy > /dev/null
> build id event received for [kernel.kallsyms]: 310920b54cbbf242dbfa09052f652806d2c73821
> build id event received for /lib64/libtinfo.so.5.7: cd9da7b5b1fcb25ee6b3762bb9fe62f782590fd5
> Looking at the vmlinux_path (6 entries long)
> No build_id in /root/.debug/.build-id/31/0920b54cbbf242dbfa09052f652806d2c73821, ignoring it
> No build_id in vmlinux, ignoring it
> No build_id in /boot/vmlinux, ignoring it
> No build_id in /boot/vmlinux-2.6.35-rc1, ignoring it
> No build_id in /lib/modules/2.6.35-rc1/build/vmlinux, ignoring it
> No build_id in /usr/lib/debug/lib/modules/2.6.35-rc1/vmlinux, ignoring it
> Using /proc/kallsyms for symbols
> [root@emilia ~]#
> [root@emilia ~]# vi ~/.perfconfig
> [root@emilia ~]# cat ~/.perfconfig
> [tui]
>
>        report = on
>        annotate = off
> [root@emilia ~]# perf annotate memcpy
> [root@emilia ~]# perf annotate memcpy
> [root@emilia ~]# perf annotate -k vmlinux memcpy
> [kernel.kallsyms] with build id 310920b54cbbf242dbfa09052f652806d2c73821 not found, continuing without symbols
>
>        Yeah, these error messages suckz, will work on having proper messages
> for these cases :-\
>
> - Arnaldo
>
