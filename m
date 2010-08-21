Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0HURYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 13:24:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab0HURYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 13:24:48 -0400
Date: Sat, 21 Aug 2010 14:24:33 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Subject: Re: [PATCH] perf tools: Fix linking errors with --as-needed flag
Message-ID: <20100821172433.GF2973@ghostprotocols.net>
References: <1279449937-29115-1-git-send-email-ozan@pardus.org.tr> <4C42DFC0.1090708@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C42DFC0.1090708@pardus.org.tr>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jul 18, 2010 at 02:04:32PM +0300, Ozan Çağlayan escreveu:
> On 18.07.2010 13:45, Ozan Çağlayan wrote:
> > External shared libraries should never be appended to the LDFLAGS as
> > this messes the linking order. As EXTLIBS collects those libraries,
> > it seems that perl and python libraries  should also be appended
> > to EXTLIBS.
> > 
> > Also fix the broken linking order.
> 
> Hm actually the PERL_EMBED_LDOPTS may contain LDFLAGS and LIBADD according
> to distribution's perl package configuration's goodness/badness. On my system
> the return value is crap which bloats the linking process:
> 
>  -rdynamic -Wl,-rpath,/usr/lib/perl5/5.10.1/i686-linux-thread-multi/CORE  -fstack-protector -L/usr/local/lib  -L/usr/lib/perl5/5.10.1/i686-linux-thread-multi/CORE -lperl -lpthread -lnsl -ldl -lm -lcrypt -lutil -lc
> 
> PYTHON_EMBED_LDOPTS evaluates python-config --ldflags and adds these to 
> ALL_LDFLAGS. (--libs and --ldflags are synonyms for python-config). According
> to python-config this code *never* returns LDFLAGS so it's safe to put them in
> EXTLIBS.
> 
> So the cure may be more than this patch for perl stuff, but at least it fixes my
> linking problems with -Wl, --as-needed.

Can you refresh this patch? I had it in the back of my mind, remembered
it when considering a similar patch by Kirill, but his covers just the
python case.

Tom, can you please check Ozan's and Kirill's patches and tell me if I
can stick your Acked-by to them?

I'll CC you on the Kirill patch on private cover.

- Arnaldo
