Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1GPM5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:57:33 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:34617 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1GPM5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:57:30 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 097/117] Staging: hv: storvsc: Add code to handle IDE
 devices using the storvsc driver
Thread-Topic: [PATCH 097/117] Staging: hv: storvsc: Add code to handle IDE
 devices using the storvsc driver
Thread-Index: AQHMQxTVnqS9spDprUK7R5lIXPTpYJTuqKiAgABAUyA=
Date: Sat, 16 Jul 2011 12:57:29 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480817A4DA@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-97-git-send-email-kys@microsoft.com>
 <20110716020447.GB7199@infradead.org>
In-Reply-To: <20110716020447.GB7199@infradead.org>
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
> Sent: Friday, July 15, 2011 10:05 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 097/117] Staging: hv: storvsc: Add code to handle IDE devices
> using the storvsc driver
> 
> Thanks, this looks much cleaner than the initial variant.
> 
> > +	if (dev_is_ide) {
> > +		storvsc_get_ide_info(device, &target, &path);
> > +		host_dev->path = device_info.path_id;
> > +		host_dev->target = device_info.target_id;
> > +	} else {
> > +		host_dev->path = device_info.path_id;
> > +		host_dev->target = device_info.target_id;
> > +	}
> 
> Is using the device_info values in both branches intentional?  If so
> there's no need to have these assignments duplicated.

While we set the values in both the branches, the value set is different;
The IDE side encodes the bits differently and is appropriately parsed in the
function storvsc_get_ide_info().

Regards,

K. Y
