Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2KEKjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:39:16 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37424 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab2KEKjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:39:13 -0500
Date: Mon, 5 Nov 2012 11:37:53 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Alessandro Crismani <alessandro.crismani@gmail.com>,
        Mikhail Bakhterev <mike.bakhterev@gmail.com>,
        Patrick H <kernel@feystorm.net>, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Message-ID: <20121105103753.GA25850@kroah.com>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2012 at 05:35:06PM +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> We've started getting reports of users seeing Machine Check Exceptions
> when booting their Samsung laptops in UEFI mode,
> 
>      https://bugzilla.kernel.org/show_bug.cgi?id=47121
> 
> This module seems to be the culprit as it's grovelling around in the
> 0xf0000 region which has no mapping in either the e820 or EFI memory
> maps on the affected machines.

So, does this mean that if we try to ioremap a memory location in the
kernel, like this driver is, it will not fail, but, when accessing the
memory, bad things happen?

That's not good, shouldn't the call to ioremap_nocache() have failed
originally?  That sounds like a core EFI/platform bug here, and one that
you might run into other places.

Shouldn't fixing that be the real fix?


thanks,

greg k-h
