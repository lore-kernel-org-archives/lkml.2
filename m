Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2KHPaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:30:21 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55559 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab2KHPaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:30:20 -0500
Date: Thu, 8 Nov 2012 09:28:35 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Matthew Fioravante <matthew.fioravante@jhuapl.edu>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] add tpm_xenu.ko: Xen Virtual TPM frontend
 driver
Message-ID: <20121108152835.GA28612@ennui.austin.ibm.com>
References: <1352128197-1539-1-git-send-email-matthew.fioravante@jhuapl.edu>
 <20121107144625.GA14628@ennui.austin.ibm.com>
 <509AA501.1090701@jhuapl.edu>
 <509B78AC02000078000A723C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509B78AC02000078000A723C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110815-5806-0000-0000-00001B8E38A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 08:17:32AM +0000, Jan Beulich wrote:
> >>> On 07.11.12 at 19:14, Matthew Fioravante <matthew.fioravante@jhuapl.edu> wrote:
> > On 11/07/2012 09:46 AM, Kent Yoder wrote:
> >>> --- a/drivers/char/tpm/tpm.h
> >>> +++ b/drivers/char/tpm/tpm.h
> >>> @@ -130,6 +130,9 @@ struct tpm_chip {
> >>>
> >>>   	struct list_head list;
> >>>   	void (*release) (struct device *);
> >>> +#if CONFIG_XEN
> >>> +	void *priv;
> >>> +#endif
> >>   Can you use the chip->vendor.data pointer here instead? tpm_ibmvtpm is
> >> already using that as a priv pointer. I should probably change that name
> >> to make it more obvious what that's used for.
> > That makes more sense. I'm guessing your data pointer didn't exist 
> > during the 2.6.18 kernel which is why they added their own priv pointer.
> 
> It got introduced with 3.7-rc.
> 
> >>> @@ -310,6 +313,18 @@ struct tpm_cmd_t {
> >>>
> >>>   ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
> >>>
> >>> +#ifdef CONFIG_XEN
> >>> +static inline void *chip_get_private(const struct tpm_chip *chip)
> >>> +{
> >>> +	return chip->priv;
> >>> +}
> >>> +
> >>> +static inline void chip_set_private(struct tpm_chip *chip, void *priv)
> >>> +{
> >>> +	chip->priv = priv;
> >>> +}
> >>> +#endif
> >>   Can you put these in tpm_vtpm.c please?  One less #define. :-)
> > Agreed, I'd rather not have to modify your shared tpm.h interface at all.
> 
> Either such accessors should be defined here, for everyone to
> use (and tpm_ibmvtpm.c get changed accordingly), or the Xen
> code should access the field without wrappers too (for consistency).

  Agreed. I'll update tpm_ibmvtpm.

Kent

> 
> Jan
> 

