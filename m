Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab1INS3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:29:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab1INS3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:29:12 -0400
Date: Wed, 14 Sep 2011 14:29:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@google.com>, ebiederm@xmission.com,
        mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2 2/2] s390: Add architecture code for unmapping
 crashkernel memory
Message-ID: <20110914182902.GA32658@redhat.com>
References: <20110913132635.063397500@linux.vnet.ibm.com>
 <20110913132654.157278466@linux.vnet.ibm.com>
 <20110913145218.659f9e21.akpm@google.com>
 <1315990708.3367.14.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315990708.3367.14.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 10:58:28AM +0200, Michael Holzheu wrote:
> Hello Andrew,
> 
> On Tue, 2011-09-13 at 14:52 -0700, Andrew Morton wrote:
> > On Tue, 13 Sep 2011 15:26:37 +0200
> > Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:
> 
> [snip]
> 
> > > --- a/arch/s390/include/asm/kexec.h
> > > +++ b/arch/s390/include/asm/kexec.h
> > > @@ -36,6 +36,9 @@
> > >  /* Allocate one page for the pdp and the second for the code */
> > >  #define KEXEC_CONTROL_PAGE_SIZE 4096
> > >  
> > > +/* Alignment of crashkernel memory */
> > > +#define KEXEC_CRASH_MEM_ALIGN HPAGE_SIZE
> > 
> > Why not make this unconditional, for all architectures which support
> > hugepages?  ie:
> > 
> > #ifdef HPAGE_SIZE
> > #define KEXEC_CRASH_MEM_ALIGN HPAGE_SIZE
> > #else
> > #define KEXEC_CRASH_MEM_ALIGN PAGE_SIZE
> > #endif
> 
> > in include/linux/kexec.h?
> > 
> > IOW, what are the compromises here?
> 
> If we would do it that way, crashkernel memory on architectures that
> support large pages but do not support unmapping of crashkernel memory
> would always be aligned to HPAGE_SIZE. But only PAGE_SIZE alignment
> would be necessary in that case.
> 
> If that is acceptable I have no problem to define that unconditional for
> all architectures. Vivek what do you think?

As PAGE_SIZE alignment is sufficient for rest of the architecture, I 
am fine with keeping it in arch dependent files.

Thanks
Vivek
