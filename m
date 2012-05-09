Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824Ab2EITX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:23:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43450 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153Ab2EITX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:23:57 -0400
Message-ID: <4FAAC432.5080503@zytor.com>
Date: Wed, 09 May 2012 12:23:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
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
References: <20120509134528.GA18044@redhat.com> <20120509121940.459e93ba.akpm@linux-foundation.org>
In-Reply-To: <20120509121940.459e93ba.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 12:19 PM, Andrew Morton wrote:
> 
> Secondly: can KVM just use __set_bit() and friends?  I suspect those
> interfaces happen to meet your requirements.  At least on architectures
> you care about.
> 

__set_bit() and friends right now don't have optimization barriers,
meaning the compiler is free to move them around.

	-hpa
