Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1IOIsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 04:48:10 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:45064 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1IOIsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 04:48:08 -0400
Subject: Re: [patch v2 2/2] s390: Add architecture code for unmapping
 crashkernel memory
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@google.com>, ebiederm@xmission.com,
        mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110914182902.GA32658@redhat.com>
References: <20110913132635.063397500@linux.vnet.ibm.com>
	 <20110913132654.157278466@linux.vnet.ibm.com>
	 <20110913145218.659f9e21.akpm@google.com>
	 <1315990708.3367.14.camel@br98xy6r>  <20110914182902.GA32658@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 15 Sep 2011 10:48:03 +0200
Message-ID: <1316076483.3526.4.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek, Andrew,

On Wed, 2011-09-14 at 14:29 -0400, Vivek Goyal wrote:
> On Wed, Sep 14, 2011 at 10:58:28AM +0200, Michael Holzheu wrote:
> > > Why not make this unconditional, for all architectures which support
> > > hugepages?  ie:
> > > 
> > > #ifdef HPAGE_SIZE
> > > #define KEXEC_CRASH_MEM_ALIGN HPAGE_SIZE
> > > #else
> > > #define KEXEC_CRASH_MEM_ALIGN PAGE_SIZE
> > > #endif
> > 
> > > in include/linux/kexec.h?
> > > 
> > > IOW, what are the compromises here?
> > 
> > If we would do it that way, crashkernel memory on architectures that
> > support large pages but do not support unmapping of crashkernel memory
> > would always be aligned to HPAGE_SIZE. But only PAGE_SIZE alignment
> > would be necessary in that case.
> > 
> > If that is acceptable I have no problem to define that unconditional for
> > all architectures. Vivek what do you think?
> 
> As PAGE_SIZE alignment is sufficient for rest of the architecture, I 
> am fine with keeping it in arch dependent files.

Ok fine. So I will resend the two patches including Andrew's
resource_size() fix and keep KEXEC_CRASH_MEM_ALIGN definition
architecture dependent.

Michael

