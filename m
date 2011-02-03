Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1BCUZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:25:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637Ab1BCUZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:25:48 -0500
Date: Thu, 3 Feb 2011 12:25:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH - resend] memblock: Don't adjust size in
 memblock_find_base()
Message-Id: <20110203122505.8369330f.akpm@linux-foundation.org>
In-Reply-To: <4D43615B.9060203@kernel.org>
References: <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com>
	<alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com>
	<4D1BD928.50701@zytor.com>
	<alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>
	<4D1BE615.4000700@zytor.com>
	<20101230090648.GB7306@elte.hu>
	<20101230102815.GA29822@elte.hu>
	<20101230103002.GA30020@elte.hu>
	<AANLkTimeqrLzDuqBoSvmkSJWMc7u3PeRf37vjzBca2Lh@mail.gmail.com>
	<AANLkTimpyRXS9dNFATh4GqtA46uynutAvK7Qb5S7WPFO@mail.gmail.com>
	<20110105134434.GA22816@elte.hu>
	<4D43615B.9060203@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 16:37:47 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> While applying patch to use memblock to find aperture for 64bit x86.
> Ingo found system with 1g + force_iommu
> 
> > No AGP bridge found
> > Node 0: aperture @ 38000000 size 32 MB
> > Aperture pointing to e820 RAM. Ignoring.
> > Your BIOS doesn't leave a aperture memory hole
> > Please enable the IOMMU option in the BIOS setup
> > This costs you 64 MB of RAM
> > Cannot allocate aperture memory hole (0,65536K)

I'm trying to work out if we should backport this fix into earlier
kernels and as is often the case, I wasn't given enough information.

What are the end-user visible effects of this?  The kernel cannot use
the AGP bridge?  64MB of RAM wasted?  Something else?

