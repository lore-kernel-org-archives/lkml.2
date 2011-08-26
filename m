Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1HZVHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:07:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149Ab1HZVHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:07:24 -0400
Date: Fri, 26 Aug 2011 14:06:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        James Morris <jmorris@namei.org>, neilb@suse.de
Subject: Re: [PATCH] sysctl: add support for poll()
Message-Id: <20110826140610.c4d27e1a.akpm@linux-foundation.org>
In-Reply-To: <1312484238-1645-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <CAMOw1v6uCMhgErrfPLQ5CSa0v_OoHhJ=M3OCL+YH9H1Zg5fEXQ@mail.gmail.com>
	<1312484238-1645-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Aug 2011 15:57:18 -0300
Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:

> Adding support for poll() in sysctl fs allows userspace to receive
> notifications of changes in sysctl entries. This adds a infrastructure
> to allow files in sysctl fs to be pollable and implements it for
> hostname and domainname.
> 

Seems reasonable.  One slight nit:

> +#define __CTL_TABLE_POLL_INITIALIZER(name) {				\
> +	.event = ATOMIC_INIT(0),					\
> +	.wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.wait) }
> +
> +#define DECLARE_CTL_TABLE_POLL(name)					\
> +	struct ctl_table_poll name = __CTL_TABLE_POLL_INITIALIZER(name)

This macro is used to define an instance of ctl_table_poll.  Hence it
should be called DEFINE_CTL_TABLE_POLL, not DECLARE_*.

declaration: "one of these exists"
definition: "here it is".

This matters a bit, because sometimes we'll have separate macros for
declaring and defining.

