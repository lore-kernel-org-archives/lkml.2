Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1HCKlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:41:11 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:53560 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab1HCKlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:41:07 -0400
Subject: Re: [patch v2 03/10] kdump: Add size to elfcorehdr kernel parameter
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110802185501.GG6399@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
	 <20110727125807.853426542@linux.vnet.ibm.com>
	 <20110801203607.GI3805@redhat.com> <1312276087.4881.24.camel@br98xy6r>
	 <20110802185501.GG6399@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 03 Aug 2011 12:40:44 +0200
Message-ID: <1312368044.3783.39.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Tue, 2011-08-02 at 14:55 -0400, Vivek Goyal wrote:
> On Tue, Aug 02, 2011 at 11:08:07AM +0200, Michael Holzheu wrote:
> > Hello Vivek,
> > 
> > > Generally vmcore parses elfcorehdr to figure out the sizes. kexec-tools
> > > knows about it and relevant memory is excluded from second kernel's map
> > > with the help of memmap= command line option.
> > > 
> > > Can you please mention that this is only s390 specific requirement as
> > > there are no memmap= equivalent options and somehow dump tools wants
> > > to know how big the elf header size is?
> > 
> > I updated the description: 
> > 
> > Currently only the address of the pre-allocated ELF header is passed with
> > the elfcorehdr= kernel parameter. In order to reserve memory for the header
> > in the 2nd kernel also the size is required. Current kdump architecture
> > backends use different methods to do that, e.g. x86 uses the memmap= kernel
> > parameter. On s390 there is no easy way to transfer this information.
> > Therefore the elfcorehdr kernel parameter is extended to also pass the size.
> > This now can also be used as standard mechanism by all future kdump
> > architecture backends.
> > 
> > The syntax of the kernel parameter is extended as follows:
> > 
> > elfcorehdr=[size[KMG]@]offset[KMG]
> > 
> > This change is backward compatible because elfcorehdr=size is still allowed.
> > 
> > Ok?
> 
> Yes, this one looks ok.

With that description change: Do I get an "Acked-by" for this patch from
you?

Michael

