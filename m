Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1BWWsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:48:31 -0500
Received: from mail3.microsoft.com ([131.107.115.214]:6383 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1BWWsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:48:30 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Hank Janssen <hjanssen@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 1/4] staging: hv: Fix the code depending on struct
 vmbus_driver_context data order
Thread-Topic: [PATCH 1/4] staging: hv: Fix the code depending on struct
 vmbus_driver_context data order
Thread-Index: AQHL05XXX+kAHBjdg0KWib5MQLs97JQQH60A//+Me+A=
Date: Wed, 23 Feb 2011 22:48:27 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC060ECE@TK5EX14MBXC227.redmond.corp.microsoft.com>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
 <20110223212644.GC23766@kroah.com>
In-Reply-To: <20110223212644.GC23766@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, February 23, 2011 4:27 PM
> >  struct driver_context {
> >  	struct hv_guid class_id;
> > -
> >  	struct device_driver driver;
> > +	struct hv_driver *hv_drv;
> 
> If you have a pointer to hv_driver, why do you need a full 'struct
> device_driver' here?  That sounds really wrong.
> 
> Actually, having 'struct device_driver' within a structure called
> "driver_context" seems wrong, this should be what 'struct hv_driver'
> really is, right?

The hv_driver contains Hyper-V specific data, like hv_guid. But the
struct driver_context contains data and functions related to Linux
kernel side, such as the struct device_driver defined by kernel. So,
they are kept separately.

(just saw Ky's email, which further explained the layering.)

Thanks,

- Haiyang

