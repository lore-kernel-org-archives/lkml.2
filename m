Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab2DOAK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 20:10:29 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:58400
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755143Ab2DOAK1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 20:10:27 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzzz2fh2a8h683h839h944hd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Whitcroft <apw@canonical.com>
CC: Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Sterling <mike.sterling@microsoft.com>
Subject: RE: [PATCH 2/2] ata_piix: defer disks to the Hyper-V drivers by
 default
Thread-Topic: [PATCH 2/2] ata_piix: defer disks to the Hyper-V drivers by
 default
Thread-Index: AQHNGla+K/g+G/hpSUql86M1iBnOoZaae0eAgAB+sVA=
Date: Sun, 15 Apr 2012 00:10:18 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF92CCDDA@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <4F87351E.9040905@pobox.com>
	<1334418796-11473-1-git-send-email-apw@canonical.com>
	<1334418796-11473-3-git-send-email-apw@canonical.com>
 <20120414170223.24f6ea31@pyramind.ukuu.org.uk>
In-Reply-To: <20120414170223.24f6ea31@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.53.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: CH1PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LXORGUK.UKUU.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%POBOX.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Saturday, April 14, 2012 12:02 PM
> To: Andy Whitcroft
> Cc: Jeff Garzik; linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org; KY
> Srinivasan; Mike Sterling
> Subject: Re: [PATCH 2/2] ata_piix: defer disks to the Hyper-V drivers by default
> 
> O> +#ifdef CONFIG_X86
> > +	/* On Hyper-V hypervisors the disks are exposed on both the emulated
> > +	 * SATA controller and on the paravirtualised drivers.  The CD/DVD
> > +	 * devices are only exposed on the emulated controller.  Request we
> > +	 * ignore ATA devices on this host.
> > +	 */
> > +	if (prefer_ms_hyperv && x86_hyper == &x86_hyper_ms_hyperv) {
> > +		host->flags |= ATA_HOST_IGNORE_ATA;
> > +		dev_info(&pdev->dev, "Hyper-V hypervisor detected, ignoring
> ATA disks\n");
> > +	}
> > +#endif
> 
> Does hyper-v not set its own unique and identifable pci
> subvendor/subdevice ?

Number of elements of the virtual BIOS we present the guest can be used
to detect that we are running on Hyper-V. Additionally, we are exporting state based
on CPU detection which is what Andy is using here. As far as I know these are the only
ways to detect that we are running on Hyper-V. 

Regards,

K. Y
> 
> Alan
> 
> 



