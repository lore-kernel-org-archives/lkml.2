Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720Ab0JZKt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:49:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:56286 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759647Ab0JZKty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:49:54 -0400
Subject: Re: linux-next: build warnings after merge of the final tree (mtd
 tree related)
From: David Woodhouse <dwmw2@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288083108.29264.14.camel@macbook.infradead.org>
References: <20101026134959.86b807d1.sfr@canb.auug.org.au>
	 <1288083108.29264.14.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 11:49:40 +0100
Message-ID: <1288090180.29264.26.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 09:51 +0100, David Woodhouse wrote:
> On Tue, 2010-10-26 at 13:49 +1100, Stephen Rothwell wrote:
> > 
> > I am not sure where these came from ... 
> 
> It's a config issue. You have chosen to build NOR flash support.
> 
> NOR flash can be wired up many ways. It could be four 8-bit chips in
> parallel in a 32-bit bus, two 16-bit chips in a 32-bit bus, 2 8-bit
> chips in a 16-bit bus, one 16-bit chip in a 16-bus bus, etc...
> 
> You have elected to support *none* of those configurations. No NOR chip
> support can work.
> 
> You don't get to choose individual geometry options unless you set
> CONFIG_MTD_ADV_OPTIONS -- by default you get a fully versatile driver
> which can cope with anything at runtime.
> 
> I'll build a ppc44x_defconfig and work out what's going wrong. I'd
> expect this kind of thing with randconfig, but not a defconfig.

Fixed by reverting the offending commit:
http://git.infradead.org/mtd-2.6.git/commitdiff/6411bf6cd

Thanks.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

