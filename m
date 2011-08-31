Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1HaFfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 01:35:00 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34566
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758Ab1HaFe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 01:34:58 -0400
Date: Wed, 31 Aug 2011 01:34:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeremy Allison <jra@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110831053429.GA13219@infradead.org>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
 <CAAK6Zt0Sh1GdEOb-tNf2FGXJs=e1Jbcqew13R_GdTqrv6vW97w@mail.gmail.com>
 <x49k49uk2ox.fsf@segfault.boston.devel.redhat.com>
 <4E5D5817.6040704@kernel.dk>
 <CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com>
 <4E5D64E8.7000102@kernel.dk>
 <20110830154157.d802d097.akpm@linux-foundation.org>
 <CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com>
 <20110830155438.bc31ab99.akpm@linux-foundation.org>
 <20110830230342.GB16326@samba2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830230342.GB16326@samba2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 04:03:42PM -0700, Jeremy Allison wrote:
> I have often wondered if this is actually the case ? I created
> my own glibc with a patches AIO that removed this restriction
> (thus had multiple outstanding threads on a single fd). In testing
> I saw a dramatic increase in performance (2x speedup) but then
> testing with use in actual code (Samba smbd) it made the client
> throughput *worse*. I never got to the bottom of this and so
> didn't submit my fixes to glibc.
> 
> Any ideas if this is still the case ? Or comments on why glibc
> insists on only one outstanding request per fd ? Is this really
> needed for kernel performance ?

At least for writes you'll simply have multiple requests blocking on
i_mutex.

