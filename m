Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab0LUFNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 00:13:36 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40082 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0LUFNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 00:13:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FhlFONY3bUo4VO6FpbpV/WlKhWuIQS29rShmBlLO7n94/s+smZBPDZGsuoSHbMHANQ
         cNJWL8tNAR8p62JVUWRlw8k8kw1gjyGbr2w/OAF5DSfXyPvyLbuS0y6Ea78F93ziMZBr
         PU4OenmWBLQKPbHVK94Id+wsFCftL6+bCFHWs=
MIME-Version: 1.0
In-Reply-To: <1292892494.8743.76.camel@yhuang-dev>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
	<AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
	<AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
	<AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
	<AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
	<AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
	<4D0BEE1F.7020008@zytor.com>
	<AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
	<AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
	<AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>
	<20101219091752.GA16150@liondog.tnic>
	<AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
	<1292813234.8743.66.camel@yhuang-dev>
	<AANLkTikULE_Jncjs=PkARjZyxb=f+t=4J8g8LQL+L=BZ@mail.gmail.com>
	<1292892494.8743.76.camel@yhuang-dev>
Date: Mon, 20 Dec 2010 21:13:33 -0800
X-Google-Sender-Auth: NAZI4ow2ZPWszT9PbDvBIUlmteo
Message-ID: <AANLkTinBN7QN_c_oyFdpC3vaj9nLEfWCWeeqRCgiEdBW@mail.gmail.com>
Subject: Re: [concept & "good taste" review] persistent store
From: Tony Luck <tony.luck@intel.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 4:48 PM, Huang Ying <ying.huang@intel.com> wrote:
> If persistent storage driver (such as ERST) implements kmsg_dumper by
> themselves, that should be easier to use multiple records for one
> message dumping request.

Or I can build it into the fs/pstore layer. If the record size looks too
small[*], loop writing multiple records (starting with the tail of the buffer,
so that if the persistent store fills up, we are sure to have the stack
back trace and register dump).

-Tony

[*] "Too small" may be an architecture dependent value. Archs
with a large number of registers (like ia64) might need more space
than those with fewer registers.
