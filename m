Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2BWTgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:36:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42923 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab2BWTge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:36:34 -0500
Date: Thu, 23 Feb 2012 11:36:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: raphael@buro.asia
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120223193620.GA16477@kroah.com>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
 <4F456D8F.1080801@zytor.com>
 <CA+55aFw4P1qUye5YOJKSQHX+TfxbEDWMF7LPogj128b6gv2Nqg@mail.gmail.com>
 <CA+55aFziJ=Lw0KxxThwfqRPR+K0OWDorKAfkgKMGPXv5O404JA@mail.gmail.com>
 <4F4584EB.9060605@zytor.com>
 <CA+55aFxC6JwWsNcmkQ+DROXtWCzaq52DuX5aMJZfXMLoNCbsWg@mail.gmail.com>
 <20120223003706.GA3246@kroah.com>
 <6e9d38ffcb1a66f62a335450d4722809@buro.asia>
 <CA+55aFxTieMqacU9LN8Xmtb3Os8zkub1P+SKpqFtEBQ11STy7g@mail.gmail.com>
 <e709c3b5c5b2aa6e6a9d049f3af857e3@buro.asia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e709c3b5c5b2aa6e6a9d049f3af857e3@buro.asia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 10:41:57AM +0800, raphael@buro.asia wrote:
> On 23.02.2012 10:55, Linus Torvalds wrote:
> >On Wed, Feb 22, 2012 at 5:47 PM,  <raphael@buro.asia> wrote:
> >>
> >>Thank you for backporting this patchset to -stable. FWIW, the
> >>test machine I
> >>had been working with has an uptime of 4 days now, with the
> >>patchset in
> >>attachment applied on top of 3.2.6, so if it were unpractical to
> >>trim it
> >>down further you can find solace in that it does not break anything.
> >
> >Hmm. The patches in your attachements are whitespace-damaged. I was
> >going to apply that series and see what the difference was to my
> >minimal trial, but with the corruption that isn't possible.
> >
> >I didn't find anything obviously wrong in my series, so..
> >
> >Could you send the patches you used for your backport with the
> >whitespace fixed, and preferably with the patch numbering explained?
> 
> The numbering is just so I can apply the patches in the right order
> with a for loop in the packaging script. The missing 7* was the
> experimental patches we tried which moved has_fpu in the thread_info
> struct (which did not work).
> 
> The patchset is simply made of:
> be98c2cdb15ba26148cd2bd58a857d4f7759ed38 (unmodified)
> 5b1cbac37798805c1fee18c8cebe5c0a13975b17 (")
> c38e23456278e967f094b08247ffc3711b1029b2 (")
> 15d8791cae75dca27bfda8ecfe87dca9379d6bb0 (")
> b6c66418dcad0fcf83cd1d0a39482db37bf4fc41 (")
> 6d59d7a9f5b723a7ac1925c136e93ec83c0c3043 (")
> b3b0870ef3ffed72b92415423da864f440f57ad6 (")

These all applied fine, I've queued them up so far.

> 4903062b5485f0e2c286a23b44c9b59d9b017d53: this one requires a slight
> modification:
> -#define safe_address (kstat_cpu(0).cpustat.user)
> instead of:
> -#define safe_address
> (__get_cpu_var(kernel_cpustat).cpustat[CPUTIME_USER])

Hm, for 3.0-stable, yes, that's all that seems to be needed, but for
3.2-stable, something is odd here, there's some changes that are missing
here to get this correct (odds are you didn't test this on a AMD
processor, that's the odd portion of the merge.)

I'll dig into this some more, maybe we need another patch here...

greg k-h
