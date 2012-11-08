Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2KHPhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:37:52 -0500
Received: from piper.jhuapl.edu ([128.244.251.37]:53334 "EHLO jhuapl.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751360Ab2KHPhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:37:51 -0500
From: "Fioravante, Matthew E." <Matthew.Fioravante@jhuapl.edu>
To: Kent Yoder <key@linux.vnet.ibm.com>, Jan Beulich <JBeulich@suse.com>
CC: "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>
Date: Thu, 8 Nov 2012 10:36:08 -0500
Subject: RE: [Xen-devel] [PATCH] add tpm_xenu.ko: Xen Virtual TPM frontend
 driver
Thread-Topic: [Xen-devel] [PATCH] add tpm_xenu.ko: Xen Virtual TPM frontend
 driver
Thread-Index: Ac29xlmdArK70cUQRNaO8Lj2jl7+6AAAFq6g
Message-ID: <068F06DC4D106941B297C0C5F9F446EA48A229E6FD@aplesstripe.dom1.jhuapl.edu>
References: <1352128197-1539-1-git-send-email-matthew.fioravante@jhuapl.edu>
	<20121107144625.GA14628@ennui.austin.ibm.com>	<509AA501.1090701@jhuapl.edu>
	<509B78AC02000078000A723C@nat28.tlf.novell.com>
 <20121108152835.GA28612@ennui.austin.ibm.com>
In-Reply-To: <20121108152835.GA28612@ennui.austin.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: xen-devel-bounces@lists.xen.org [mailto:xen-devel-bounces@lists.xen.org] On Behalf Of Kent Yoder
Sent: Thursday, November 08, 2012 10:29 AM
To: Jan Beulich
Cc: Fioravante, Matthew E.; jeremy@goop.org; xen-devel@lists.xensource.com; konrad.wilk@oracle.com; linux-kernel@vger.kernel.org; mail@srajiv.net; tpmdd-devel@lists.sourceforge.net
Subject: Re: [Xen-devel] [PATCH] add tpm_xenu.ko: Xen Virtual TPM frontend driver

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
> >>   Can you use the chip->vendor.data pointer here instead? 
> >> tpm_ibmvtpm is already using that as a priv pointer. I should 
> >> probably change that name to make it more obvious what that's used for.
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
> >>> +static inline void chip_set_private(struct tpm_chip *chip, void 
> >>> +*priv) {
> >>> +	chip->priv = priv;
> >>> +}
> >>> +#endif
> >>   Can you put these in tpm_vtpm.c please?  One less #define. :-)
> > Agreed, I'd rather not have to modify your shared tpm.h interface at all.
> 
> Either such accessors should be defined here, for everyone to use (and 
> tpm_ibmvtpm.c get changed accordingly), or the Xen code should access 
> the field without wrappers too (for consistency).

  Agreed. I'll update tpm_ibmvtpm.

Kent

So what is the consensus, you're going to use accessors in ibmvtpm? I was just about to remove them from my side.

> 
> Jan
> 


_______________________________________________
Xen-devel mailing list
Xen-devel@lists.xen.org
http://lists.xen.org/xen-devel
