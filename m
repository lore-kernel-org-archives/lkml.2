Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab2CDOXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 09:23:34 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:36757 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941Ab2CDOXc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 09:23:32 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzzz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Topic: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Index: AQHM+LUYOjJW5Du7G0WJSaUrHj4mnJZZ3GmAgABVn8A=
Date: Sun, 4 Mar 2012 14:23:28 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B74886F@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
 <20120304091225.GA27297@infradead.org>
In-Reply-To: <20120304091225.GA27297@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Sunday, March 04, 2012 4:12 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> Haiyang Zhang
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> the host
> 
> On Fri, Mar 02, 2012 at 12:49:07PM -0800, K. Y. Srinivasan wrote:
> > Windows hosts don't handle the ATA_16 command; don't pass it to the host.
> 
> Most devices don't handle it, and answer with and unsupported opcode
> sense reason.  If hyperv iis buggy enough to crap out on it please add
> a comment explaining that.

The host does not "crap out", it does return an error code but it is not "unsupported opcode".
The sense reason that comes back is a generic error SRB_STATUS code. It is easier for me to filter the
command on the outgoing side as opposed to dealing with a generic error code that is coming back from
the host.

Regards,

K. Y 

