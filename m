Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0ETUCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:02:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab0ETUCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:02:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Tridgell <tridge@samba.org>,
       David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Jakub Jelinek <jakub@redhat.com>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: check_kill_permission: don't check creds if
 same_thread_group()
In-Reply-To: Andrew Morton's message of  Thursday, 20 May 2010 12:42:14 -0700 <20100520124214.2ac81a21.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20100517195414.GA21504@redhat.com>
	<20100520124214.2ac81a21.akpm@linux-foundation.org>
Emacs: where editing text is like playing Paganini on a glass harmonica.
Message-Id: <20100520200225.A01E4403F1@magilla.sf.frob.com>
Date: Thu, 20 May 2010 13:02:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So... which kernel(s) do we think this fix should be merged into?

I'd say all.  The glibc (libpthread) that does set*id across threads has
been in use for a while (2.3.4?), probably in distro's using kernels as old
or older than any active -stable streams.  In the race in question, this
kernel bug is breaking valid POSIX application expectations.


Thanks,
Roland
