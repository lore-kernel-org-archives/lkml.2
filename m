Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1AJQwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:52:13 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:21395 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752952Ab1AJQwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:52:11 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 0vTJjSgVM1m2kPd5SKowXC3KS5Wq04hLS5yM3ogC.aKiOyO
 Gh4fjtq8oWKOuUq6dSlQ12fWjgMnePXJzGmyACzdmQ3lniSkdm3PNqGIlfo3
 3TeKCV.Mil3NjW1MlZIcG0_OAdTejF2rczICR70VY_Zvj1OkQ1QL_oUo05BE
 LkbbQVjZUJ7vSPMSvd85HpOlOlvEHfooxkF5m40TebLYQ2jsR_DVq2v6rek.
 YXRqgckOQZcFymKuePYdIIueSgQkbuErbBf0FOs00V2LI00tQEAItz80W6Wq
 og9EZuNpo88jCvxMp7Y8B6b_d2T6IVzjEOQ4EHi0y6UBh9yM-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 10 Jan 2011 10:52:05 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: BUG: sleeping function called from invalid context at
 mm/slub.c:793
In-Reply-To: <20110110105433.GA17881@shutemov.name>
Message-ID: <alpine.DEB.2.00.1101101051260.12243@router.home>
References: <20110110105433.GA17881@shutemov.name>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.1101101051262.12243@router.home>
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 10 Jan 2011, Kirill A. Shutemov wrote:

> Every time I run qemu with KVM enabled I get this in dmesg:
>
> [  182.878328] BUG: sleeping function called from invalid context at mm/slub.c:793
> [  182.878339] in_atomic(): 1, irqs_disabled(): 0, pid: 4992, name: qemu
> [  182.878355] Pid: 4992, comm: qemu Not tainted 2.6.37+ #31
> [  182.878361] Call Trace:
> [  182.878381]  [<c104e317>] ? __might_sleep+0xd0/0xd7
> [  182.878394]  [<c10ec337>] ? slab_pre_alloc_hook.clone.39+0x23/0x27
> [  182.878404]  [<c10ece27>] ? kmem_cache_alloc+0x22/0xc8
> [  182.878414]  [<c1030221>] ? init_fpu+0x44/0x7b

fpu_alloc() does call kmem_cache_alloc with GFP_KERNEL although we are in
an atomic context.
