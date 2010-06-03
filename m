Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab0FCSLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:11:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47145 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0FCSL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:11:29 -0400
Date: Thu, 3 Jun 2010 15:11:03 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, tzanussi@gmail.com
Subject: Re: how to use perf annotate on the kernel
Message-ID: <20100603181103.GB10469@ghostprotocols.net>
References: <AANLkTik2yNxwCHl7FZAyOG4Vt56RlLi59oZR5Jo6o9ox@mail.gmail.com>
 <20100603175445.GC8928@ghostprotocols.net>
 <20100603180613.GA10469@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603180613.GA10469@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 03, 2010 at 03:06:13PM -0300, Arnaldo Carvalho de Melo escreveu:
> For instance, here using -vvv I get:
> 
> [root@emilia ~]# perf annotate -vvv memcpy > /dev/null
> build id event received for [kernel.kallsyms]: 310920b54cbbf242dbfa09052f652806d2c73821
> build id event received for /lib64/libtinfo.so.5.7: cd9da7b5b1fcb25ee6b3762bb9fe62f782590fd5
> Looking at the vmlinux_path (6 entries long)
> No build_id in /root/.debug/.build-id/31/0920b54cbbf242dbfa09052f652806d2c73821, ignoring it
> No build_id in vmlinux, ignoring it
> No build_id in /boot/vmlinux, ignoring it
> No build_id in /boot/vmlinux-2.6.35-rc1, ignoring it
> Using /lib/modules/2.6.35-rc1/build/vmlinux for symbols
> hist_entry__inc_addr_samples: ip=0xffffffff811ea69e
> 0xffffffff811ea690 memcpy: period++ [ip: 0xffffffff811ea69e, 0xe] => 1
> hist_entry__annotate: filename=/lib/modules/2.6.35-rc1/build/vmlinux, sym=memcpy, start=0xffffffff811ea690, end=0xffffffff811ea730
> annotating [0x187e770] /lib/modules/2.6.35-rc1/build/vmlinux : [0x19b1f70]                         memcpy
> Executing: objdump --start-address=0xffffffff811ea690 --stop-address=0xffffffff811ea730 -dS /lib/modules/2.6.35-rc1/build/vmlinux|grep -v /lib/modules/2.6.35-rc1/build/vmlinux|expand
> [root@emilia ~]# 
> 
> I'm removing all vmlinux from the path so that I can reproduce what you see.

[root@emilia ~]# mv /lib/modules/2.6.35-rc1/build/vmlinux /lib/modules/2.6.35-rc1/build/vmlinux.OFF
[root@emilia ~]# perf annotate -vvv memcpy > /dev/null
build id event received for [kernel.kallsyms]: 310920b54cbbf242dbfa09052f652806d2c73821
build id event received for /lib64/libtinfo.so.5.7: cd9da7b5b1fcb25ee6b3762bb9fe62f782590fd5
Looking at the vmlinux_path (6 entries long)
No build_id in /root/.debug/.build-id/31/0920b54cbbf242dbfa09052f652806d2c73821, ignoring it
No build_id in vmlinux, ignoring it
No build_id in /boot/vmlinux, ignoring it
No build_id in /boot/vmlinux-2.6.35-rc1, ignoring it
No build_id in /lib/modules/2.6.35-rc1/build/vmlinux, ignoring it
No build_id in /usr/lib/debug/lib/modules/2.6.35-rc1/vmlinux, ignoring it
Using /proc/kallsyms for symbols
[root@emilia ~]# 
[root@emilia ~]# vi ~/.perfconfig
[root@emilia ~]# cat ~/.perfconfig
[tui]

	report = on
	annotate = off
[root@emilia ~]# perf annotate memcpy
[root@emilia ~]# perf annotate memcpy
[root@emilia ~]# perf annotate -k vmlinux memcpy
[kernel.kallsyms] with build id 310920b54cbbf242dbfa09052f652806d2c73821 not found, continuing without symbols

	Yeah, these error messages suckz, will work on having proper messages
for these cases :-\

- Arnaldo
