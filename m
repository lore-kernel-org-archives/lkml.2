Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab2CDXP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 18:15:28 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:10189
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216Ab2CDXP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 18:15:26 -0500
X-SpamScore: -18
X-BigFish: VS-18(zz9371I936eK542M1432N98dKzz1202hzz8275bhz2fh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Topic: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Index: AQHM+LUYOjJW5Du7G0WJSaUrHj4mnJZaMjYAgAABLDA=
Date: Sun, 4 Mar 2012 23:15:07 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B74A8EE@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
 <1330870770.2858.4.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1330870770.2858.4.camel@dabdike.int.hansenpartnership.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q24NFegQ028423



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Sunday, March 04, 2012 9:20 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org; Haiyang Zhang
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> the host
> 
> On Fri, 2012-03-02 at 12:49 -0800, K. Y. Srinivasan wrote:
> > Windows hosts don't handle the ATA_16 command; don't pass it to the host.
> 
> What do you mean by this?  Most SCSI devices don't handle ATA_16 because
> it's only useful if the device is actually an ATA device behind a
> bridge.
> 
> As a general rule, you shouldn't filter in the driver commands you think
> the host won't want to see, you should let the host reply with an error
> code.  You should *only* filter commands that cause an actual bug in the
> host.  Is the latter the case for this command (if so that needs to be
> explained)?

As I explained in my email to Christoph, the Windows host returns error codes that
I cannot properly decode as being "unsupported opcode". Let me investigate a little more
and see if I can properly analyze the failure and return the correct error code up. If the error code
I get back from Windows is such that I cannot deduce the cause of the failure, then apart from filtering
the commands in the outgoing path, I am not sure what my options are.
 
> 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> This signoff chain doesn't make sense, since you're sending me the patch
> and apparently you authored it.

Good point. Since I came to MSFT, this has been the practice here - 
all the patches were reviewed and "signed-off" by all the relevant developers
independent of the authorship and Greg seemed ok with it and has been ascribing
ownership based on the person sending the patch who is always the author of the
patch. How would you recommend we change this practice. 

Regards,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
