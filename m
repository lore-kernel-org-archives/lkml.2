Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554Ab2FVP35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:29:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39705 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762537Ab2FVP3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:29:54 -0400
Date: Fri, 22 Jun 2012 12:29:48 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 5/8] perf symbols: Do not use ELF's symbol binding
 constants
Message-ID: <20120622152948.GI17747@infradead.org>
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
 <1340343462-15556-6-git-send-email-namhyung@kernel.org>
 <20120622124329.GG17747@infradead.org>
 <1340378342.1478.24.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340378342.1478.24.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jun 23, 2012 at 12:19:02AM +0900, Namhyung Kim escreveu:
> 2012-06-22 (금), 09:43 -0300, Arnaldo Carvalho de Melo:
> > Why don't you set STB_GLOBAL, etc to the expected values when libelf is
> > not present? That way no changes need to be made to symbol.c

> > Ditto for GELF_ST_BIND.

> > I.e. keep the subset of libelf.h that we use, providing those
> > definitions on the poor man's libelf.h we should use when the "real
> > thing" is not available.

> I just tried to be independent to (lib)elf as much as possible. And I
> thought that using same macro name might cause a bit of confusion - at
> least for me - so I wanted to use more descriptive and generic name.

> But it's not a big deal. If you insist on using the same name is the
> better way, I can change it.

I think its better to use the well know names, libelf is not just one
implementation, there are several, and we are interested in people
experienced with those APIs to feel at ease when looking at our code :-)

Also as a general practice I try hard to reduce patch size, so
restricting the changes to allow building with an alternative, stripped
down libelf to the stripped down libelf headers seems like a good path
to follow.

- Arnaldo
