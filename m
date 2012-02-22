Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2BVVeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:34:22 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56523 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2BVVeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:34:21 -0500
Date: Wed, 22 Feb 2012 13:32:53 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org, Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120222213253.GA25150@kroah.com>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
 <20120222211928.GA4448@kroah.com>
 <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 01:29:11PM -0800, Linus Torvalds wrote:
> On Wed, Feb 22, 2012 at 1:19 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Thanks for doing the backport.  Any ideas on how far back this problem
> > goes?
> 
> The fundamental bug goes back forever, but happily afaik you can only
> *trigger* it by doing FPU accesses from interrupts, and nobody did
> that until the AES-NI instructions came about.
> 
> So practically speaking it goes back to the introduction of
> CRYPTO_AES_NI_INTEL, in commit 54b6a1bd5364 ("crypto: aes-ni - Add
> support to Intel AES-NI instructions for x86_64 platform").
> 
> Which was merged into 2.6.30. So it still goes back pretty far.
> 
> The good news is that I *think* the whole i387 handling code hasn't
> been touched much. But I didn't really check deeply.

Ok, I'll see how far back I can backport it easily, after Peter verifies
that this series works for him on his box.

thanks,

greg k-h
