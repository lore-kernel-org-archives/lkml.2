Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab1ENMqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 08:46:11 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34994 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab1ENMqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 08:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=oH2P4KzHDTBHZMFuxOkBiR5C+IG8RROX3zQciCKn9DWr3hJVHvHQim3q+6jQrwkABS
         6yn6B9usBSSy96FxKQ4nnOd1HH2g80wRn2YIMtuckC8JmIndBxs4TbpiSdrmdwzfbtkr
         hCmqqVxz2XgVu4Qf2EAhLk0/uG30NQc8Y36Y0=
MIME-Version: 1.0
In-Reply-To: <20110513204530.GF8950@ghostprotocols.net>
References: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
 <4DCD4FC5.8020608@gmail.com> <20110513154410.GA6373@elte.hu>
 <BANLkTi=UKJ2Ztkcui_+8UHF16b_8mTvpnA@mail.gmail.com> <20110513204530.GF8950@ghostprotocols.net>
From: Wim Heirman <wim@heirman.net>
Date: Sat, 14 May 2011 14:45:44 +0200
X-Google-Sender-Auth: zx2waKI9vwdFkNqBkl63baNuFVA
Message-ID: <BANLkTimoJsi64AWxn8Y_AZ+B1+nM=M1NgA@mail.gmail.com>
Subject: Re: perf-stat per thread results
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Brice Goglin <Brice.Goglin@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 May 2011 22:45, Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> Em Fri, May 13, 2011 at 10:32:58PM +0200, Wim Heirman escreveu:
>> > It's supposed to do that if --stat is specified, and it used to work - see this
>> > commit:
>
>> >  8d51327090ac: perf report: Fix and improve the displaying of per-thread event counters
>
>> > and the output there:
>> >
>> >     #  PID   TID  cache-misses  cache-references
>> >       4658  4659        495581           3238779
>> >       4658  4662        498246           3236823
>> >       4658  4663        499531           3243162
>
>> > which appears to be roughly what Wim is asking for, AFAICT.
>
>> Thanks, this is exactly what I'm looking for. In 2.6.32 (Ubuntu 10.04)
>> it works, although if I use --pid rather than the -- <command> variant
>> the first thread seams to be missing. In 2.6.38 (Ubuntu 11.04) the
>> first thread is missing in both use cases, and I get one column per
>> processor (which in itself is fine).
>
> Can you try after applying the patches in this message:
>
> http://marc.info/?l=linux-kernel&m=130385067430510&w=2
>
> and report your results?

Sorry, no improvement.

$ ./perf record -e cycles --stat -- ./fft -p4 -m24 && ./perf report
--thread | tail
[ perf record: Woken up 5 times to write data ]
[ perf record: Captured and wrote 1.198 MB perf.data (~52331 samples) ]
# PID  TID   cpu-clock
  954  958  8067423322
  954  957  6761317556
  954  956  6006327147

$ ls /proc/$(pidof fft)/task
954  956  957  958
