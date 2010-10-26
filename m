Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981Ab0JZP7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:59:04 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57445 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0JZP7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=T5nIzNrUulJr0jcwKG33cg2f7EOwpo1vhpN7kNE1GvbsVAMvU1Otu1BwleKPBTnk1J
         HS92omOCpK921JMgSJ/jGkyiafM7E8QD4RBtiWg8SACsQRDT8nw4Lm6+g8H8xYTSLfPC
         iLA5ewiWDz53elIOLsyETnAvSkou1TrNb3O6k=
Date: Tue, 26 Oct 2010 08:56:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jon Dowland <jmtd@debian.org>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] toshiba_acpi.c: Add key_entry for a lone FN keypress
Message-ID: <20101026155653.GC13097@core.coreip.homeip.net>
References: <20101023221253.GA4829@hathor>
 <201010251127.37374.dmitry.torokhov@gmail.com>
 <20101026120026.GA27720@deckard.alcopop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101026120026.GA27720@deckard.alcopop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 01:00:26PM +0100, Jon Dowland wrote:
> On Mon, Oct 25, 2010 at 11:27:35AM -0700, Dmitry Torokhov wrote:
> > Well, if FN key can generate separate events then we should report
> > KEY_FN, not KEY_UNKNOWN.
> 
> Good point, thanks.  I missed that when I went shopping for an appropriate
> KEY_*.
> 
> Adjusted patch to apply on top of current HEAD.
> 
> A lone FN key press on a Toshiba Portégé R700 without another key in
> conjunction results in an ACPI event and a spurious error message on
> the console.
> 
> Add a key entry to map this event to a KEY_UNKNOWN keypress silences

                                         ^^^^^^
Better fix commit log message as well. Otherwise:

	Acked-by: Dmitry Torokhov <dtor@mail.ru>

(or whatever tag Matthew might want to change it).

> this message.
> 
> Signed-off-by: Jon Dowland <jmtd@debian.org>
> 
> ----
> --- a/drivers/platform/x86/toshiba_acpi.c	2010-10-26 12:56:46.000000000 +0100
> +++ b/drivers/platform/x86/toshiba_acpi.c	2010-10-26 12:58:21.000000000 +0100
> @@ -135,6 +135,7 @@
>  	{ KE_KEY, 0x141, { KEY_BRIGHTNESSUP } },
>  	{ KE_KEY, 0x142, { KEY_WLAN } },
>  	{ KE_KEY, 0x143, { KEY_PROG1 } },
> +	{ KE_KEY, 0x17f, { KEY_FN } },
>  	{ KE_KEY, 0xb05, { KEY_PROG2 } },
>  	{ KE_KEY, 0xb06, { KEY_WWW } },
>  	{ KE_KEY, 0xb07, { KEY_MAIL } },

-- 
Dmitry
