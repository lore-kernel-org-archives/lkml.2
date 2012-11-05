Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab2KEKab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:30:31 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59556 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2KEKa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:30:27 -0500
Date: Mon, 5 Nov 2012 11:30:31 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Corentin Chary <corentincj@iksaif.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Alessandro Crismani <alessandro.crismani@gmail.com>,
        Mikhail Bakhterev <mike.bakhterev@gmail.com>,
        Patrick H <kernel@feystorm.net>, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Message-ID: <20121105103031.GA25659@kroah.com>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
 <CAHR064isMXk8qkqhBJ==9sRRP7xC_j_K5rqXApza-LNkosp5mg@mail.gmail.com>
 <20121104193741.7b4ca37b@pyramind.ukuu.org.uk>
 <CAHR064jwe=diZ9B-D+-SroCW1ZevkRDMosB7uDuc2VXZkFxmdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064jwe=diZ9B-D+-SroCW1ZevkRDMosB7uDuc2VXZkFxmdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 09:12:01AM +0000, Corentin Chary wrote:
> On Sun, Nov 4, 2012 at 7:37 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> Acked-by: Corentin Chary <corentin.chary@gmail.com>
> >
> > This is totally bogus and prevents users build a kernel which can work in
> > either mode. As such its a regression.
> 
> Arg.. Sorry for that, I didn't realized that CONFIG_EFI=y was not
> something rare these days.
> 
> > Do the detection check at runtime. If it was booted via EFI then don't
> > grovel in places you shouldn't. Indeed its possible EFI should reserve
> > those memory regions ?
> 
> I wonder how the windows driver works in this case.. Maybe they use
> something completly different, and the SABI interface is still there
> because nobody removed/disabled it ? In this case it's probably not a
> good idea to use it on these machines since the implementation is
> likely to be completly broken.

Odds are, the windows driver just isn't even loaded on the newer
machines, as ACPI works just fine for this.  But, we don't have the
option of shipping custom systems for different laptops like Samsung
does, so we have to probe for this somehow.

Initally we were looking at the DMI strings for specific laptop models,
but that got annoying as we had to keep adding new models.  So we now
just check the memory locations for all Samsung laptops, which was
working fine.

What is the problem if we try to access this memory on UEFI machines?
What is the error that is caused?

Is there any "this_is_a_uefi_system()" type call drivers can make to
just opt-out if that call is true?

thanks,

greg k-h
