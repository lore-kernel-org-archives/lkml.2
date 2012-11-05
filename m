Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2KELu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:50:27 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:39716 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059Ab2KELuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:50:25 -0500
Message-ID: <1352116219.14888.262.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
From: Matt Fleming <matt@console-pimps.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Corentin Chary <corentincj@iksaif.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Alessandro Crismani <alessandro.crismani@gmail.com>,
        Mikhail Bakhterev <mike.bakhterev@gmail.com>,
        Patrick H <kernel@feystorm.net>, "H. Peter Anvin" <hpa@zytor.com>,
        stable@vger.kernel.org
Date: Mon, 05 Nov 2012 11:50:19 +0000
In-Reply-To: <20121105103031.GA25659@kroah.com>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
	 <CAHR064isMXk8qkqhBJ==9sRRP7xC_j_K5rqXApza-LNkosp5mg@mail.gmail.com>
	 <20121104193741.7b4ca37b@pyramind.ukuu.org.uk>
	 <CAHR064jwe=diZ9B-D+-SroCW1ZevkRDMosB7uDuc2VXZkFxmdA@mail.gmail.com>
	 <20121105103031.GA25659@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 11:30 +0100, Greg KH wrote:
> Odds are, the windows driver just isn't even loaded on the newer
> machines, as ACPI works just fine for this.  But, we don't have the
> option of shipping custom systems for different laptops like Samsung
> does, so we have to probe for this somehow.
> 
> Initally we were looking at the DMI strings for specific laptop models,
> but that got annoying as we had to keep adding new models.  So we now
> just check the memory locations for all Samsung laptops, which was
> working fine.
> 
> What is the problem if we try to access this memory on UEFI machines?
> What is the error that is caused?

Machine Check Exceptions are generated.

> Is there any "this_is_a_uefi_system()" type call drivers can make to
> just opt-out if that call is true?

There is the 'efi_enabled' variable, but it doesn't strictly mean
"this_is_a_uefi_system()", it actually means "Do we have EFI runtime
services?". The whole thing is a bit of a mess and I'm planning on
cleaning it up this week.

-- 
Matt Fleming, Intel Open Source Technology Center

