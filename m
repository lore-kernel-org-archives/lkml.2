Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2KHWGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 17:06:16 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35432 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab2KHWGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 17:06:15 -0500
MIME-Version: 1.0
In-Reply-To: <068F06DC4D106941B297C0C5F9F446EA48A229E6FD@aplesstripe.dom1.jhuapl.edu>
References: <1352128197-1539-1-git-send-email-matthew.fioravante@jhuapl.edu>
	<20121107144625.GA14628@ennui.austin.ibm.com>
	<509AA501.1090701@jhuapl.edu>
	<509B78AC02000078000A723C@nat28.tlf.novell.com>
	<20121108152835.GA28612@ennui.austin.ibm.com>
	<068F06DC4D106941B297C0C5F9F446EA48A229E6FD@aplesstripe.dom1.jhuapl.edu>
Date: Thu, 8 Nov 2012 16:06:14 -0600
Message-ID: <CAM0nabEZw1t64mZgcB7SGRUMyKt3P41UpZZQxGuJYdYr=Fn+=g@mail.gmail.com>
Subject: Re: [tpmdd-devel] [Xen-devel] [PATCH] add tpm_xenu.ko: Xen Virtual
 TPM frontend driver
From: Kent Yoder <shpedoikal@gmail.com>
To: "Fioravante, Matthew E." <Matthew.Fioravante@jhuapl.edu>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, Jan Beulich <JBeulich@suse.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 9:36 AM, Fioravante, Matthew E.
<Matthew.Fioravante@jhuapl.edu> wrote:
>> >>> On 07.11.12 at 19:14, Matthew Fioravante <matthew.fioravante@jhuapl.edu> wrote:
>> > On 11/07/2012 09:46 AM, Kent Yoder wrote:
>> >>> --- a/drivers/char/tpm/tpm.h
>> >>> +++ b/drivers/char/tpm/tpm.h
>> >>> @@ -130,6 +130,9 @@ struct tpm_chip {
>> >>>
>> >>>           struct list_head list;
>> >>>           void (*release) (struct device *);
>> >>> +#if CONFIG_XEN
>> >>> + void *priv;
>> >>> +#endif
>> >>   Can you use the chip->vendor.data pointer here instead?
>> >> tpm_ibmvtpm is already using that as a priv pointer. I should
>> >> probably change that name to make it more obvious what that's used for.
>> > That makes more sense. I'm guessing your data pointer didn't exist
>> > during the 2.6.18 kernel which is why they added their own priv pointer.
>>
>> It got introduced with 3.7-rc.
>>
>> >>> @@ -310,6 +313,18 @@ struct tpm_cmd_t {
>> >>>
>> >>>   ssize_t tpm_getcap(struct device *, __be32, cap_t *, const char *);
>> >>>
>> >>> +#ifdef CONFIG_XEN
>> >>> +static inline void *chip_get_private(const struct tpm_chip *chip)
>> >>> +{
>> >>> + return chip->priv;
>> >>> +}
>> >>> +
>> >>> +static inline void chip_set_private(struct tpm_chip *chip, void
>> >>> +*priv) {
>> >>> + chip->priv = priv;
>> >>> +}
>> >>> +#endif
>> >>   Can you put these in tpm_vtpm.c please?  One less #define. :-)
>> > Agreed, I'd rather not have to modify your shared tpm.h interface at all.
>>
>> Either such accessors should be defined here, for everyone to use (and
>> tpm_ibmvtpm.c get changed accordingly), or the Xen code should access
>> the field without wrappers too (for consistency).
>
>   Agreed. I'll update tpm_ibmvtpm.
>
> Kent
>
> So what is the consensus, you're going to use accessors in ibmvtpm? I was just about to remove them from my side.

  Yeah I'll use your accessor.  Just modify it to use
chip->vendor.data and I'll add suport to tpm_ibmvtpm after I integrate
your patch.

Thanks!
Kent

>>
>> Jan
>>
>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
>
> ------------------------------------------------------------------------------
> Everyone hates slow websites. So do we.
> Make your web apps faster with AppDynamics
> Download AppDynamics Lite for free today:
> http://p.sf.net/sfu/appdyn_d2d_nov
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel



-- 
IBM LTC Security
