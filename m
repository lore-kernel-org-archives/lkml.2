Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2JJP3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:29:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2JJP3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:29:14 -0400
Date: Wed, 10 Oct 2012 10:32:33 -0400
From: Peter Jones <pjones@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Olof Johansson <olof@lixom.net>, Ingo Molnar <mingo@kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Switch to vga console only if framebuffer details
 are missing
Message-ID: <20121010143233.GB13313@eddie.install.bos.redhat.com>
References: <1347877748-11766-1-git-send-email-matt@console-pimps.org>
 <1349876587.15966.365.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1349876587.15966.365.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 02:43:07PM +0100, Matt Fleming wrote:
> On Mon, 2012-09-17 at 11:29 +0100, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > The efi_enabled variable has come to mean "Do we have EFI runtime
> > services available?". However, lack of EFI runtime services does not
> > mean that we should switch to using the VGA console. Provided that the
> > boot loader passed the dimensions of the EFI framebuffer there is no
> > reason we can't use efifb.
> > 
> > There's also no reason to check the memory type of 0xa0000 - whether
> > or not that memory region is EFI_CONVENTIONAL_MEMORY is immaterial -
> > the EFI framebuffer device will still work, and checking the EFI
> > memory type of a memory region on a non-EFI machine is illogical.
> > 
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Matthew Garrett <mjg@redhat.com>
> > Cc: Olof Johansson <olof@lixom.net>
> > Cc: Peter Jones <pjones@redhat.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> > ---
> >  arch/x86/kernel/setup.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Ping? Anybody got an opinion on this one?

Provided "video=vga" still works to circumvent Alan's objection, I'm all
for it.

-- 
        Peter
