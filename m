Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab2ILS6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:58:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab2ILS6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:58:30 -0400
Date: Wed, 12 Sep 2012 21:00:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH] coredump: prevent double-free on an error path in core
	dumper
Message-ID: <20120912190038.GA12473@redhat.com>
References: <1347449845-23764-1-git-send-email-vda.linux@googlemail.com> <D958900912E20642BCBC71664EFECE3E6DDEFB8D10@BGMAIL02.nvidia.com> <20120912130020.GA29585@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912130020.GA29585@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12, Oleg Nesterov wrote:
>
> On 09/12, Venu Byravarasu wrote:
> >
> > > --- a/fs/binfmt_elf.c
> > > +++ b/fs/binfmt_elf.c
> > > @@ -1695,30 +1695,19 @@ static int elf_note_info_init(struct elf_note_info
> > > *info)
> > >  		return 0;
> > >  	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
> >
> > Why don't you change kmalloc to devm_kzalloc, so that free can be ignored altogether.
>
> kzalloc(), I guess...
>
> Still I can't understand what did you mean.

Denys explained me privately what did you mean.

Well. elf_core_dump() does a lot of kmalloc's. We should either
change them all or nothing. And even if we do this, I think this
particular patch makes sense anyway.

Not sure we want "struct device" for this, perhaps this devres
code should be generalized somehow.

Oleg.

