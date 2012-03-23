Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab2CWPug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 11:50:36 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:35345 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754872Ab2CWPue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 11:50:34 -0400
X-SpamScore: -18
X-BigFish: VS-18(zz9371I936eK542M1432N98dKzz1202hzz8275dhz2fh2a8h668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
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
Thread-Index: AQHNBWQK0XOEnDzC00OM+NEv/bIVW5Zxy24AgAAHRECAAGULgIAAANywgACp9gCAAFzJwIAEzruw
Date: Fri, 23 Mar 2012 15:50:04 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B76AF70@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1332115915-26805-1-git-send-email-kys@microsoft.com>
	 <1332115963-26855-1-git-send-email-kys@microsoft.com>
	 <1332173560.3152.65.camel@dabdike>
	 <6E21E5352C11B742B20C142EB499E0481B769E88@TK5EX14MBXC126.redmond.corp.microsoft.com>
	 <1332196819.3152.77.camel@dabdike>
	 <6E21E5352C11B742B20C142EB499E0481B76A16D@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <1332233502.14019.14.camel@dabdike.int.hansenpartnership.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.76]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2NFokiR030789



> -----Original Message-----
> From: KY Srinivasan
> Sent: Tuesday, March 20, 2012 10:42 AM
> To: 'James Bottomley'
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: RE: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result correctly
> when SRB status is INVALID
> 
> 
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> > Sent: Tuesday, March 20, 2012 4:52 AM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> > scsi@vger.kernel.org
> > Subject: RE: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result
> correctly
> > when SRB status is INVALID
> >
> > On Mon, 2012-03-19 at 22:52 +0000, KY Srinivasan wrote:
> > > > >  However, keep in mind
> > > > > that there is no current ETA on when Windows will ship with these
> changes
> > -
> > > > Windows 8
> > > > > may ship with code where they would return an invalid SRB status, but
> they
> > are
> > > > not
> > > > > setting the sense code, hence this patch. When the Window host does
> the
> > > > "right thing"
> > > > > I will clean this up, but I don't know when that will be.
> > > >
> > > > I thought you just said you'd only just asked them if they could
> > > > implemented it, in which case no version of windows currently ships with
> > > > this, correct?
> > >
> > > There are some private builds of windows 8 floating around with this change,
> > where
> > > they are returning ILLEGAL_REQUEST SRB status  without any sense data.
> >
> > Sure, but they're not shipped, right ... it's like the test builds we do
> > for large companies like IBM and HP to try out certain things before
> > deciding they don't work.
> 
> They are close to shipping and it is very difficult to get any changes in
> presently. Furthermore, this is only on windows8; none of the prior
> versions of windows servers of interest support this. I am starting an effort to
> get this change into prior windows servers. Once again, it is not clear when
> these changes will be pushed out.
> 
> 
> >
> > > > > More importantly, the second patch  in this series where I filter out
> > > > > the ATA_16 command
> > > > > on the guest is really important for us. Without that patch on a range
> > > > > on windows hosts
> > > > > including the current beta version of windows8 where the host is
> > > > > returning a generic
> > > > > error in response to ATA_16 command, we cannot boot many Linux
> > > > > distros. If you
> > > > > prefer, I can drop the first patch and re-submit the second patch for
> > > > > consideration now.
> > > >
> > > > I'm not sure about that either.  You presumably translate
> > > > SRB_STATUS_ERROR into DID_TARGET_FAILURE.  That should cause the
> > > > termination of the command with prejudice in exactly the same way as an
> > > > ILLEGAL_REQUEST sense code would (minus the useful error information),
> > > > so what's causing the boot failure?
> > >
> > > You are right, currently without a proper SRB code, I do a
> DID_TARGET_FAILURE
> > and
> > > this results in the device being offlined and if the device happens to be the
> root
> > device,
> > > we obviously cannot boot. I have seen this problem with sles11 sp2 on a win8
> > box.
> >
> > OK, so this may be the root cause of the problem.  DID_TARGET_FAILURE
> > returns FAILED from scsi_decide_disposition().  This wakes up the error
> > handler to retry the command and, since the command is never going to
> > work, this ends up offlining the device.  The same thing will happen for
> > every command with no recovery.
> >
> > The question now is, what else returns SRB_STATUS_ERROR?  If it's always
> > for stuff that's unretryable, then the DID_ error is wrong and you
> > should be returning DID_PASSTHROUGH with an error code and the problem
> > will be solved.  If we can get SRB_STATUS_ERROR on retryable commands,
> > then you discriminate at the point of failure, not at the point of input
> > and return DID_TARGET_FAILURE for the ones that should be retried and
> > DID_PASSTHROUGH + error for the ones that shouldn't.  This will ensure
> > the driver is completely backwards compatible and that it will work
> > if/when windows properly handles the commands.
> 
> James, unfortunately based on the current SRB codes I get back from the
> host, I don't know which commands that failed ought to be retried and which
> ones should not be; I simply get a single SRB error code for cases where the
> host filtered the unsupported commands as well as the case where the host
> supported the command and something failed in the command execution.
> If there is something I can try in this driver to fix this problem, I am more than
> happy to try it. If it involves getting changes into  the host (win8, win2k8 etc.),
> I am willing to start a conversation with the relevant teams, but I cannot
> obviously determine when such changes will ship. However, I do need
> solution for the problem now.
> 
> I appreciate your taking the time to help me gravitate towards the
> correct solution here. Given my constraints, let me know what is the
> best way forward here.

Ping.

Regards,

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
