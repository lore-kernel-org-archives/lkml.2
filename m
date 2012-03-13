Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030296Ab2CMJxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:53:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964990Ab2CMJw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:52:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/35] Disintegrate asm/system.h for Hexagon [ver #2]
Date: Tue, 13 Mar 2012 09:16:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-hexagon@vger.kernel.org
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233747.13888.75605.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233747.13888.75605.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130916.15118.arnd@arndb.de>
X-Provags-ID: V02:K0:Zw6AncvMZKYMxj8TBUeG3KrK6GwvJRjVvSCDdzWWEx5
 6128w2X1w+IJSANCm3YDzSCQJixudzsTZ3aQPFRBA5hmzNnIfi
 NxJ17Hvh6FBaiLmcKf/M8M936cl5/rs8yLs24FH5XxjW46xczF
 Kcg5L5L+aiu9rItYpl1jBti0TzcEkddSpLVNaGXkEHl+JWPNwE
 7gjgQc9X2KpWaoTHGJGYTaXoFpX9AmeVfUwPi7uPXlENU9SsVJ
 ECn/lr8l+6RNG52fDgfzYyBcwtwq21aaoXpm5WLMrv+rnGx9O3
 Qzi7ZfAWZAequralVxayIMuir9N5oJQYjjyZVC2p8NLoFUR/+h
 yiUkzNe8RafOmID42BpQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2012, David Howells wrote:
> Disintegrate asm/system.h for Hexagon.  Not compiled.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-hexagon@vger.kernel.org
> ---
> 
>  arch/hexagon/include/asm/atomic.h    |    1 
>  arch/hexagon/include/asm/barrier.h   |   41 +++++++++++
>  arch/hexagon/include/asm/bitops.h    |    1 
>  arch/hexagon/include/asm/cmpxchg.h   |   90 +++++++++++++++++++++++
>  arch/hexagon/include/asm/exec.h      |   28 +++++++
>  arch/hexagon/include/asm/switch_to.h |   34 +++++++++
>  arch/hexagon/include/asm/system.h    |  131 +---------------------------------
>  arch/hexagon/kernel/ptrace.c         |    1 
>  arch/hexagon/kernel/smp.c            |    1 
>  arch/hexagon/kernel/vm_events.c      |    1 
>  10 files changed, 199 insertions(+), 130 deletions(-)
>  create mode 100644 arch/hexagon/include/asm/barrier.h
>  create mode 100644 arch/hexagon/include/asm/cmpxchg.h
>  create mode 100644 arch/hexagon/include/asm/exec.h
>  create mode 100644 arch/hexagon/include/asm/switch_to.h

Looking at this example, it could easily use the asm-generic versions of
switch_to.h and barrier.h, but that would complicate the dependency chain
again.

I think the same is true for other platforms.

	Arnd

