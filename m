Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab0FQPR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:17:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab0FQPRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:17:25 -0400
Date: Thu, 17 Jun 2010 12:17:05 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Anton Blanchard <anton@samba.org>
Cc: Eric B Munson <ebmunson@us.ibm.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       paulus@samba.org, linux-kernel@vger.kernel.org, amodra@gmail.com
Subject: Re: [PATCH] perf lookup of ppc64 symbols
Message-ID: <20100617151705.GD4217@ghostprotocols.net>
References: <1276523793-15422-1-git-send-email-ebmunson@us.ibm.com> <20100617144608.GS28295@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617144608.GS28295@kryten>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 18, 2010 at 12:46:08AM +1000, Anton Blanchard escreveu:
> 
> Hi,
> 
> > Currently symbol resolution does not work for 64-bit programs
> > using perf.  For this to work perf needs to lookup symbol names in
> > the OPD.  This patch adds this functionality.  The OPD data is
> > used to find symbol names when available.
> 
> To clarify, this is an issue with 64bit architectures that use function
> descriptors (eg ppc64). The problem is that a symbol doesn't point to a text
> address, it points to a data area that contains (amongst other things) a
> pointer to the text address.
> 
> We look for a section called ".opd" which is the function descriptor
> area. To create the full symbol table, when we see a symbol in the function
> descriptor section we load the first pointer and use that as the text
> address. The only tricky part here is working out which section the
> text address is in. Right now we have a loop which is sub optimal:

I'll update the comment in Eric's patch and apply this to perf/core, for
.36, we can optimize this later, correctness first :-)

- Arnaldo
