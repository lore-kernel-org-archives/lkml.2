Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2IRQzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:55:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab2IRQzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:55:46 -0400
Date: Tue, 18 Sep 2012 18:57:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@hack.frob.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH -mm v2 2/2] coredump: add a new elf note with siginfo
	of the signal
Message-ID: <20120918165744.GA25535@redhat.com>
References: <1347979995-1452-1-git-send-email-vda.linux@googlemail.com> <1347979995-1452-3-git-send-email-vda.linux@googlemail.com> <20120918153027.GA21612@redhat.com> <20120918164103.440C22C0A4@topped-with-meat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120918164103.440C22C0A4@topped-with-meat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Roland McGrath wrote:
>
> > But, somehow I forgot about compat tasks when we discussed this before.
> > Perhaps the code above should do
> >
> > 	if (is_compat_task())
> > 		copy_siginfo_to_user32(...);
> > 	else
> > 		copy_siginfo_to_user(...);
> >
> > ?
>
> compat_binfmt_elf.c will define a separate copy of this code via #include.
> So it just needs #define copy_siginfo_to_user copy_siginfo_to_user32 or
> something like that, as the various other types and functions are handled.

Ah, yes, you are right. Much better.

But. It seems, it also needs to do s/siginfo_t/compat_siginfo/ somehow,
a simple '#define' obviously can't work.

IOW, elf_thread_core_info.signote should be either siginfo_t or
compat_siginfo, but the argument passed to ->core_dump() and callees
should be siginfo_t.

Oleg.

