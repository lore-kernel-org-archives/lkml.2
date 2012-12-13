Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2LMAnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:43:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2LMAnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:43:23 -0500
Date: Wed, 12 Dec 2012 16:43:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Ted Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>,
        Jeff Liu <jeff.liu@oracle.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] avoid entropy starvation due to stack protection
Message-Id: <20121212164321.a01c5641.akpm@linux-foundation.org>
In-Reply-To: <50C72800.20508@chronox.de>
References: <50C72800.20508@chronox.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2012 13:33:04 +0100
Stephan Mueller <smueller@chronox.de> wrote:

> Some time ago, I noticed the fact that for every newly
> executed process, the function create_elf_tables requests 16 bytes of
> randomness from get_random_bytes. This is easily visible when calling
> 
> while [ 1 ]
> do
> 	cat /proc/sys/kernel/random/entropy_avail
> 	sleep 1
> done

Please see
http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

That patch is about one week from a mainline merge, btw.
