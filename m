Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab2DYMvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:51:01 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:18397
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759155Ab2DYMu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:50:56 -0400
X-SpamScore: -23
X-BigFish: VS-23(zz9371I936eK542M154dM1432N98dKzz1202hzz8275bhz2fh2a8h683h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>
Subject: RE: [PATCH RESEND 1/1] Drivers: scsi: storvsc: Properly handle
 errors from the host
Thread-Topic: [PATCH RESEND 1/1] Drivers: scsi: storvsc: Properly handle
 errors from the host
Thread-Index: AQHNE2D+/mszzw7RBkKZE4dGKGbHP5aUMcDwgAxnfeCACsG5gIAAQg/g
Date: Wed, 25 Apr 2012 12:50:24 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF92D7187@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1333654012-23850-1-git-send-email-kys@microsoft.com>
	  <426367E2313C2449837CD2DE46E7EAF92CE74A@CH1PRD0310MB381.namprd03.prod.outlook.com>
 <1335343999.3075.12.camel@dabdike.lan>
In-Reply-To: <1335343999.3075.12.camel@dabdike.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.53.133]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%HANSENPARTNERSHIP.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3PCpCUm006618



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Wednesday, April 25, 2012 4:53 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> hch@infradead.org; linux-scsi@vger.kernel.org; apw@canonical.com
> Subject: RE: [PATCH RESEND 1/1] Drivers: scsi: storvsc: Properly handle errors
> from the host
> 
> On Wed, 2012-04-18 at 12:38 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: KY Srinivasan
> > > Sent: Tuesday, April 10, 2012 11:14 AM
> > > To: KY Srinivasan; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org;
> ohering@suse.com;
> > > jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> > > apw@canonical.com
> > > Subject: RE: [PATCH RESEND 1/1] Drivers: scsi: storvsc: Properly handle errors
> > > from the host
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> > > > Sent: Thursday, April 05, 2012 3:27 PM
> > > > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > > devel@linuxdriverproject.org; virtualization@lists.osdl.org;
> ohering@suse.com;
> > > > jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> > > > apw@canonical.com
> > > > Cc: KY Srinivasan
> > > > Subject: [PATCH RESEND 1/1] Drivers: scsi: storvsc: Properly handle errors
> from
> > > > the host
> > > >
> > > > If the host returns error for pass through commands, deal with them
> > > > appropriately. I would like to thank James for patiently helping
> > > > me with this patch.
> > >
> > > James,
> > >
> > > Thank you for suggesting the fix here. I hope this is what you were looking
> for.
> > >
> > > Regards,
> > >
> > > K. Y
> 
> OK, I have the patch, but the change log is a bit rubbish.  I changed it
> to
> 
> Hyper-V cannot process some commands like ATA_12 and ATA_16. It also returns
> a
> very generic error when this happens (SRB_STATUS_ERROR).  Most of the time
> we
> treat SRB_STATUS_ERROR as DID_TARGET_FAILURE which causes error handler
> retry,
> but in the case of pass through commands, they'll never succeed (and the error
> handler will offline the device), so put a discriminating block in the command
> completion routing and send the SRB_STATUS_ERROR upwards with
> DID_PASSTHROUGH
> for commands we know should not be retried.

Looks good; thanks James.

K. Y
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
