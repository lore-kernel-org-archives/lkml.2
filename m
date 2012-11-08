Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab2KHIRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 03:17:37 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:42156 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab2KHIRf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Thu, 8 Nov 2012 03:17:35 -0500
Message-Id: <509B78AC02000078000A723C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 08 Nov 2012 08:17:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matthew Fioravante" <matthew.fioravante@jhuapl.edu>
Cc: "jeremy@goop.org" <jeremy@goop.org>, "Kent Yoder" <key@linux.vnet.ibm.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] add tpm_xenu.ko: Xen Virtual TPM
 frontend driver
References: <1352128197-1539-1-git-send-email-matthew.fioravante@jhuapl.edu>
 <20121107144625.GA14628@ennui.austin.ibm.com>
 <509AA501.1090701@jhuapl.edu>
In-Reply-To: <509AA501.1090701@jhuapl.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.11.12 at 19:14, Matthew Fioravante <matthew.fioravante@jhuapl.edu> wrote:
> On 11/07/2012 09:46 AM, Kent Yoder wrote:
>>> --- a/drivers/char/tpm/tpm.h
>>> +++ b/drivers/char/tpm/tpm.h
>>> @@ -130,6 +130,9 @@ struct tpm_chip {
>>>
>>>   	struct list_head list;
>>>   	void (*release) (struct device *);
>>> +#if CONFIG_XEN
>>> +	void *priv;
>>> +#endif
>>   Can you use the chip->vendor.data pointer here instead? tpm_ibmvtpm is
>> already using that as a priv pointer. I should probably change that name
>> to make it more obvious what that's used for.
> That makes more sense. I'm guessing your data pointer didn't exist 
> during the 2.6.18 kernel which is why they added their own priv pointer.

It got introduced with 3.7-rc.

>>> @@ -310,6 +313,18 @@ struct tpm_cmd_t {
>>>
>>>   ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
>>>
>>> +#ifdef CONFIG_XEN
>>> +static inline void *chip_get_private(const struct tpm_chip *chip)
>>> +{
>>> +	return chip->priv;
>>> +}
>>> +
>>> +static inline void chip_set_private(struct tpm_chip *chip, void *priv)
>>> +{
>>> +	chip->priv = priv;
>>> +}
>>> +#endif
>>   Can you put these in tpm_vtpm.c please?  One less #define. :-)
> Agreed, I'd rather not have to modify your shared tpm.h interface at all.

Either such accessors should be defined here, for everyone to
use (and tpm_ibmvtpm.c get changed accordingly), or the Xen
code should access the field without wrappers too (for consistency).

Jan

