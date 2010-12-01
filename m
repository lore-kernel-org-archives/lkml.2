Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0LARYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:24:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62871 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0LARYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:24:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=vZ0+fnXqw6fmVfYj1zaeUTdguEWIyrkW1ChifzcD3Vjt0Enri74PYhfNs5WAW2g/Of
         IQSCwDan0otK9iC1pWp6dUVJ1nUVzOwOn5aGlK0NVixmKFkuDa2K0St+BV7C2zevvwRQ
         7BIZ4Napk7gkchUhiwfnJE6Yk34E29ohk7n64=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20101201170647.GC24641@ghostprotocols.net>
References: <4cf67197.41e9d80a.7d37.08aa@mx.google.com>
	<20101201170647.GC24641@ghostprotocols.net>
Date: Wed, 1 Dec 2010 18:24:46 +0100
Message-ID: <AANLkTi=C0FX2f-SS65p9nXWB8ogNqtgJVa8e+N6C32+5@mail.gmail.com>
Subject: Re: [PATCH] perf: add csv-style output to perf stat
From: stephane eranian <eranian@googlemail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        robert.richter@amd.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 6:06 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Wed, Dec 01, 2010 at 05:00:05PM +0200, Stephane Eranian escreveu:
>> This patch adds an option (-x) to print counts using a CSV-style output.
>> This makes it very easy to import counts directly into your favorite
>> spreadsheet without having to write scripts.
>
> I was about to work on this :-) I think we should use the same option
> 'report' uses:
>
>    OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
>               "separator for columns, no spaces will be added between "
>               "columns '.' is reserved."),
>
> [root@mica ~]# perf record -F 100000 ls > /dev/null
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.041 MB perf.data (~1798 samples) ]
> [root@mica ~]# perf report --stdio -t, | head -10
> # Events: 1K cycles
> #
> # Overhead,Command,Shared Object,Symbol
> 52.57,    ls,libc-2.5.so      ,[.] __GI___strcoll_l
> 3.97,    ls,ls               ,[.]             24a2
> 3.48,    ls,libc-2.5.so      ,[.] __GI_strlen
> 2.33,    ls,[ext3]           ,[k] ext3fs_dirhash
> 2.21,    ls,[kernel.kallsyms],[k] clear_page_c
> 1.94,    ls,[ext3]           ,[k] ext3_htree_store_dirent
> 1.81,    ls,[kernel.kallsyms],[k] rt_spin_lock_fastunlock
> [root@mica ~]#
>
> Spaces are being added, gack, will fix. Tried to use the same option letter and
> long option name as in 'sort':
>
>       -t, --field-separator=SEP
>              use SEP instead of non-blank to blank transition
>
> But then 'perf stat' already uses -t for --tid, so in 'stat' we would have to
> use '-x'/--field-separator.
>
Fine with me.
I can re-spin the patch to add the flexibility to name your SEP.

> Argh, I think we should stop using short options, only assigning something when
> it gets from seldomly used to just before making it the default 8-)

I tend to use the short options....
