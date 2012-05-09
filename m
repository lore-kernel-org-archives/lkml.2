Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344Ab2EIQzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:55:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760304Ab2EIQzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:55:37 -0400
Date: Wed, 9 May 2012 19:55:16 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] bitops: add _local bitops
Message-ID: <20120509165515.GA21461@redhat.com>
References: <20120509134528.GA18044@redhat.com>
 <4FAA7939.6040706@zytor.com>
 <20120509154734.GB20867@redhat.com>
 <4FAA9A49.8080900@zytor.com>
 <20120509163641.GA21344@redhat.com>
 <4FAA9F45.1080608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAA9F45.1080608@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 09:45:57AM -0700, H. Peter Anvin wrote:
> On 05/09/2012 09:36 AM, Michael S. Tsirkin wrote:
> > 
> > Well it talks about a memory barrier, not an
> > optimization barrier.
> > 
> 
> Same thing.

I see. So it really should say 'any barrier', right?
Documentation/atomic_ops.txt goes to great length
to distinguish between the two and we probably
should not confuse things.

> > If compiler reorders code, changes will appear in
> > the wrong order on the current processor,
> > not just on other processors, no?
> 
> Yes.

So this seems to contradict what the comment says:

	clear_bit() is atomic and may not be reordered.
and you say compiler *can* reorder it, and below

 you should call smp_mb__before_clear_bit() and/or * smp_mb__after_clear_bit()
 in order to ensure changes are visible on other processors.

and in fact this is not enough, you also need to call
barrier() to ensure changes are visible on the same
processor in the correct order.

> For your _local I would just copy the atomic bitops but remote the locks
> in most cases.
> 
> 	-hpa

Right, I sent v2 that does exactly this.

My question about documentation for change_bit
is an unrelated one: to me, it looks like the documentation for
change_bit does not match the implementation, or at least is somewhat
confusing.

> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
