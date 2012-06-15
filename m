Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab2FOUKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:10:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42089 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2FOUK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:10:26 -0400
Date: Fri, 15 Jun 2012 13:10:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [-next] FATAL: drivers/gpu/drm/udl/udl: sizeof(struct
 usb_device_id)=24 is not a modulo of the size of section
 __mod_usb_device_table=44.
Message-ID: <20120615201021.GB14544@kroah.com>
References: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 07:42:08PM +0200, Geert Uytterhoeven wrote:
> commit 81df2d594340dcb6d1a02191976be88a1ca8120c ("USB: allow match
> on bInterfaceNumber") added a byte to the interior of struct usb_device_id,
> enabling implicit padding:
> 
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -115,6 +118,9 @@ struct usb_device_id {
>         __u8            bInterfaceSubClass;
>         __u8            bInterfaceProtocol;
> 
> +       /* Used for vendor-specific interface matches */
> +       __u8            bInterfaceNumber;
> +
>         /* not matched against */
>         kernel_ulong_t  driver_info;
>  };
> 
> On m68k, this causes failures like:
> 
> | FATAL: drivers/gpu/drm/udl/udl: sizeof(struct usb_device_id)=24 is
> not a modulo of the size of section __mod_usb_device_table=44.
> | Fix definition of struct usb_device_id in mod_devicetable.h
> 
> M68k is special in that it uses 2 for the alignment of 32-bit entities, hence
> sizeof(struct usb_device_id) = 22.
> 
> However, when cross-compiling on amd64, sizeof(struct usb_device_id) = 24
> in scripts/mod/file2alias.c.

I don't really understand, what is the problem here?  The fact that we
added one byte to the structure?  And now something breaks?  How?

What can we do to resolve it?

confused,

greg k-h
