Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab0GRLEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 07:04:38 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:40038 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab0GRLEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 07:04:37 -0400
Message-ID: <4C42DFC0.1090708@pardus.org.tr>
Date: Sun, 18 Jul 2010 14:04:32 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: acme@redhat.com, mst@redhat.com, mingo@elte.hu
Subject: Re: [PATCH] perf tools: Fix linking errors with --as-needed flag
References: <1279449937-29115-1-git-send-email-ozan@pardus.org.tr>
In-Reply-To: <1279449937-29115-1-git-send-email-ozan@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.07.2010 13:45, Ozan Çağlayan wrote:
> External shared libraries should never be appended to the LDFLAGS as
> this messes the linking order. As EXTLIBS collects those libraries,
> it seems that perl and python libraries  should also be appended
> to EXTLIBS.
> 
> Also fix the broken linking order.

Hm actually the PERL_EMBED_LDOPTS may contain LDFLAGS and LIBADD according
to distribution's perl package configuration's goodness/badness. On my system
the return value is crap which bloats the linking process:

 -rdynamic -Wl,-rpath,/usr/lib/perl5/5.10.1/i686-linux-thread-multi/CORE  -fstack-protector -L/usr/local/lib  -L/usr/lib/perl5/5.10.1/i686-linux-thread-multi/CORE -lperl -lpthread -lnsl -ldl -lm -lcrypt -lutil -lc

PYTHON_EMBED_LDOPTS evaluates python-config --ldflags and adds these to 
ALL_LDFLAGS. (--libs and --ldflags are synonyms for python-config). According
to python-config this code *never* returns LDFLAGS so it's safe to put them in
EXTLIBS.

So the cure may be more than this patch for perl stuff, but at least it fixes my
linking problems with -Wl, --as-needed.

