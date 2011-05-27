Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1E0P5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:57:17 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:33985 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab1E0P5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:57:16 -0400
Date: Fri, 27 May 2011 21:26:56 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com
Subject: Re: [Patch 1/6] XPANIC: Add extended panic interface
Message-ID: <20110527155656.GB2384@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
 <20110526171209.GA17988@in.ibm.com>
 <BANLkTi=ZrPkRwFSmdkAB60-MKS3fwZOjpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=ZrPkRwFSmdkAB60-MKS3fwZOjpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 07:38:19PM +0200, richard -rw- weinberger wrote:
> On Thu, May 26, 2011 at 7:12 PM, K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> >
> > commit e668fa1aea7844ac4c7ea09030a2f3e647a4adb1
> > Author: Andi Kleen <ak@linux.intel.com>
> > Date:   Fri Nov 19 18:36:44 2010 +0100
> >
> > Index: linux-2.6.slim_kdump/kernel/panic.c
> > ===================================================================
> > --- linux-2.6.slim_kdump.orig/kernel/panic.c
> > +++ linux-2.6.slim_kdump/kernel/panic.c
> > @@ -57,14 +57,37 @@ EXPORT_SYMBOL(panic_blink);
> >  *
> >  *     This function never returns.
> >  */
> > -NORET_TYPE void panic(const char * fmt, ...)
> > +NORET_TYPE void panic(const char *fmt, ...)
> > +{
> > +       va_list ap;
> > +       va_start(ap, fmt);
> > +       vpanic(0, 0, fmt, ap);
> > +}
> > +EXPORT_SYMBOL(panic);
> > +
> > +NORET_TYPE void xpanic(enum panic_flags flags, int timeout,
> > +                       const char *fmt, ...)
> > +{
> > +       va_list ap;
> > +       va_start(ap, fmt);
> > +       xpanic(flags, timeout, fmt, ap);
> 
> Why are you calling xpanic() here again?
> I guess you meant vpanic().
>

True, this is a bug in the original patch found in the git tree
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git, for
which I have proposed a patch here: https://lkml.org/lkml/2011/5/26/337.

Thanks,
K.Prasad
 
