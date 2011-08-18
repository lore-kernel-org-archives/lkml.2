Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1HRIsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:48:23 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:33972 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab1HRIsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:48:17 -0400
Subject: Re: [patch v3 3/8] kdump: Add size to elfcorehdr kernel parameter
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110817210554.GD14813@redhat.com>
References: <20110812134849.748973593@linux.vnet.ibm.com>
	 <20110812134907.325789470@linux.vnet.ibm.com>
	 <20110817210554.GD14813@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 18 Aug 2011 10:47:59 +0200
Message-ID: <1313657279.3528.6.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Wed, 2011-08-17 at 17:05 -0400, Vivek Goyal wrote:
> On Fri, Aug 12, 2011 at 03:48:52PM +0200, Michael Holzheu wrote:
> > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > 
> > Currently only the address of the pre-allocated ELF header is passed with
> > the elfcorehdr= kernel parameter. In order to reserve memory for the header
> > in the 2nd kernel also the size is required. Current kdump architecture
> > backends use different methods to do that, e.g. x86 uses the memmap= kernel
> > parameter. On s390 there is no easy way to transfer this information.
> > Therefore the elfcorehdr kernel parameter is extended to also pass the size.
> > This now can also be used as standard mechanism by all future kdump
> > architecture backends.
> 
> Michael,
> 
> This version looks much better. A quick question. Who parses this
> elfcorehdr= parameter in s390 and how do we make sure these headers are not
> overwritten.

The parameter is parsed in common code (kernel/crash_dump.c) in
early_param("elfcorehdr", setup_elfcorehdr), as it is already currently
the case.

We use address and size of the ELF core header to reserve the header
memory in setup.c (see patch #8):

+#ifdef CONFIG_CRASH_DUMP
+       if (is_kdump_kernel())
+               reserve_bootmem(elfcorehdr_addr - OLDMEM_BASE,
+                               PAGE_ALIGN(elfcorehdr_size), BOOTMEM_DEFAULT);
+#endif

Does that answer your question?

Michael

