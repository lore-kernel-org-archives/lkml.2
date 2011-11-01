Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1KAUEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 16:04:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab1KAUEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 16:04:32 -0400
Date: Tue, 1 Nov 2011 16:04:20 -0400
From: Don Zickus <dzickus@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] kdump: Fix crash_kexec - smp_send_stop race in panic
Message-ID: <20111101200420.GN17705@redhat.com>
References: <1319639649.3321.11.camel@br98xy6r>
 <20111028161143.e5ebf617.akpm@linux-foundation.org>
 <1320055036.2796.8.camel@br98xy6r>
 <20111031033948.a0edb7f3.akpm@linux-foundation.org>
 <1320064459.2796.26.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320064459.2796.26.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 01:34:19PM +0100, Michael Holzheu wrote:
> Hello Andrew, hello linux-arch,
> 
> > Well OK.  Maybe some architectures do have this problem - who would
> > notice?  If that is the case, we just made the failure cases much more
> > common.  Could you check, please?
> 
> @linux-arch: 
> 
> This patch introduces a spinlock to prevent parallel execution of the
> panic code. Andrew pointed out that this might be a problem for
> architectures that can't do smp_send_stop() on remote CPUs that have
> interrupts disabled. When irq-disabled CPUs execute panic() in parallel,
> we then would have looping CPUs.

x86 has such problem and I posted a patch recently to fix it

https://lkml.org/lkml/2011/10/13/426

Cheers,
Don
