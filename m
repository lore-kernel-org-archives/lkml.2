Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1LMWOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:14:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1LMWOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:14:35 -0500
Date: Tue, 13 Dec 2011 22:14:26 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] Jabra SPEAK 410 USB - no audio playback
Message-ID: <20111213221426.GG16692@amd.home.annexia.org>
References: <20111210142419.GC16692@amd.home.annexia.org>
 <20111210194539.GF16692@amd.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111210194539.GF16692@amd.home.annexia.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 07:45:39PM +0000, Richard W.M. Jones wrote:

> diff -uNrp kernel-3.1.fc16.orig/sound/usb/stream.c kernel-3.1.fc16.new/sound/usb/stream.c
> --- kernel-3.1.fc16.orig/sound/usb/stream.c	2011-12-10 18:03:29.658729051 +0000
> +++ kernel-3.1.fc16.new/sound/usb/stream.c	2011-12-10 18:08:41.468694907 +0000
> @@ -164,6 +164,12 @@ static int parse_uac_endpoint_attributes
>  
>  	csep = snd_usb_find_desc(alts->endpoint[0].extra, alts->endpoint[0].extralen, NULL, USB_DT_CS_ENDPOINT);
>  
> +	/* Jabra SPEAK 410 USB has CS_ENDPOINT before ordinary ENDPOINT,
> +	 * which confuses the USB descriptor parsing code.  Try looking
> +	 * for CS_ENDPOINT in the interface->extra - RWMJ. */
> +	if (!csep)
> +		csep = snd_usb_find_desc(alts->extra, alts->extralen, NULL, USB_DT_CS_ENDPOINT);
> +
>  	/* Creamware Noah has this descriptor after the 2nd endpoint */
>  	if (!csep && altsd->bNumEndpoints >= 2)
>  		csep = snd_usb_find_desc(alts->endpoint[1].extra, alts->endpoint[1].extralen, NULL, USB_DT_CS_ENDPOINT);


Anyone?  Tested on two different machines and it fixes the
audio output problem on both ...  If I've sent this to the
wrong list please let me know.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming blog: http://rwmj.wordpress.com
Fedora now supports 80 OCaml packages (the OPEN alternative to F#)
http://cocan.org/getting_started_with_ocaml_on_red_hat_and_fedora
