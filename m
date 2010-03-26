Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0CZBpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:45:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33577 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0CZBpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XOi//LvCcgHps+VyOYwOBPhCLrjRF59MTdU2/jD24T5W3gxjYHSDhY48YPnnTVnHQx
         uynOClnEiD9JEUE0wSr6P2lLwg86Esdl18+0tgcUmoEDPWQa5afkISfIWpftk/q7G2m6
         1Mf2GF5PPZ9WuhZ/Q/YHPVc9k8/tPBn+AealQ=
MIME-Version: 1.0
In-Reply-To: <20100326104042T.fujita.tomonori@lab.ntt.co.jp>
References: <1269401628.18314.264.camel@localhost>
	 <20100326104042T.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 26 Mar 2010 11:45:50 +1000
Message-ID: <21d7e9971003251845i24af9712qb64aa3ca5f8f042c@mail.gmail.com>
Subject: Re: [PATCH 1/2] sis-agp: Remove SIS 760, handled by amd64-agp
From: Dave Airlie <airlied@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: ben@decadent.org.uk, airlied@linux.ie, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 11:41 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Wed, 24 Mar 2010 03:33:48 +0000
> Ben Hutchings <ben@decadent.org.uk> wrote:
>
>> SIS 760 is listed in the device tables for both amd64-agp and sis-agp.
>> amd64-agp is apparently preferable since it has workarounds for some
>> BIOS misconfigurations that sis-agp doesn't handle.
>>

Will this not cause problems in 32-bit kernels?

Dave.

>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>> ---
>>  drivers/char/agp/sis-agp.c |    8 --------
>>  1 files changed, 0 insertions(+), 8 deletions(-)
>
> Looks fine to me. Hopefully, amd64-agp can handle all SIS 760 systems.
>
> Can we confirm that this can fix bugs reported in Debian's bug
> tracking system (which you mentioned earlier)?
>
>
>> diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
>> index 6c3837a..95fdd4d 100644
>> --- a/drivers/char/agp/sis-agp.c
>> +++ b/drivers/char/agp/sis-agp.c
>> @@ -415,14 +415,6 @@ static struct pci_device_id agp_sis_pci_table[] = {
>>               .subvendor      = PCI_ANY_ID,
>>               .subdevice      = PCI_ANY_ID,
>>       },
>> -     {
>> -             .class          = (PCI_CLASS_BRIDGE_HOST << 8),
>> -             .class_mask     = ~0,
>> -             .vendor         = PCI_VENDOR_ID_SI,
>> -             .device         = PCI_DEVICE_ID_SI_760,
>> -             .subvendor      = PCI_ANY_ID,
>> -             .subdevice      = PCI_ANY_ID,
>> -     },
>>       { }
>>  };
>>
>> --
>> 1.7.0
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
