Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab2EHP1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:27:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48036 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab2EHP1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:27:05 -0400
Message-ID: <4FA93B3F.3000906@redhat.com>
Date: Tue, 08 May 2012 17:26:55 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC dontapply 5/5] kvm_para: guest side for eoi avoidance
References: <cover.1334833140.git.mst@redhat.com> <5e1399d9e743668a87f31d8f2b83cad862c60728.1334833141.git.mst@redhat.com>
In-Reply-To: <5e1399d9e743668a87f31d8f2b83cad862c60728.1334833141.git.mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/04/2012 16:04, Michael S. Tsirkin ha scritto:
> +/* Our own copy of __test_and_clear_bit to make sure
> + * it is done with a single instruction */

Is this for microoptimization or correctness?  If the latter, it does
not ensure anything without a "lock" prefix.

Paolo

> +static inline int kvm_test_and_clear_bit(int nr, volatile u16* addr)
> +{
> +	int oldbit;
> +
> +	asm volatile("btr %2,%1\n\t"
> +		     "sbb %0,%0"
> +		     : "=r" (oldbit), BITOP_ADDR_CONSTRAINT(*addr) : "Ir" (nr));
> +	return oldbit;

