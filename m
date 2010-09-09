Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0IIRms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:42:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35185 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab0IIRmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P8lEs3NzqP1Mi/vAOR/dmPK3uCrMDZw+U8pApjx8JUkXptN57p0cEQZ7D9AFiYesbS
         nb+gBwTjyl6/SVET1ZbmMsftBoztMP6O8NDbUJVLFefW3KHzkGpU2F4beAbRdb1R3Vll
         R16kzCaRlulsTfLDow8nYHT12wkxe8Z0hJRDE=
MIME-Version: 1.0
In-Reply-To: <20100909144106.GC4155@ghostprotocols.net>
References: <20100909132057.GA5259@nowhere>
	<20100909144106.GC4155@ghostprotocols.net>
Date: Thu, 9 Sep 2010 19:42:44 +0200
Message-ID: <AANLkTintNLXNYaZ0UjjUPkAEyq6Rf9psM80+gn8Jk2mK@mail.gmail.com>
Subject: Re: perf events over (net) console?
From: Harald Gustafsson <hgu1972@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Song Yuan <song.yuan@ericsson.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/9 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> Isn't this what Tom Zanussi's live mode, that we have already special
> casing 'perf record -' does?

> Harald, can you please take a look at the comment for these commits:
>
> commit 454c407ec17a0c63e4023ac0877d687945a7df4a
> Author: Tom Zanussi <tzanussi@gmail.com>
> Date:   Sat May 1 01:41:20 2010 -0500
>
>    perf: add perf-inject builtin
>
> commit 529870e37473a9fc609078f03cc5b4148cf06a87
> Author: Tom Zanussi <tzanussi@gmail.com>
> Date:   Thu Apr 1 23:59:16 2010 -0500
>
>    perf record: Introduce special handling for pipe output
>
> commit 8dc58101f2c838355d44402aa77646649d10dbec
> Author: Tom Zanussi <tzanussi@gmail.com>
> Date:   Thu Apr 1 23:59:15 2010 -0500
>
>    perf: Add pipe-specific header read/write and event processing code
>
> Using live mode you can stream to a perf.data for later analisys or do
> it live, piping it to trace scripts, etc.

I took a quick look and it seems promising, thanks for the info, I'll
do some tests tomorrow and get back with some results.

/Harald

> Doing it using splice, talking directly to an in kernel mini-server, etc
> are all optimizations that we should think about, but if you can try
> using the live mode and see if it is ok, that would be good.
>
> A mini binary with just record can come in handy if you like and should
> be rather easy to build, please let me know if you think it is a good
> idea and if you need help, lemme know.
>
> - Arnaldo
>
