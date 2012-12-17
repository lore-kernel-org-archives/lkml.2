Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab2LQJwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 04:52:38 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54752 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2LQJwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 04:52:37 -0500
Date: Mon, 17 Dec 2012 10:52:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        J??rn Engel <joern@logfs.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] mm: Downgrade mmap_sem before locking or populating
 on mmap
Message-ID: <20121217095231.GA1134@gmail.com>
References: <3b624af48f4ba4affd78466b73b6afe0e2f66549.1355463438.git.luto@amacapital.net>
 <2e91ea19fbd30fa17718cb293473ae207ee8fd0f.1355536006.git.luto@amacapital.net>
 <20121216090026.GB21690@gmail.com>
 <CALCETrX=3oQMKMNF2L3K7ur35KpeiqUN12RMq3XvtRChh9OJkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX=3oQMKMNF2L3K7ur35KpeiqUN12RMq3XvtRChh9OJkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> > 2)
> >
> > More aggressively, we could just make it the _rule_ that the 
> > mm lock gets downgraded to read in mmap_region_helper(), no 
> > matter what.
> >
> > From a quick look I *think* all the usage sites (including 
> > sys_aio_setup()) are fine with that unlocking - but I could 
> > be wrong.
> 
> They are.

Lets try that then - the ugliness of the current patch is 
certainly a problem.

Thanks,

	Ingo
