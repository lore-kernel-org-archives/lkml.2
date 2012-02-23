Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab2BWSPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:15:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34664 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab2BWSPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:15:38 -0500
Date: Thu, 23 Feb 2012 10:15:31 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: raphael@buro.asia, "H. Peter Anvin" <hpa@zytor.com>,
        stable@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120223181531.GA1906@kroah.com>
References: <4F456D8F.1080801@zytor.com>
 <CA+55aFw4P1qUye5YOJKSQHX+TfxbEDWMF7LPogj128b6gv2Nqg@mail.gmail.com>
 <CA+55aFziJ=Lw0KxxThwfqRPR+K0OWDorKAfkgKMGPXv5O404JA@mail.gmail.com>
 <4F4584EB.9060605@zytor.com>
 <CA+55aFxC6JwWsNcmkQ+DROXtWCzaq52DuX5aMJZfXMLoNCbsWg@mail.gmail.com>
 <20120223003706.GA3246@kroah.com>
 <6e9d38ffcb1a66f62a335450d4722809@buro.asia>
 <CA+55aFxTieMqacU9LN8Xmtb3Os8zkub1P+SKpqFtEBQ11STy7g@mail.gmail.com>
 <e709c3b5c5b2aa6e6a9d049f3af857e3@buro.asia>
 <CA+55aFwQSaWmXS59U5hG5hfww7G6XRs6LfYQ5fpS3og2y0OTYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwQSaWmXS59U5hG5hfww7G6XRs6LfYQ5fpS3og2y0OTYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 07:37:27PM -0800, Linus Torvalds wrote:
> On Wed, Feb 22, 2012 at 6:41 PM,  <raphael@buro.asia> wrote:
> >
> > The patchset is simply made of:
> > be98c2cdb15ba26148cd2bd58a857d4f7759ed38 (unmodified)
> > 5b1cbac37798805c1fee18c8cebe5c0a13975b17 (")
> > c38e23456278e967f094b08247ffc3711b1029b2 (")
> > 15d8791cae75dca27bfda8ecfe87dca9379d6bb0 (")
> > b6c66418dcad0fcf83cd1d0a39482db37bf4fc41 (")
> > 6d59d7a9f5b723a7ac1925c136e93ec83c0c3043 (")
> > b3b0870ef3ffed72b92415423da864f440f57ad6 (")
> > 4903062b5485f0e2c286a23b44c9b59d9b017d53: this one requires a slight
> > modification:
> > -#define safe_address (kstat_cpu(0).cpustat.user)
> > instead of:
> > -#define safe_address (__get_cpu_var(kernel_cpustat).cpustat[CPUTIME_USER])
> > f94edacf998516ac9d849f7bc6949a703977a7f3 (unmodified)
> > 34ddc81a230b15c0e345b6b253049db731499f7e (")
> 
> Oh, Greg, since that series is tested by Raphael on top of 3.2.6
> already, let's just make that be the stable backport.
> 
> It does mean that the stable backport will contain that whole "rip out
> fp state preloading and reimplement it" thing, but hey, considering
> that when I tried to avoid it I clearly screwed something up, maybe
> that's all for the best. And perhaps staying closer to the development
> tree is a good idea anyway in case there are any other issues.

I prefer the "staying closer" model, it works out better if there are
problems found later on.  I'll work on queuing these up now.

thanks,

greg k-h
