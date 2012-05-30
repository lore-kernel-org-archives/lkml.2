Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2E3B0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:26:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36252 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2E3B0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:26:39 -0400
MIME-Version: 1.0
Message-ID: <a1750a63-2af0-43d9-8d7c-307e1693b5da@default>
Date: Tue, 29 May 2012 18:26:25 -0700 (PDT)
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
To: <yinghai@kernel.org>
Cc: <mingo@redhat.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <joe.jin@oracle.com>, <linux-kernel@vger.kernel.org>,
        <ethan.zhao@oracle.com>, <hpa@zytor.com>
Subject: =?UTF-8?B?562U5aSNOiBSZTogW1BBVENIXSBGaXggYW4gb3Zl?=
 =?UTF-8?B?cmZsb3cgaW4gcmFuZ2VfdG9fbXRyciBmdW5j?=
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- yinghai@kernel.org 写道：

> On Mon, May 28, 2012 at 5:29 AM, Zhenzhong Duan
> <zhenzhong.duan@oracle.com> wrote:
> > When boot x86_64 kernel on sun G5+ with 4T mem, see an overflow in
> mtrr cleanup as below.
> >
> > *BAD*gran_size: 2G      chunk_size: 2G  num_reg: 10     lose cover
> RAM:
> > -18014398505283592M
> >
> > This is because 1<<31 sign extended.
> > Use explicit type conversion to force a 64bit constant to fix it.
> > Useful for mem larger than or equal to 4T.
> >
> > Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> > ---
> >  arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c
> b/arch/x86/kernel/cpu/mtrr/cleanup.c
> > index ac140c7..853a4c6 100644
> > --- a/arch/x86/kernel/cpu/mtrr/cleanup.c
> > +++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
> > @@ -266,7 +266,7 @@ range_to_mtrr(unsigned int reg, unsigned long
> range_startk,
> >                if (align > max_align)
> >                        align = max_align;
> >
> > -               sizek = 1 << align;
> > +               sizek = (unsigned long)1 << align;
> 
> how about
> 
>             sizek = 1UL << align;
> 
> 
> >                if (debug_print) {
> >                        char start_factor = 'K', size_factor = 'K';
> >                        unsigned long start_base, size_base;
> > --
> > 1.7.3
> >
Yes, this looks more clean although same compiling result. Should i resend it?
