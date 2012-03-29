Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab2C2Ou6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:50:58 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:56234
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758417Ab2C2Ous (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:50:48 -0400
X-SpamScore: -23
X-BigFish: VS-23(zz9371I936eK542M1432N98dK1447Mzz1202hzz8275dhz2fh2a8h683h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result
 correctly when SRB status is INVALID
Thread-Topic: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result
 correctly when SRB status is INVALID
Thread-Index: AQHNDYJM/LF40NHeUkOvv2k89n7iIZaBWyfw
Date: Thu, 29 Mar 2012 14:50:25 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF902244A@BY2PRD0310MB378.namprd03.prod.outlook.com>
References: <1332115915-26805-1-git-send-email-kys@microsoft.com>
	 <1332115963-26855-1-git-send-email-kys@microsoft.com>
	 <1332173560.3152.65.camel@dabdike>
	 <6E21E5352C11B742B20C142EB499E0481B769E88@TK5EX14MBXC126.redmond.corp.microsoft.com>
	 <1332196819.3152.77.camel@dabdike>
	 <6E21E5352C11B742B20C142EB499E0481B76A16D@TK5EX14MBXC126.redmond.corp.microsoft.com>
	 <1332233502.14019.14.camel@dabdike.int.hansenpartnership.com>
	 <6E21E5352C11B742B20C142EB499E0481B76AF70@TK5EX14MBXC126.redmond.corp.microsoft.com>
	 <1332749776.2836.15.camel@dabdike>
	 <6E21E5352C11B742B20C142EB499E0481B775A8A@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <1333008134.2823.15.camel@dabdike>
In-Reply-To: <1333008134.2823.15.camel@dabdike>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.29.242]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BY2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%HANSENPARTNERSHIP.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2TEp2LN006235



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Thursday, March 29, 2012 4:02 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: RE: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result correctly
> when SRB status is INVALID
> 
> On Tue, 2012-03-27 at 15:32 +0000, KY Srinivasan wrote:
> > > > > James, unfortunately based on the current SRB codes I get back from the
> > > > > host, I don't know which commands that failed ought to be retried and
> which
> > > > > ones should not be; I simply get a single SRB error code for cases where
> the
> > > > > host filtered the unsupported commands as well as the case where the
> host
> > > > > supported the command and something failed in the command
> execution.
> > > > > If there is something I can try in this driver to fix this problem, I am more
> than
> > > > > happy to try it. If it involves getting changes into  the host (win8, win2k8
> etc.),
> > > > > I am willing to start a conversation with the relevant teams, but I cannot
> > > > > obviously determine when such changes will ship. However, I do need
> > > > > solution for the problem now.
> > > > >
> > > > > I appreciate your taking the time to help me gravitate towards the
> > > > > correct solution here. Given my constraints, let me know what is the
> > > > > best way forward here.
> > > >
> > > > Ping.
> > >
> > > On what? What don't you understand about the above?
> > >
> > > The failure path needs to look like the following metacode
> > >
> > > case SRB_whatever
> > >
> > > if (retryable command)
> > > 	return DID_TARGET_FAILURE
> > > else
> > > 	setup sense and error
> > > 	return DID_PASSTHROUGH
> > >
> >
> > Thanks James and I am sorry for taking so much of your time. I suspect the
> check for
> > retryable commands is to be based on the sense data that might be available.
> Assuming
> > this is what you had in mind, as I look the  scsi_error.c, scsi_check_sense()
> appears to
> > do what I would need here. Would you be willing to take patch that exports this
> function.
> > Or, is there a better way to identify commands that would be re-tried.
> 
> Erm, no, I was thinking of something much more simple.  Right at the
> moment if (retryable_command) is if (scmnd->cmnd[0] != ATA_16)
> 
> Although I'm sure there are other commands that are not retryable ... I
> don't really know since I'm not sure what else your hypervisor will
> choke on.  It might be simpler to have a list of known good retryable
> commands (READ_ WRITE_ GET_CAPACITY_ INQUIRY etc. i.e. the commands sd
> normally uses) and assume anything outside that range isn't retryable
> but someone who knows what's going on in the hypervisor needs to decide
> this.
> 
> The point is that you don't pre-filter.  You send the command and then
> try and work out from the generic error and the type of command you sent
> what happened.  That way, if the hypervisor ever works properly (or
> simply passes commands through to real devices) it will "just work"
> rather than failing because of the pre-filter.
> 
> We should only use the pre-filter if the effects of the command are
> fatal (like we have to a lot in USB because the firmware crashes and
> hangs).

Thanks for the clarification. I will have the patch out shortly.

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
