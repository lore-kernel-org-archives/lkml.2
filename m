Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2KFV64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:58:56 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:55498 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab2KFV6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:58:55 -0500
Date: Tue, 6 Nov 2012 21:58:54 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Christof Meerwald <cmeerw@cmeerw.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, libc-alpha@sourceware.org,
        linux-api@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [RFC/PATCH] epoll: replace EPOLL_CTL_DISABLE with
 EPOLL_CTL_POKE
Message-ID: <20121106215854.GA6626@dcvr.yhbt.net>
References: <1351210112-23238-1-git-send-email-palewis@adobe.com>
 <20121102041312.GA15886@dcvr.yhbt.net>
 <20121103011031.GA22452@edge.cmeerw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121103011031.GA22452@edge.cmeerw.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christof Meerwald <cmeerw@cmeerw.org> wrote:
> On Fri, 2 Nov 2012 04:13:12 +0000, Eric Wong wrote:
> [...]
> > EPOLL_CTL_POKE may be used to force an item into the epoll
> > ready list.  Instead of disabling an item asynchronously
> > via EPOLL_CTL_DISABLE, this forces the threads calling
> > epoll_wait() to handle the item in its normal loop.
> 
> That was my initial suggestion as well - see
> https://lkml.org/lkml/2012/6/19/358

Thanks, missed that the first time around.  Perhaps TRIGGER is a
better name than POKE :x

I'm hoping Paton has a chance to look at my implementation and
comment on it.
