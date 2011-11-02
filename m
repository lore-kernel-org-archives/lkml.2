Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab1KBKEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:04:53 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:50358 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1KBKEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:04:48 -0400
Message-ID: <1320228239.2776.14.camel@br98xy6r>
Subject: Re: [PATCH v2] kdump: Fix crash_kexec - smp_send_stop race in panic
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Don Zickus <dzickus@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 02 Nov 2011 11:03:59 +0100
In-Reply-To: <20111101200420.GN17705@redhat.com>
References: <1319639649.3321.11.camel@br98xy6r>
	 <20111028161143.e5ebf617.akpm@linux-foundation.org>
	 <1320055036.2796.8.camel@br98xy6r>
	 <20111031033948.a0edb7f3.akpm@linux-foundation.org>
	 <1320064459.2796.26.camel@br98xy6r> <20111101200420.GN17705@redhat.com>
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 16:04 -0400, Don Zickus wrote:
> On Mon, Oct 31, 2011 at 01:34:19PM +0100, Michael Holzheu wrote:
> > Hello Andrew, hello linux-arch,
> > 
> > > Well OK.  Maybe some architectures do have this problem - who would
> > > notice?  If that is the case, we just made the failure cases much more
> > > common.  Could you check, please?
> > 
> > @linux-arch: 
> > 
> > This patch introduces a spinlock to prevent parallel execution of the
> > panic code. Andrew pointed out that this might be a problem for
> > architectures that can't do smp_send_stop() on remote CPUs that have
> > interrupts disabled. When irq-disabled CPUs execute panic() in parallel,
> > we then would have looping CPUs.
> 
> x86 has such problem and I posted a patch recently to fix it
> 
> https://lkml.org/lkml/2011/10/13/426

Ok good, so with this patch x86 has no problem with the panic spinlock.
Anybody else?

Instead of introducing the panic lock, as an alternative we could move
smp_send_stop() to the beginning of panic(). Eric told me that the
function is currently "insufficiently reliable" for that, but perhaps we
could make it more reliable.

Michael



