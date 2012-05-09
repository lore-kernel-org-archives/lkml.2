Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276Ab2EIQhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:37:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758288Ab2EIQhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:37:09 -0400
Date: Wed, 9 May 2012 19:36:42 +0300
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
Message-ID: <20120509163641.GA21344@redhat.com>
References: <20120509134528.GA18044@redhat.com>
 <4FAA7939.6040706@zytor.com>
 <20120509154734.GB20867@redhat.com>
 <4FAA9A49.8080900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAA9A49.8080900@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 09:24:41AM -0700, H. Peter Anvin wrote:
> On 05/09/2012 08:47 AM, Michael S. Tsirkin wrote:
> > 
> > By the way, clear_bit on x86 does not seem to contain
> > an optimization barrier - is my reading correct?
> > Lock prefix does not affect the compiler, right?
> 
> Yes, as it clearly states in the comment:
> 
>  * clear_bit() is atomic and may not be reordered.  However, it does
>  * not contain a memory barrier, so if it is used for locking purposes,
>  * you should call smp_mb__before_clear_bit() and/or
> smp_mb__after_clear_bit()
>  * in order to ensure changes are visible on other processors.
> 
> There is clear_bit_unlock() which has the barrier semantics.
> 
> 	-hpa

Well it talks about a memory barrier, not an
optimization barrier.

If compiler reorders code, changes will appear in
the wrong order on the current processor,
not just on other processors, no?

Sorry if I'm confused about this point, this is
what Documentation/atomic_ops.txt made me believe:
<quote>
	For example consider the following code:

		while (a > 0)
			do_something();

	If the compiler can prove that do_something() does not store to the
	variable a, then the compiler is within its rights transforming this to
	the following:

		tmp = a;
		if (a > 0)
			for (;;)
				do_something();

</quote>
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
