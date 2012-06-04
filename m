Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679Ab2FDN5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:57:10 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:20815
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754590Ab2FDN5H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:57:07 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzzz2fh2a8h683h839h944hd25hf0ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Victor Miasnikov <vvm@tut.by>, Greg KH <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jonathan Nieder <jrnieder@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Sterling <mike.sterling@microsoft.com>
Subject: RE: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the
 Hyper-V drivers by default 2) db63a4c8115a libata: add a host flag to ignore
 detected ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE
 disks devices ( but not for the ...
Thread-Topic: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the
 Hyper-V drivers by default 2) db63a4c8115a libata: add a host flag to ignore
 detected ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE
 disks devices ( but not for the ...
Thread-Index: AQHNQA/ykGE+y/YEIE6E+ePj3G2bhJblpN/xgAABmYCAAC978IAAZl6AgAPgITeAABY4UA==
Date: Mon, 4 Jun 2012 13:56:37 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF90710CAD0@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <20120527010903.GA18244@kroah.com>
 <B4A84D892D5742FE83F71F788F6EAF48@local.st.by>
 <20120528203518.GA12623@kroah.com>
 <5EBD7E368EFE4B5CABF4AC528058A4DB@local.st.by>
 <20120601092017.GE22821@kroah.com>
 <59CBCFF13ABD41B682835DD5E4851BC1@local.st.by>
 <20120601162629.GA11812@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF90710C295@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120602012249.GA7783@kroah.com>
 <ACB4012399AF4F20A8DAECA154E96ED3@local.st.by>
In-Reply-To: <ACB4012399AF4F20A8DAECA154E96ED3@local.st.by>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.53.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%TUT.BY$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Victor Miasnikov [mailto:vvm@tut.by]
> Sent: Monday, June 04, 2012 8:33 AM
> To: Greg KH; KY Srinivasan
> Cc: stable@vger.kernel.org; Jonathan Nieder; linux-kernel@vger.kernel.org;
> Mike Sterling
> Subject: Re: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the Hyper-
> V drivers by default 2) db63a4c8115a libata: add a host flag to ignore detected
> ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE disks devices
> ( but not for the ...
> 
> Hi!
> 
> VVM > > > Hyper-V admins need _worked_ Linux v3.4.X / v3.3.X / v3.2.X

Victor, what distro are you using. I can help you with the ata patch on specific set of distros of interest. 
If the system that you are interested loads the ata_piix module, we can solve the issue on hand using
modprobe rules rather than a patch against the ata driver. Let me know.

Regards,

K. Y 
> 



