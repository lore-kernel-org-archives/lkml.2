Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab2EIPH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:07:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab2EIPH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:07:27 -0400
Date: Wed, 9 May 2012 18:06:35 +0300
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
Message-ID: <20120509150635.GA20474@redhat.com>
References: <20120509134528.GA18044@redhat.com>
 <4FAA7939.6040706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAA7939.6040706@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 07:03:37AM -0700, H. Peter Anvin wrote:
> On 05/09/2012 06:45 AM, Michael S. Tsirkin wrote:
> > kvm needs to update some hypervisor variables atomically
> > in a sense that the operation can't be interrupted
> > in the middle. However the hypervisor always runs
> > on the same CPU so it does not need any memory
> > barrier or lock prefix.
> > 
> > At Peter Anvin's suggestion, add _local bitops for this purpose:
> > define them as non-atomics for x86 and (for now) atomics
> > for everyone else.
> > 
> > Uses are not restricted to virtualization: they
> > might be useful to communicate with an interrupt
> > handler if we know that it's running on the same CPU.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> I don't think you can use the x86 nonatomics as-is, because they don't
> contain optimization barriers.
> 
> 	-hpa

You are right of course. So I'll remove bitops/local.h
move the code to x86/ and open-code.

-- 
MST
