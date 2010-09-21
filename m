Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0IUDyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 23:54:44 -0400
Received: from kroah.org ([198.145.64.141]:46275 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545Ab0IUDyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 23:54:43 -0400
Date: Mon, 20 Sep 2010 20:54:35 -0700
From: Greg KH <greg@kroah.com>
To: Nohee Ko <noheek@broadcom.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roman Baker <romanb@broadcom.com>, David Milne <davidm@broadcom.com>,
        Venkat Rao <vrao@broadcom.com>, Howard Harte <hharte@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: add fullmac driver
Message-ID: <20100921035435.GA31538@kroah.com>
References: <1284736810-2940-1-git-send-email-tim.gardner@canonical.com>
 <FD96C117992C584DBC47231B1EB6F5568206497F85@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FD96C117992C584DBC47231B1EB6F5568206497F85@SJEXCHCCR02.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 07:43:22PM -0700, Nohee Ko wrote:
> This patch to the existing bcm80211 directory in the staging tree adds fullmac driver support for the BCM4329 SDIO chip from Broadcom. Configuration of the mac80211 driver or the fullmac driver can be done through menuconfig.

Please wrap your lines at 72 columns.

Your patch does not apply to the latest linux-next tree.  Your patch is
also mime-encoded which probably doesn't help things.

Care to fix this up and resend it so I can apply it?

> --- a/drivers/staging/brcm80211/util/siutils.c
> +++ b/drivers/staging/brcm80211/util/siutils.c
> @@ -59,12 +59,16 @@ static bool si_buscore_prep(si_info_t *sii, uint bustype, uint devid,
>                             void *sdh);
>  static bool si_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
>                              uint32 savewin, uint *origidx, void *regs);
> +#ifndef BRCM_FULLMAC
>  static void si_nvram_process(si_info_t *sii, char *pvars);
> +#endif
> 
>  /* dev path concatenation util */
> +#ifndef BRCM_FULLMAC

<snip>

Why all the #ifdef mess added to the siutils.c file?  Is it really
needed?  Why not just leave it alone and have the functions always
build.

thanks,

greg k-h
