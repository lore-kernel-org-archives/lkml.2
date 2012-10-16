Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2JPMfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:35:43 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54851 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2JPMfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:35:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1210151745400.31712@chino.kir.corp.google.com>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
	<m27gqwtyu9.fsf@firstfloor.org>
	<alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com>
	<m2391ktxjj.fsf@firstfloor.org>
	<CALF0-+WLZWtwYY4taYW9D7j-abCJeY90JzcTQ2hGK64ftWsdxw@mail.gmail.com>
	<alpine.DEB.2.00.1210130252030.7462@chino.kir.corp.google.com>
	<CALF0-+Xp_P_NjZpifzDSWxz=aBzy_fwaTB3poGLEJA8yBPQb_Q@mail.gmail.com>
	<alpine.DEB.2.00.1210151745400.31712@chino.kir.corp.google.com>
Date: Tue, 16 Oct 2012 09:35:41 -0300
Message-ID: <CALF0-+WgfnNOOZwj+WLB397cgGX7YhNuoPXAK5E0DZ5v_BxxEA@mail.gmail.com>
Subject: Re: [Q] Default SLAB allocator
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Mon, Oct 15, 2012 at 9:46 PM, David Rientjes <rientjes@google.com> wrote:
> On Sat, 13 Oct 2012, Ezequiel Garcia wrote:
>
>> But SLAB suffers from a lot more internal fragmentation than SLUB,
>> which I guess is a known fact. So memory-constrained devices
>> would waste more memory by using SLAB.
>
> Even with slub's per-cpu partial lists?

I'm not considering that, but rather plain fragmentation: the difference
between requested and allocated, per object.
Admittedly, perhaps this is a naive analysis.

However, devices where this matters would have only one cpu, right?
So the overhead imposed by per-cpu data shouldn't impact so much.

Study the difference in overhead imposed by allocators is
something that's still on my TODO.

Now, returning to the fragmentation. The problem with SLAB is that
its smaller cache available for kmalloced objects is 32 bytes;
while SLUB allows 8, 16, 24 ...

Perhaps adding smaller caches to SLAB might make sense?
Is there any strong reason for NOT doing this?

Thanks,

    Ezequiel
