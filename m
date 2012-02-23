Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2BWUOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:14:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59221 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab2BWUOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:14:44 -0500
Date: Thu, 23 Feb 2012 12:09:05 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org, Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120223200905.GA5475@kroah.com>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
 <20120222211928.GA4448@kroah.com>
 <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com>
 <20120222213253.GA25150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120222213253.GA25150@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 01:32:53PM -0800, Greg Kroah-Hartman wrote:
> On Wed, Feb 22, 2012 at 01:29:11PM -0800, Linus Torvalds wrote:
> > On Wed, Feb 22, 2012 at 1:19 PM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > Thanks for doing the backport.  Any ideas on how far back this problem
> > > goes?
> > 
> > The fundamental bug goes back forever, but happily afaik you can only
> > *trigger* it by doing FPU accesses from interrupts, and nobody did
> > that until the AES-NI instructions came about.
> > 
> > So practically speaking it goes back to the introduction of
> > CRYPTO_AES_NI_INTEL, in commit 54b6a1bd5364 ("crypto: aes-ni - Add
> > support to Intel AES-NI instructions for x86_64 platform").
> > 
> > Which was merged into 2.6.30. So it still goes back pretty far.
> > 
> > The good news is that I *think* the whole i387 handling code hasn't
> > been touched much. But I didn't really check deeply.
> 
> Ok, I'll see how far back I can backport it easily, after Peter verifies
> that this series works for him on his box.

I've applied this now to the 3.0 and 3.2-stable trees.  It looks like it
would work on the 2.6.32-stable tree, but it needs some tweaks, and as I
can't really test this, and the .32-stable tree is probably not going to
have problems in this area, I'll let someone else generate those patches
and test them if they feel it is needed there.

thanks,

greg k-h
