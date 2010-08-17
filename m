Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334Ab0HQVrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:47:15 -0400
Received: from smtp-out.google.com ([74.125.121.35]:56871 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab0HQVrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:47:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=XpYch/9weeTPrmmmbj00CctdfuSSfyiILXw/FnCwx3OKCYfBNHqLPWI4BipM1iux/
	hi5OANWU/S9ANepx7sZ1g==
MIME-Version: 1.0
In-Reply-To: <AANLkTikcaVKnJxC18tUcJRTQwAukYhPdWMgGGrNaVjM_@mail.gmail.com>
References: <20100816.211218.189709876.davem@davemloft.net>
	<AANLkTikDXoRMRL0y_Y_7qVS=9LOw_yLS9MuUgq2dTCZf@mail.gmail.com>
	<AANLkTi=ZdrtWSYE0BEXJ-YDoxjta3h7RMR7Y8Z6Hu-Hc@mail.gmail.com>
	<AANLkTinO5yip7agVO3Lq3YLjDYmkB9MP14xjt3TusMfW@mail.gmail.com>
	<AANLkTik9qUf_F0NDoW2SBjWGHk2=ZdvkLrCORu3gGa2o@mail.gmail.com>
	<AANLkTikcaVKnJxC18tUcJRTQwAukYhPdWMgGGrNaVjM_@mail.gmail.com>
Date: Tue, 17 Aug 2010 14:47:05 -0700
Message-ID: <AANLkTimLqc02xNun0QR5ZgP497mm8ZC5ZfpCUx2AGz4Y@mail.gmail.com>
Subject: Re: tasks getting stuck on mmap_sem?
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 2:28 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Oh, and it strikes me when looking at the sparc rwsem-const.h that it
> has some unsigned constants in it. I think
>
>  #define RWSEM_WAITING_BIAS              0xffff0000
>
> is actually unsigned, because it's a hex constant that doesn't fit in
> a signed int. So it's of type 'unsigned int' if I recall the C type
> rules right.

Eeeek, this totally escaped me when I had a quick look at constant
signed-ness across architectures. This is definitely a problem.

> #define RWSEM_WAITING_BIAS             (-0x00010000)

David, do you still see failures with v2.6.36-rc1 plus that one line fix ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
