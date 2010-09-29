Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab0I2FQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:16:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49915 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0I2FQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:16:35 -0400
Date: Wed, 29 Sep 2010 01:16:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linasvepstas@gmail.com,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
Message-ID: <20100929051631.GA8116@infradead.org>
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com>
 <201009281040.09728.arnd@arndb.de>
 <4CA1E809.5010103@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA1E809.5010103@tilera.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 09:05:13AM -0400, Chris Metcalf wrote:
> Another point where I'd appreciate guidance from libc-alpha is the sysctl()
> and ustat() APIs.  The corresponding system calls are missing from
> <asm-generic/unistd.h>, since they are deprecated and their functionality
> is better provided by other means (/proc/sys, fstat).  So I've simply had
> them return -1 with errno == ENOSYS.  Is there any reason to think they
> merit more substantial work?  One could imagine baking in some horrible
> mapping of "integer names" into path components for a sysctl()
> implementation and reading /proc/sys to provide results, or walking all of
> the mount points looking for a matching device number to pass a name to
> fstat(), but I'm not sure it's worth the bloat to the library.

fstat does not replace ustat.  ustat is a statf-subsystem by dev_t and
is not replaced by anything.  xfsprogs for example uses it to check if
a given dev_t is currently mounted.  Please add it to the generic code.

