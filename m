Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199Ab2EJTEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 15:04:10 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:26254 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756327Ab2EJTEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 15:04:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Y_H95RQVM1kIf6Ia8LCl_qjOcxAtQPApxocy0yxDRSnp1kZ
 L0kkj_zaUEDlcoSv1y1Qqkar1JuoIjsrr6mLsrwfikPQmlvXfJHOY5hHXRMl
 jnTMfnmQVMNEojveFVneDr5.1FFa1Va7jnP17VO97EGUEzgKcZium3niZmrF
 TqHeyLyCufkJwFR67Mmv77yH6bGtXRReeUTgjwxiotopBfHdHLVZhDhjcgkk
 8tW.npQG9KV6aOjEYckj6YxswfdluV6P5HYY0ZpYEkev5MYGL5nIb6yHdb6y
 omy93gUevGATwKCXtR7oZaZTx3vOiX7Kp_O_o.0ORONMYxOkviksmbk8uGB0
 iYyGF4WT8kt9Poig2QHsImJnCKGlK.obInmpOf5vLyW74rCJ94IXzFtlUj_m
 p
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 10 May 2012 14:04:00 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Arnd Bergmann <arnd@arndb.de>,
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
Subject: Re: [PATCHv2] bitops: add _local bitops
In-Reply-To: <20120509162819.GA21328@redhat.com>
Message-ID: <alpine.DEB.2.00.1205101401010.18664@router.home>
References: <20120509162819.GA21328@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Michael S. Tsirkin wrote:

> kvm needs to update some hypervisor variables atomically
> in a sense that the operation can't be interrupted
> in the middle. However the hypervisor always runs
> on the same CPU so it does not need any memory
> barrier or lock prefix.
>
> Add _local bitops for this purpose: define them
> as non-atomics for x86 and (for now) atomics for
> everyone else.

Have you tried to use the this_cpu_ops for that purpose? They create the
per cpu atomic instructions that you want without a lock prefix and can
also relocate the per cpu pointer to the correct processor via a
segment register prefix.

There are no bit operations provided right now but those can either be
improvised using this_cpu_cmpxchg or added.
