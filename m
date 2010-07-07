Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab0GGWfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:35:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52591 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab0GGWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:34:59 -0400
Date: Wed, 7 Jul 2010 23:34:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Anfei Zhou <anfei.zhou@gmail.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [patch 071/149] ARM: 6166/1: Proper prefetch abort handling on
	pre-ARMv6
Message-ID: <20100707223417.GA22673@n2100.arm.linux.org.uk>
References: <20100701173212.785441106@clark.site> <20100701221420.GA10481@shutemov.name> <20100701221728.GA12187@suse.de> <20100701222541.GB10481@shutemov.name> <20100701224837.GA27389@flint.arm.linux.org.uk> <20100701225911.GC10481@shutemov.name> <20100701231207.GB27389@flint.arm.linux.org.uk> <20100706130618.GA14177@shutemov.name> <20100706225815.GA21834@flint.arm.linux.org.uk> <20100707085601.GA18732@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707085601.GA18732@shutemov.name>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 11:56:01AM +0300, Kirill A. Shutemov wrote:
> But it seems that the problem is more global. Potentially, any of
> pmd_none() check may produce false results. I don't see an easy way to fix
> it.

It isn't.  We normally guarantee that we always fill on both L1 entries.
The only exception is for the mappings specified via create_mapping()
which is used for the static platform mappings.

> Does Linux VM still expect one PTE table per page?

Yes, and as far as I can see probably always will.  Hence why we need
to put two L1 entries in one page and lie to the kernel about the sizes
of the hardware entries.
