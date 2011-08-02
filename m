Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1HBJIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:08:37 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:43525 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1HBJIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:08:31 -0400
Subject: Re: [patch v2 03/10] kdump: Add size to elfcorehdr kernel parameter
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110801203607.GI3805@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
	 <20110727125807.853426542@linux.vnet.ibm.com>
	 <20110801203607.GI3805@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 02 Aug 2011 11:08:07 +0200
Message-ID: <1312276087.4881.24.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

#On Mon, 2011-08-01 at 16:36 -0400, Vivek Goyal wrote: 
> On Wed, Jul 27, 2011 at 02:55:07PM +0200, Michael Holzheu wrote:
> > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > 
> > Currently only the address of the pre-allocated ELF header is passed with
> > the elfcorehdr= kernel parameter. In order to reserve memory for the header
> > in the 2nd kernel also the size is required. To pass the size with this
> > patch the syntax of the kernel parameter is extended as follows:
> > 
> > elfcorehdr=[size[KMG]@]offset[KMG]
> > 
> > This change is backward compatible because elfcorehdr=size is still allowed.
> 
> Generally vmcore parses elfcorehdr to figure out the sizes. kexec-tools
> knows about it and relevant memory is excluded from second kernel's map
> with the help of memmap= command line option.
> 
> Can you please mention that this is only s390 specific requirement as
> there are no memmap= equivalent options and somehow dump tools wants
> to know how big the elf header size is?

I updated the description: 

Currently only the address of the pre-allocated ELF header is passed with
the elfcorehdr= kernel parameter. In order to reserve memory for the header
in the 2nd kernel also the size is required. Current kdump architecture
backends use different methods to do that, e.g. x86 uses the memmap= kernel
parameter. On s390 there is no easy way to transfer this information.
Therefore the elfcorehdr kernel parameter is extended to also pass the size.
This now can also be used as standard mechanism by all future kdump
architecture backends.

The syntax of the kernel parameter is extended as follows:

elfcorehdr=[size[KMG]@]offset[KMG]

This change is backward compatible because elfcorehdr=size is still allowed.

Ok?

Michael

