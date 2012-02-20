Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2BTS0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 13:26:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18414 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2BTS0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 13:26:15 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=7-CSKSCuul8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=HAMjl_5tTQjLUTlTJMcA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329762372.25686.35.camel@gandalf.stny.rr.com>
Subject: Re: [tip:x86/urgent] x86/nmi: Test saved %cs in NMI to determine
 nested NMI case
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Date: Mon, 20 Feb 2012 13:26:12 -0500
In-Reply-To: <CA+55aFxfAn9MWRgS3O5k2tqN5ys1XrhSFVO5_9ZAoZKDVgNfGA@mail.gmail.com>
References: <1329687817.1561.27.camel@acer.local.home>
	 <tip-45d5a1683c04be28abdf5c04c27b1417e0374486@git.kernel.org>
	 <CA+55aFxfAn9MWRgS3O5k2tqN5ys1XrhSFVO5_9ZAoZKDVgNfGA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 10:03 -0800, Linus Torvalds wrote:
> On Mon, Feb 20, 2012 at 3:47 AM, tip-bot for Steven Rostedt
> <rostedt@goodmis.org> wrote:
> >        /*
> > +        * If %cs was not the kernel segment, then the NMI triggered in user
> > +        * space, which means it is definitely not nested.
> > +        */
> > +       cmp $__KERNEL_CS, 16(%rsp)
> > +       jne first_nmi
> 
> I don't like how you wrote 'cmp' without a size, especially with none
> of the arguments then giving a size either. Usually there's a register
> name or something that gives you the size, but not here.
> 
> I guess there is some default size that gas will use, but at least
> some versions of gas have traditionally errored out instead of
> guessing on sizes. Maybe x86-64 doesn't use those gas versions any
> more, but still..

OK, I'll send an update fix to use cmpq.

>From HPA's email:

"User space can change %cs, but it can never set it to __KERNEL_CS; 
specifically user space can never set the bottom two bits in CS to
zero."


I'm not sure it matters, but I'll change it anyway since we are
comparing an 8 byte word on the stack.

-- Steve




