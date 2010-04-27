Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab0D0Dv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 23:51:27 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:25457 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0D0Dv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 23:51:26 -0400
X-Spam-Processed: digidescorp.com, Mon, 26 Apr 2010 22:51:26 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.27.17
X-Return-Path: prvs=1733b75585=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] microblaze: add stack unwinder
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: monstr@monstr.eu
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
In-Reply-To: <4BC5F11C.3080305@monstr.eu>
References: <1271220928-3502-1-git-send-email-steve@digidescorp.com>
	 <4BC5F11C.3080305@monstr.eu>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Mon, 26 Apr 2010 22:31:29 -0500
Message-Id: <1272339089.17476.1.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 18:45 +0200, Michal Simek wrote:
> > diff -uprN a/arch/microblaze/kernel/traps.c
> b/arch/microblaze/kernel/traps.c
> > --- a/arch/microblaze/kernel/traps.c  2010-04-09 21:52:36.000000000
> > +++ b/arch/microblaze/kernel/traps.c  2010-04-12 22:16:01.000000000 
[snip]
> >  
> > -     if (!stack)
> > -             stack = (unsigned long *)&stack;
> > +     if (fp == 0) {
> > +             if (task)
> > +                     fp = ((struct thread_info *)
> > +                             (task->stack))->cpu_context.r1;
> > +             else {
> > +                     /* Pick up caller of dump_stack() */
> > +                     fp = (__u32)&sp - 8;
> > +             }
> > +     }
> 
> just coding style.
> 
>         if (fp == 0)
>                 if (task)
>                         fp = ((struct thread_info *)
>                                 (task->stack))->cpu_context.r1;
>                 else
>                         /* Pick up caller of dump_stack() */
>                         fp = (__u32)&sp - 8;

Do you feel strongly about this? I try to always use braces on if/else
clauses that have more than one line. I've found that the extra
characters are well worth the savings in debugging time when someone
tries to extend the clause and forgets to add the braces.

Steve


