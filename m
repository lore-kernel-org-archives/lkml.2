Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab1GGTtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:49:01 -0400
Received: from wnohang.net ([178.79.154.173]:57195 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab1GGTtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:49:00 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 4EFDEF0009
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net A63C1F0003
Date: Fri, 8 Jul 2011 01:18:51 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, jeremy.fitzhardinge@citrix.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [Xen-devel] Re: [PATCH] Modpost section mismatch fix
Message-ID: <20110707194851.GB4394@Xye>
References: <20110703232508.GB4440@Xye>
 <1309769388.634.51.camel@zakaz.uk.xensource.com>
 <20110704221646.GB4490@Xye>
 <20110705141323.GG2972@dumpdata.com>
 <20110705142731.GA4463@Xye>
 <20110705144846.GA13548@dumpdata.com>
 <20110705213243.GA3647@dumpdata.com>
 <20110707154648.GA4394@Xye>
 <20110707162454.GA8164@dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <20110707162454.GA8164@dumpdata.com>
X-Operating-System: Arch linux x86_64 3.0.0-rc5-LYM
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

* On Thu, Jul 07, 2011 at 12:24:54PM -0400, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> Tested it. Works now.
>
>Ok, Stuck Tested-by on the patch. Hopefully Linus hasn't pulled it yet.
Ok.
>
>> Reviewed-by: Raghavendra Prabhu <rprabhu@wnohang.net>

>> Also,
>> The condition for acpi_gsi_to_irq can be removed since it always returns zero.
>
>The function might in the future return something that is non-zero
>and we should guard for it. Also you make 'irq' be unsigned which is not
>good as the IRQ 0 is a valid value - and with making it unsigned if it is
>set to -1 (the -1 is the invalid IRQ value) the check for 'irq != gsi'
>will be true and and we will pass in -1 casted to unsigned. That is a
>large value and not the right thing we want to pass to xen_register_gsi.

My rationale for the unsigned part was that acpi_gsi_to_irq always
assigns a positive value (>= 0) to the irq passed (as unsigned
argument). But even otherwise that shouldn't make much of difference I guess.

Also,
I had sent another change (oneline) for the file
arch/x86/xen/platform-pci-unplug.c for check_platform_magic, looks like that has not gone into
the pull request for Linus.
>
>
>> ============================================
>>  diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
>>  index f567965..3faa55b 100644
>>  --- a/arch/x86/pci/xen.c
>>  +++ b/arch/x86/pci/xen.c
>>  @@ -405,7 +405,7 @@ static __init void xen_setup_acpi_sci(void)
>>          int rc;
>>          int trigger, polarity;
>>          int gsi = acpi_sci_override_gsi;
>>  -       int irq = -1;
>>  +       unsigned int irq = 0u;
>>          int gsi_override = -1;

>>          if (!gsi)
>>  @@ -435,11 +435,10 @@ static __init void xen_setup_acpi_sci(void)
>>           * setup as we had setup IRQ 20 for it).
>>           */
>>          /* Check whether the GSI != IRQ */
>>  -       if (acpi_gsi_to_irq(gsi, &irq) == 0) {
>>  -               if (irq >= 0 && irq != gsi)
>>  -                       /* Bugger, we MUST have that IRQ. */
>>  -                       gsi_override = irq;
>>  -       }
>>  +       acpi_gsi_to_irq(gsi, &irq);
>>  +       if (irq != gsi)
>>  +               /* Bugger, we MUST have that IRQ. */
>>  +               gsi_override = irq;

>>          gsi = xen_register_gsi(gsi, gsi_override, trigger, polarity);
>>          printk(KERN_INFO "xen: acpi sci %d\n", gsi);


>> --------------------------
>> Raghavendra Prabhu
>> GPG Id : 0xD72BE977
>> Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
>> www: wnohang.net
>
>
>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xensource.com
>> http://lists.xensource.com/xen-devel
>
--------------------------
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQEcBAEBAgAGBQJOFg2jAAoJEKYW3KHXK+l33tYH/268oryCWI2noF5U5UOYBbJf
37sCIRz9X8GTF90Ki41M1tDIt/+GKpYh1nmBHhkL774mjEQWURQrNz6MFwB2uTQy
rlSsOkqWCJe+NFDJLC3NepaMGy0jZbCaytcDYXIqRAXjd+JWBp+AjvoMYjPO57gr
WecZwc8NWMaiB9WMqozADxF1fqiKQUYwkVv4/7SDVSwfocG2/uAD1/9aaGq1ZfDp
1ZSY/O1ldKsbu2t/qXR/NX4V/LJ0Z+Y+CQGpYcn32scR8ming8Twy8IPZkJOaN2/
uOZgcg5jkcM+wNmVYHpyl8VJEi9JXCRfwzX/+4Ni2TwNHgqWAAe86LlmS+MIT1o=
=RHDq
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
