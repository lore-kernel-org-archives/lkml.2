Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1HABTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 21:19:21 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:33611 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab1HABTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 21:19:14 -0400
Date: Sun, 31 Jul 2011 21:16:47 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Peter Foley <pefoley2@verizon.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz, rdunlap@xenotime.net
Subject: Re: [PATCH RFC] kconfig.h fix extraneous dependencies
In-reply-to: <CACqU3MWfOg+ZhUGAovWsds48Y37i7GRk7qSxWvt7-JmLMBcmgg@mail.gmail.com>
Message-id: <alpine.LNX.2.00.1107312055360.20006@linux>
References: <alpine.LNX.2.00.1107311812460.62769@linux>
 <CACqU3MWfOg+ZhUGAovWsds48Y37i7GRk7qSxWvt7-JmLMBcmgg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jul 2011, Arnaud Lacombe wrote:

> Hi,
> 
> On Sun, Jul 31, 2011 at 8:36 PM, Peter Foley <pefoley2@verizon.net> wrote:
> > The introduction of kconfig.h caused fixdep to create three extraneous
> > dependencies.
> > include/config/.h
> > include/config/h.h
> > include/config/foo.h
> >
> > Remove them by eliminating instances of CONFIG_
> >
> this seems ugly to me... I would rather try to fix fixdep, no ?
> 
>  - Arnaud

I'd be the first to admit that this patch is a ugly hack.
However, judging by the comments in fixdep.c this is expected behavior.
I'm also afraid that changing fixdep to ignore comments would slow down 
the whole build for the sake of one file which IMHO dosen't seem to be a 
worthwhile tradeoff. 

Thanks,

Peter
