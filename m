Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806Ab2EITTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:19:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab2EITTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:19:41 -0400
Date: Wed, 9 May 2012 12:19:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Arnd Bergmann <arnd@arndb.de>,
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
Message-Id: <20120509121940.459e93ba.akpm@linux-foundation.org>
In-Reply-To: <20120509134528.GA18044@redhat.com>
References: <20120509134528.GA18044@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012 16:45:29 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> kvm needs to update some hypervisor variables atomically
> in a sense that the operation can't be interrupted
> in the middle. However the hypervisor always runs
> on the same CPU so it does not need any memory
> barrier or lock prefix.

Well.  It adds more complexity, makes the kernel harder to understand
and maintain and introduces more opportunities for developers to add
bugs.  So from that point of view, the best way of handling this patch
is to delete it.

Presumably the patch offers some benefit to offest all those costs. 
But you didn't tell us what that benefit is, so we cannot make
a decision.

IOW: numbers, please.  Convincing ones, for realistic test cases.


Secondly: can KVM just use __set_bit() and friends?  I suspect those
interfaces happen to meet your requirements.  At least on architectures
you care about.

