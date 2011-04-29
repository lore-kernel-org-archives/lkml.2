Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab1D2IA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:00:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50256 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab1D2IAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:00:24 -0400
Date: Fri, 29 Apr 2011 08:59:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jerome Glisse <j.glisse@gmail.com>, linaro-mm-sig@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110429075958.GV17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <201104281428.56780.arnd@arndb.de> <20110428131531.GK17290@n2100.arm.linux.org.uk> <201104281629.52863.arnd@arndb.de> <20110428143440.GP17290@n2100.arm.linux.org.uk> <BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com> <1304036962.2513.202.camel@pasglop> <4DBA5194.7080609@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBA5194.7080609@vmware.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 07:50:12AM +0200, Thomas Hellstrom wrote:
> However, we should be able to construct a completely generic api around  
> these operations, and for architectures that don't support them we need  
> to determine
>
> a)  Whether we want to support them anyway (IIRC the problem with PPC is  
> that the linear kernel map has huge tlb entries that are very  
> inefficient to break up?)

That same issue applies to ARM too - you'd need to stop the entire
machine, rewrite all processes page tables, flush tlbs, and only
then restart.  Otherwise there's the possibility of ending up with
conflicting types of TLB entries, and I'm not sure what the effect
of having two matching TLB entries for the same address would be.

> b)  Whether they are needed at all on the particular architecture. The  
> Intel x86 spec is, (according to AMD), supposed to forbid conflicting  
> caching attributes, but the Intel graphics guys use them for GEM. PPC  
> appears not to need it.

Some versions of the architecture manual say that having multiple
mappings with differing attributes is unpredictable.
