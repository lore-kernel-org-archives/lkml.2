Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab1HXIcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:32:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1HXIcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:32:14 -0400
Message-ID: <4E54B6E2.2030203@redhat.com>
Date: Wed, 24 Aug 2011 11:31:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org
Subject: Re: linux next: Native Linux KVM tool inclusion request
References: <1314044960.3668.9.camel@lappy> <20110823003925.GA30253@infradead.org> <CAOJsxLEgm_-N6297kHqSjFLCtX-Vd204S=+4Q=+GW9HYiWj1eg@mail.gmail.com>
In-Reply-To: <CAOJsxLEgm_-N6297kHqSjFLCtX-Vd204S=+4Q=+GW9HYiWj1eg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 08:08 AM, Pekka Enberg wrote:
> As for changes, we've implemented rootfs over 9p with "kvm run"
> booting to host filesystem "/bin/sh" by default.

Isn't this dangerous?  Users expect virtualization to land them in 
sandbox, but here an rm -rf / in the guest will happily junk the host 
filesystem.

> It still needs some
> work and we hope to enable networking too. We also have patches to use
> overlayfs so that the guest is able to use host filesystem in
> copy-on-write manner.
>

Still dangerous (but just to the guest), since it's not a true 
snapshot.  If the host filesystem changes underneath the guest, it will 
see partial and incoherent updates.  Copy-on-write only works if the 
host filesystem doesn't change.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

