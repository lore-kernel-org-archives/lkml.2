Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab1CXGq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:46:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47562 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab1CXGq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:46:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=bJ1RespXuowbejsVpW2HxANWumiuGN0Mo2heXBx2BuLjsmAxq1AmcUZdgv3Nsb8WBE
         6Nzg8hIgAT097mPJ7FJtmR97/LwprwrrVZSePwG8MNqsLA9VVAP9hYWC63Ob59TdTjSF
         Lc95yJ+7tluwzABL4L9gek4akrPNjiCZ71K9Q=
MIME-Version: 1.0
In-Reply-To: <4CC6E05A.8040508@kernel.org>
References: <4CC69B22.2050708@kernel.org> <20101025224111.7798.38960.stgit@warthog.procyon.org.uk>
 <12101.1288088542@redhat.com> <4CC6C62F.1000804@kernel.org>
 <4CC6C941.2080003@kernel.org> <4CC6CD4D.3010501@kernel.org> <4CC6E05A.8040508@kernel.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 24 Mar 2011 02:46:01 -0400
X-Google-Sender-Auth: uSL_U9mKLcytjswp9W_boC6EyT8
Message-ID: <AANLkTi=WWCPJeQ8DVv1j7GF0J61DiUupiOEuxDCW8_Xd@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [RFC PATCH] percpu: always align percpu
 output section to PAGE_SIZE
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@osdl.org, Alexander van Heukelum <heukelum@fastmail.fm>,
        linux-am33-list@redhat.com,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        uclinux-dist-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 10:06, Tejun Heo wrote:
> The linker script macros PERCPU_VADDR() and PERCPU() are used to
> define this output section and the latter takes @align parameter.
> Several architectures are using @align smaller than PAGE_SIZE breaking
> percpu memory alignment.

hmm, i just pushed through a fix in the Blackfin tree as we hit a boot
failure otherwise:
-   PERCPU(4)
+   PERCPU(PAGE_SIZE)

> This patch removes @align parameter from PERCPU(), renames it to
> PERCPU_SECTION and makes it always align to PAGE_SIZE.  While at it,
> add PCPU_SETUP_BUG_ON() checks such that alignment problems are
> reliably detected and remove percpu alignment comment recently added
> in workqueue.c as the condition would trigger BUG way before reaching
> there.

seems this still hasnt made it to mainline.  has it stalled or
something ?  feel free for the Blackfin bits:
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
