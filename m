Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2DRUX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:23:27 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:20102
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032Ab2DRUXY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:23:24 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzzz2fh2a8h683h839h944hd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andy Whitcroft <apw@canonical.com>, Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Sterling <mike.sterling@microsoft.com>
Subject: RE: [PATCH 0/2] Hyper-V disk support V3
Thread-Topic: [PATCH 0/2] Hyper-V disk support V3
Thread-Index: AQHNG8L5eorBDcMR7ka8gHqKq1D+A5adUAgAgAB2J4CAAAF/EIADP/uA////i4A=
Date: Wed, 18 Apr 2012 20:21:48 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF92CE8E2@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <20120414170223.24f6ea31@pyramind.ukuu.org.uk>
	<1334575229-7493-1-git-send-email-apw@canonical.com>
	<20120416122634.7d1357e1@ultron>	<20120416182927.GB3346@shadowen.org>
	<426367E2313C2449837CD2DE46E7EAF92CE0B5@CH1PRD0310MB381.namprd03.prod.outlook.com>
 <20120418211235.55b9befc@pyramind.ukuu.org.uk>
In-Reply-To: <20120418211235.55b9befc@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.53.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: CH1PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LXORGUK.UKUU.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%POBOX.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Wednesday, April 18, 2012 4:13 PM
> To: KY Srinivasan
> Cc: Andy Whitcroft; Jeff Garzik; linux-ide@vger.kernel.org; linux-
> kernel@vger.kernel.org; Mike Sterling
> Subject: Re: [PATCH 0/2] Hyper-V disk support V3
> 
> > The notion of "pass through" in Hyper-V  is a little different. IDE devices can be
> configured
> > under either one of the supported controllers and these devices can either be
> virtual disks
> > (VHDs) or physical disks. In either case these will be presented to the guest as
> IDE devices.
> 
> So what ensures that by skipping it at the ATA device level we will
> always find it as a VHD ?

If the Hyper-V storage driver is  present, then the Hyper-V storage driver will
manage the root device (and other devices skipped by the ata driver). 
So, the check if we are running on Hyper-V is not enough
to skip the device in the ata_piix driver; we need to also make sure that the Hyper-V
block driver is available to handle the skipped devices. I think the correct approach here is to
have a kernel (or an ata_piix module parameter) that can be set to override the skipping
of the block device by the ata driver. Distros that are including the Hyper-V storage driver
can set this parameter so that when running on Hyper-V, ata can skip the block device.

Regards,

K. Y
> 
> Alan
> 
> 



