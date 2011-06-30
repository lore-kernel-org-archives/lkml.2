Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1F3Xci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 19:32:38 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:23264 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1F3Xcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 19:32:36 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/40] Staging: hv: Driver cleanup
Thread-Topic: [PATCH 00/40] Staging: hv: Driver cleanup
Thread-Index: AQHMNmfj17zjqSVuBEq2aM1XFV3FGpTWwcoA///MScA=
Date: Thu, 30 Jun 2011 23:32:34 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480816C384@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <20110630193346.GA22707@infradead.org>
In-Reply-To: <20110630193346.GA22707@infradead.org>
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
> Sent: Thursday, June 30, 2011 3:34 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/40] Staging: hv: Driver cleanup
> 
> On Wed, Jun 29, 2011 at 07:38:21AM -0700, K. Y. Srinivasan wrote:
> > Further cleanup of the hv drivers:
> >
> > 	1) Cleanup the reference counting mess for both stor and net devices.
> 
> I really don't understand the need for reference counting on the storage
> side, especially now that you only have a SCSI driver.  The SCSI
> midlayer does proper counting on it's objects (Scsi_Host, scsi_device,
> scsi_cmnd), so you'll get that for free given that SCSI drivers just
> piggyback on the midlayer lifetime rules.
> 
> For now your patches should probably go in as-is, but mid-term you
> should be able to completely remove that code on the storage side.
> 

Greg,

I am thinking of  going back to my original implementation where I had one scsi host
per IDE device. This will certainly simply the code. Let me know what you think. If you
agree with this approach, please drop this patch-set, I will send you a new set of patches.

Regards,

K. Y
