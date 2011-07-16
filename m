Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1GPNMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 09:12:34 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:16088 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab1GPNMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 09:12:33 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Sasha Levin <levinsasha928@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH 097/117] Staging: hv: storvsc: Add code to handle IDE
 devices using the storvsc driver
Thread-Topic: [PATCH 097/117] Staging: hv: storvsc: Add code to handle IDE
 devices using the storvsc driver
Thread-Index: AQHMQxTVnqS9spDprUK7R5lIXPTpYJTuqKiAgABAUyCAAHc0gP//jPVw
Date: Sat, 16 Jul 2011 13:12:31 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480817A50E@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
	 <1310752065-27895-1-git-send-email-kys@microsoft.com>
	 <1310752065-27895-97-git-send-email-kys@microsoft.com>
	 <20110716020447.GB7199@infradead.org>
	 <6E21E5352C11B742B20C142EB499E0480817A4DA@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <1310821299.1976.2.camel@lappy>
In-Reply-To: <1310821299.1976.2.camel@lappy>
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
> From: Sasha Levin [mailto:levinsasha928@gmail.com]
> Sent: Saturday, July 16, 2011 9:02 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: RE: [PATCH 097/117] Staging: hv: storvsc: Add code to handle IDE devices
> using the storvsc driver
> 
> On Sat, 2011-07-16 at 12:57 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Christoph Hellwig [mailto:hch@infradead.org]
> > > Sent: Friday, July 15, 2011 10:05 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > > Subject: Re: [PATCH 097/117] Staging: hv: storvsc: Add code to handle IDE
> devices
> > > using the storvsc driver
> > >
> > > Thanks, this looks much cleaner than the initial variant.
> > >
> > > > +	if (dev_is_ide) {
> > > > +		storvsc_get_ide_info(device, &target, &path);
> > > > +		host_dev->path = device_info.path_id;
> > > > +		host_dev->target = device_info.target_id;
> > > > +	} else {
> > > > +		host_dev->path = device_info.path_id;
> > > > +		host_dev->target = device_info.target_id;
> > > > +	}
> > >
> > > Is using the device_info values in both branches intentional?  If so
> > > there's no need to have these assignments duplicated.
> >
> > While we set the values in both the branches, the value set is different;
> > The IDE side encodes the bits differently and is appropriately parsed in the
> > function storvsc_get_ide_info().
> 
> Is think that what Christoph meant was simplifying it to:
> 
> 	if (dev_is_ide)
> 		storvsc_get_ide_info(device, &target, &path);
> 
> 	host_dev->path = device_info.path_id;
> 	host_dev->target = device_info.target_id;

Good point! It is still too early in the morning for me. 
Greg, if it is ok with you, in the interest of keeping the patch
cops happy, I can submit a patch for this on top of this series.

Regards,

K. Y
> 
> --
> 
> Sasha.
> 

