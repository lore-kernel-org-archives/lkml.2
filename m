Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0HXLpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 07:45:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62023 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab0HXLpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 07:45:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 2/3 RESEND] ptrace: cleanup address space conversion on ptrace_request()
Date: Tue, 24 Aug 2010 13:45:06 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
References: <201008222206.18523.arnd@arndb.de> <20100823162105.GA19164@infradead.org> <1282581489.1659.13.camel@leonhard>
In-Reply-To: <1282581489.1659.13.camel@leonhard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008241345.06507.arnd@arndb.de>
X-Provags-ID: V02:K0:Bj8+6CivndAcszQxbzBHptPhq0PWh5y6CpspMQ/B2H6
 AhsJz4vxA9ryiy7E+tJuLetZKEPQziTBGn6cxOyU+wSPxd4Pfw
 Pt+M6UNXbEd1peLhUqGl+ttX2Kkv4PTv/ekWVHrU9obKDWknvt
 REg/4RsBuXypWyMyd48mLB6bu1/+O86WeCOOAvnnvN5MtCVQtT
 G7GDuiLlr0SHk4FSfrnOA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 August 2010, Namhyung Kim wrote:
> But removing __force results in following sparse warning:
> 
>  ptrace.c:567:40: warning: cast adds address space to expression
> (<asn:1>)

The problem is that ptrace takes a 'long' argument, not 'unsigned long'.
Sparse complains about adding address spaces in all casts except those
from/to unsigned long, which we often use as an opaque token that can
fit anything.

I don't think we ever rely on 'data' being signed, and user space
sees it as 'void *' anyway, so it should be possible to just turn
it into 'unsigned long'.

	Arnd
