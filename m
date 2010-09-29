Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0I2LzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:55:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60183 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab0I2LzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:55:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
Date: Wed, 29 Sep 2010 13:55:06 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, linasvepstas@gmail.com,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com> <4CA1E809.5010103@tilera.com> <20100929051631.GA8116@infradead.org>
In-Reply-To: <20100929051631.GA8116@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009291355.06512.arnd@arndb.de>
X-Provags-ID: V02:K0:71pYtzL2B+JfmKDvkxxKVgWQnC74Da1u4Kxc721aR5Z
 hJgerAG2p8WUCpqXuA7TXPriHOmu6qpfyr7BXk8sjpmBwkqOrR
 JCN6qM/Y9q6XdCa8dEDOB/bxD2yFfk9j0WkzlEhOE2sO5BEM+/
 Ai0mFLxVrVNT7n4nfEivPH4cH9qYLEmJeTdxTgHbmkCQFRLGF/
 RXQQU/lL/mY0IoQJt/rxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 September 2010, Christoph Hellwig wrote:
> On Tue, Sep 28, 2010 at 09:05:13AM -0400, Chris Metcalf wrote:
> > Another point where I'd appreciate guidance from libc-alpha is the sysctl()
> > and ustat() APIs.  The corresponding system calls are missing from
> > <asm-generic/unistd.h>, since they are deprecated and their functionality
> > is better provided by other means (/proc/sys, fstat).  So I've simply had
> > them return -1 with errno == ENOSYS.  Is there any reason to think they
> > merit more substantial work?  One could imagine baking in some horrible
> > mapping of "integer names" into path components for a sysctl()
> > implementation and reading /proc/sys to provide results, or walking all of
> > the mount points looking for a matching device number to pass a name to
> > fstat(), but I'm not sure it's worth the bloat to the library.
> 
> fstat does not replace ustat.  ustat is a statf-subsystem by dev_t and
> is not replaced by anything.  xfsprogs for example uses it to check if
> a given dev_t is currently mounted.  Please add it to the generic code.
> 

I didn't put it into the generic list because the man page claims

 "ustat() is deprecated and has only been provided for compatibility.
  All new programs should use statfs(2) instead."

I suppose that means we should change the man page as well, right?

	Arnd
