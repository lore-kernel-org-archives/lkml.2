Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0KERLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:11:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47316 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0KERLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:11:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KkON5CG9ma/arVGmORnGouwwcj6t9YIzw5faz1hm/uY/kiaqmqqwAajn1Ub40Xi1Dh
         ChJMKFqnGAksO8a3JibS+WUhPb/k7jE/pU2ylOHDY6JZ+NTr2uSnsNzDIkISvGZoo1hr
         K770Rti1oPhVIC44XImGP/YBCaGpkmazWr7Cg=
MIME-Version: 1.0
In-Reply-To: <20101029210824.GB13385@ghostprotocols.net>
References: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<1288381751.1988.13.camel@laptop>
	<20101029210824.GB13385@ghostprotocols.net>
Date: Sat, 6 Nov 2010 02:10:51 +0900
Message-ID: <AANLkTi=imdtoGqZZj69pZCjSdFB5vAD334skSBhVEFjd@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf bench: port memcpy_64.S to perf bench
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, "Ma Ling:" <ling.ma@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>, Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 06:08, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Fri, Oct 29, 2010 at 09:49:11PM +0200, Peter Zijlstra escreveu:
>> On Sat, 2010-10-30 at 01:01 +0900, Hitoshi Mitake wrote:
>> > +++ b/arch/x86/lib/memcpy_64.S
>> > @@ -1,10 +1,23 @@
>> >  /* Copyright 2002 Andi Kleen */
>> >
>> > +/*
>> > + * perf bench adoption by Hitoshi Mitake
>> > + * PERF_BENCH means that this file is included from
>> > + * the source files under tools/perf/ for benchmark programs.
>> > + *
>> > + * You don't have to care about PERF_BENCH when
>> > + * you are working on the kernel.
>> > + */
>> > +
>> > +#ifndef PERF_BENCH
>>
>> I don't like littering the actual kernel code with tools/perf/
>> ifdeffery..
>
> Yeah, this kind of problem appeared in the past, we can't use things
> that weren't specifically designed to be shared, the discussion about
> how to properly share things between the kernel and things in tools
> still has to happen.

OK, it seems that I have to consider better solution.
Could you tell me about the past problem for reference?
Your experience must be useful for this case.

-- 
Hitoshi Mitake
h.mitake@gmail.com
