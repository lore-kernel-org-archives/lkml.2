Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab2JSNkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:40:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab2JSNkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:40:37 -0400
Message-ID: <508157F7.3010906@redhat.com>
Date: Fri, 19 Oct 2012 15:39:03 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Paul Holland <pholland@adobe.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
        Paton Lewis <palewis@adobe.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        Linux API <linux-api@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
References: <CCA6A06A.10264%pholland@adobe.com>
In-Reply-To: <CCA6A06A.10264%pholland@adobe.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/10/2012 15:29, Paul Holland ha scritto:
> A disadvantage of solutions in this direction, which was not preset in
> Paton's patch, is that all calls to epoll_wait would need to specify some
> timeout value (!= -1) to guarantee that they each come out of epoll_wait
> and execute the "pass the buck" or "grace_period" logic.  So you would
> then have contention between designs that want highly responsive "delete"
> operations (those would require very short timeout values to epoll_wait)
> and those that want low execution overhead (those would want larger
> timeout values).

Is this really a problem?  If your thread pool risks getting oversized,
you might need some kind of timeout anyway to expire threads.  If your
thread pool is busy, the timeout will never be reached.

I'm not against EPOLL_CTL_DISABLE, just couldn't resist replying to "The
optimal data structure to do this without killing scalability is not
obvious". :)

Paolo
