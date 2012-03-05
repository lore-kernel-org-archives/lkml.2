Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2CEC3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 21:29:18 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:33381
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab2CEC3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 21:29:16 -0500
X-SpamScore: -18
X-BigFish: VS-18(zz9371I936eK542M1432N98dKzz1202hzzz2fh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Christoph Hellwig <hch@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Topic: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Index: AQHM+LUYOjJW5Du7G0WJSaUrHj4mnJZZ3GmAgABVn8CAAAhLgIAAwj0A
Date: Mon, 5 Mar 2012 02:29:11 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B74B90D@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
	 <20120304091225.GA27297@infradead.org>
	 <6E21E5352C11B742B20C142EB499E0481B74886F@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <1330872513.2858.14.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1330872513.2858.14.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q252TUla029021



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Sunday, March 04, 2012 9:49 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; linux-scsi@vger.kernel.org;
> Haiyang Zhang
> Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> the host
> 
> On Sun, 2012-03-04 at 14:23 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Christoph Hellwig [mailto:hch@infradead.org]
> > > Sent: Sunday, March 04, 2012 4:12 AM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org;
> ohering@suse.com;
> > > jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> > > Haiyang Zhang
> > > Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> > > the host
> > >
> > > On Fri, Mar 02, 2012 at 12:49:07PM -0800, K. Y. Srinivasan wrote:
> > > > Windows hosts don't handle the ATA_16 command; don't pass it to the
> host.
> > >
> > > Most devices don't handle it, and answer with and unsupported opcode
> > > sense reason.  If hyperv iis buggy enough to crap out on it please add
> > > a comment explaining that.
> >
> > The host does not "crap out", it does return an error code but it is not
> "unsupported opcode".
> > The sense reason that comes back is a generic error SRB_STATUS code. It is
> easier for me to filter the
> > command on the outgoing side as opposed to dealing with a generic error code
> that is coming back from
> > the host.
> 
> That's the wrong thing to do ... you need to unwrap the error code.

I will see if this is even possible based on the current error codes I get back.

> The reason being I presume it's not impossible for Windows to host a
> device supporting ATA_16 and there are signs that this is going to be
> necessary to prevent data corruption on some USB devices ... if you just
> filter the command without checking if the host supports it, you're
> going to end up perpetuating the corruption problem.

We are talking of virtual  block devices exposed to Linux guests running on a Windows
hosts. I don't think they will ever need to support ATA_16 command on these virtual block
devices. I will however confirm with the Windows team.


Regards,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
