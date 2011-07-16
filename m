Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1GPMyu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:54:50 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:33941 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1GPMys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:54:48 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 020/117] Staging: hv: vmbus: Support the notion of id
 tables in vmbus_match()
Thread-Topic: [PATCH 020/117] Staging: hv: vmbus: Support the notion of id
 tables in vmbus_match()
Thread-Index: AQHMQxTUZFB1FLQFMEKmeIC7sBN5KJTuqB0AgAA/yLA=
Date: Sat, 16 Jul 2011 12:54:46 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480817A4C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-20-git-send-email-kys@microsoft.com>
 <20110716020250.GA7199@infradead.org>
In-Reply-To: <20110716020250.GA7199@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, July 15, 2011 10:03 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 020/117] Staging: hv: vmbus: Support the notion of id tables
> in vmbus_match()
> 
> On Fri, Jul 15, 2011 at 10:46:08AM -0700, K. Y. Srinivasan wrote:
> > +static bool is_not_null_guid(const __u8 *guid)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < (sizeof(struct hv_vmbus_device_id)); i++)
> > +		if (guid[i] != 0)
> > +			return true;
> > +	return false;
> > +}
> 
> would be nice to add uuid_{le,be}_is_nil helpers to uuid.h.  I also
> think simply using a memcpy might be more efficient than the hand-rolled
> loop.
Having a helper function would be great. With regards to the efficiency of this loop,
this is not a performance critical path. If people feel strongly about this, I could 
change this; perhaps as a separate patch on top of this series; I don't want to send a large
patch-set like this again.

Regards,

K. Y
