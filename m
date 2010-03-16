Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937322Ab0CPJq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:46:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37864 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488Ab0CPJqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:46:25 -0400
Date: Tue, 16 Mar 2010 10:46:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       efault@gmx.de, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH 2/2] perf top: Properly notify the user that vmlinux is
 missing
Message-ID: <20100316094611.GG7961@elte.hu>
References: <1268664418-28328-2-git-send-email-acme@infradead.org>
 <20100315.115526.52182155.davem@davemloft.net>
 <20100315192125.GL6965@ghostprotocols.net>
 <20100315.122605.124976085.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315.122605.124976085.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Arnaldo Carvalho de Melo <acme@infradead.org>
> Date: Mon, 15 Mar 2010 16:21:26 -0300
> 
> > Em Mon, Mar 15, 2010 at 11:55:26AM -0700, David Miller escreveu:
> >> Arnaldo, if perf top can use the kallsyms to do it's normal task, why
> >> can't it use that for symbol annotations too?  Isn't there enough
> >> information available?
> > 
> > Annotation is done by objdump -dS, that requires an executable file to do 
> > ASM annotation, and one with DWARF info for source code annotation. What 
> > we have with /proc/kallsyms is just the symtab.
> 
> Ok, I really think we should link with libopcodes or similar so we can 
> handle the simple assembler annotation case without requiring the kernel 
> image being available.
> 
> That's what I was trying to achieve when I sent you the report
> :-)

i'd really like that to happen - i.e. if we had the kernel (and modules) image 
exposed as a (almost-)standard ELF object via /sys or so.

We already have some aspects of that, via /sys/kernel/notes, but it should be 
done for real. That would also make build-id support less of a hack.

( I'd not include CFI debuginfo in there though - that would be way too large.
  More compressed debuginfo could be included perhaps. )

	Ingo
