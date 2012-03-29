Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab2C2Qct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:32:49 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:53599 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759558Ab2C2Qc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:32:26 -0400
Date: Thu, 29 Mar 2012 18:32:22 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Jason Baron <jbaron@redhat.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH Resend] epoll: add EPOLLEXCLUSIVE support
Message-ID: <20120329163222.GA3145@hell>
References: <1332943060-18374-1-git-send-email-hagen@jauu.net>
 <CAFLxGvx0m6iaDPTDkjzw6ohX6Wdmr+DgWEr_fMdyEux50JVFEw@mail.gmail.com>
 <20120328162108.GB2381@redhat.com>
 <20120328195848.GA5331@hell>
 <20120329141653.GA2424@redhat.com>
 <20120329150541.GB3173@hell>
 <20120329155323.GB2424@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329155323.GB2424@redhat.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron | 2012-03-29 11:53:24 [-0400]:

>I was trying to better understand the use-case, since at least for the
>test case you posted, 'EPOLLET', already does what you want.
>
>Also, the 'EPOLLEXCLUSIVE' flag in your patch addresses multiple threads
>blocking on *different* epoll fds. However, if multiple threads are
>blocked on a single epoll fd, they will all be woken even if 'EPOLLEXCLUSIVE'
>is set. Shouldn't 'EPOLLEXCLUSIVE' affect that case too?

Hey Jason,

I just wanted to address the "main use-case" (as implemented in a bunch of
network server): one listen socket (say 80) is created and a epoll fd is
created. The listen socket is added to the set and n threads are created
afterwards. So now you have the situation that one listening socket is added
to the set and all threads are awoken if a new client connects. This patch
reduce the useless-all-thread-awoken-overhead by awake only one thread.

Hagen
