Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2JVOPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:15:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33426 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2JVOPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:15:06 -0400
Date: Mon, 22 Oct 2012 10:14:57 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/19] x86, mm: setup page table in top-down
Message-ID: <20121022141455.GA14193@konrad-lan.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
 <1350593430-24470-10-git-send-email-yinghai@kernel.org>
 <alpine.DEB.2.02.1210191714330.2689@kaball.uk.xensource.com>
 <CAE9FiQX-JBHvjqLyjutKfBUp2DQKEwVMGEkj7Wi6yijAERhP6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQX-JBHvjqLyjutKfBUp2DQKEwVMGEkj7Wi6yijAERhP6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Changelog is always problem now. Looks like everyone is complaining about that.
> 
> Actually I already tried my best on that, really don't know what to do next.

Read on. I've some advice.
> 
> >
> > In particular you should state in clear letters that alloc_low_page is
> > always going to return a page that is already mapped. You should write
> > it both in the commit message and in the code as a comment.
> > This is particularly important because it is going to become part of the
> > interface between the common x86 code and the other x86 subsystems like
> > Xen.
> 
> alloc_low_page() is used in arch/x86/mm/init*.c. How come it becomes
> interface to
> other subsystem?
> 
> I'm not sure if we really need that comment in code for that:
> ---
> the page that alloc_low_page return is directed mapped already, could
> use virtual address
> to access it.
> ---
> 
> >
> > Also, it wouldn't hurt to explain the overall design at the beginning of
> > the series: I shouldn't have to read your code to understand what you
> > are doing. I should read the description of the patch, understand what
> > you are doing, then go and check if the code actually does what you say
> > it does.
> 
> Actually I really don't like to read too long change log in commit.
> Changelog should be concise and precise.

They depend on the patch in question. If it is something simple
(fix compile warning) sure. But for something that is deep in the bowels
of complicated code - then it should have a good explanation that
follows roughly these steps:

 1). Introduce the problem. Explain what is wrong with the existing
     code.
 2). Explain how your patch fixes it.
 3). Explain (if there are any) alternative solutions.

Then re-read it and look at the verb tense. It should be the same tense -
so don't mix them.
