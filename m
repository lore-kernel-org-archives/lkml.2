Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751Ab2D0RAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:00:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54575 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756764Ab2D0RAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:00:07 -0400
Date: Fri, 27 Apr 2012 17:59:19 +0100
From: Will Deacon <will.deacon@arm.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] asm-generic: io: don't perform swab during {in,out}
 string functions
Message-ID: <20120427165919.GD14743@mudshark.cambridge.arm.com>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com>
 <1335523376-14695-2-git-send-email-will.deacon@arm.com>
 <201204271219.00596.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204271219.00596.vapier@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 05:18:58PM +0100, Mike Frysinger wrote:
> On Friday 27 April 2012 06:42:56 Will Deacon wrote:
> > The {in,out}s{b,w,l} functions are designed to operate on a stream of
> > bytes and therefore should not perform any byte-swapping, regardless of
> > the CPU byte order.
> 
> says who ?  where's the agreed upon documentation for this ?

This specific case is actually documented in Linux Device Drivers, but I
appreciate that it's not especially clear. I had some offline discussion
with Arnd where we agreed on this -- it also means that asm-generic/io.h
matches what is done by bi-endian architectures providing their own
accessors.

Will
