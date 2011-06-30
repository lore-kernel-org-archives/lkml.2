Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1F3T7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:59:32 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:55343 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab1F3T73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:59:29 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 38/40] Staging: hv: storvsc: Fixup srb_status for
 INQUIRY and MODE_SENSE
Thread-Topic: [PATCH 38/40] Staging: hv: storvsc: Fixup srb_status for
 INQUIRY and MODE_SENSE
Thread-Index: AQHMNmgKIdhbK1f7mUWDaxtsqb4cCZTWxb0A//+NPVA=
Date: Thu, 30 Jun 2011 19:59:28 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480816C27C@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-38-git-send-email-kys@microsoft.com>
 <20110630194754.GG22707@infradead.org>
In-Reply-To: <20110630194754.GG22707@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, June 30, 2011 3:48 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> Abhishek Kane (Mindtree Consulting PVT LTD); Hank Janssen
> Subject: Re: [PATCH 38/40] Staging: hv: storvsc: Fixup srb_status for INQUIRY and
> MODE_SENSE
> 
> On Wed, Jun 29, 2011 at 07:39:35AM -0700, K. Y. Srinivasan wrote:
> > The current handler on the Windows Host does not correctly handle
> > INQUIRY and MODE_SENSE commands with some options. Fixup srb_status
> > in these cases since the failure is not fatal.
> 
> > +	/*
> > +	 * The current SCSI handling on the host side does
> > +	 * not correctly handle:
> > +	 * INQUIRY command with page code parameter set to 0x80
> > +	 * MODE_SENSE command with cmd[2] == 0x1c
> > +	 *
> > +	 * Setup srb status so this won't be fatal.
> > +	 */
> > +
> > +	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
> > +	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE))
> > +		vstor_packet->vm_srb.srb_status = 0;
> 
> Given that the srb_status is only used for debug printks I don't
> quite see the point.  If people explicitly turn on debugging they
> should see that these commands fail, shouldn't they?
> 
The reason I did this was so that  I could key off  on real failures indicated by
srb_status == 0x4 to off-line the device.

Regards,

K. Y
