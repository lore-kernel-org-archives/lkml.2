Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab2EVFT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:19:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:30192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab2EVFTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:19:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102714788"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: David Rientjes <rientjes@google.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [Resend PATCH v2] testusb: add path /dev/bus/usb to default
 search paths of usbfs
Thread-Topic: [Resend PATCH v2] testusb: add path /dev/bus/usb to default
 search paths of usbfs
Thread-Index: AQHNN7qyG7Zv5VtpIkaxHOeRBAtVM5bUgnMAgACkjhD//4G3AIAAnEsw
Date: Tue, 22 May 2012 05:19:51 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A063A4C@SHSMSX101.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A062E6C@SHSMSX101.ccr.corp.intel.com>
 <0C18FE92A7765D4EB9EE5D38D86A563A06388E@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.00.1205211839180.20916@chino.kir.corp.google.com>
 <0C18FE92A7765D4EB9EE5D38D86A563A063A1A@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.00.1205212055140.2666@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205212055140.2666@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 May 2012, Du, ChangbinX wrote:
> 
> > > diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c index
> > > 6e0f567..82d7c59 100644
> > > --- a/tools/usb/testusb.c
> > > +++ b/tools/usb/testusb.c
> > > @@ -358,6 +358,7 @@ static const char *usbfs_dir_find(void)  {
> > >  	static char usbfs_path_0[] = "/dev/usb/devices";
> > >  	static char usbfs_path_1[] = "/proc/bus/usb/devices";
> > > +	static char udev_usb_path[] = "/dev/bus/usb";
> > >
> > >  	static char *const usbfs_paths[] = {
> > >  		usbfs_path_0, usbfs_path_1
> > > @@ -376,6 +377,10 @@ static const char *usbfs_dir_find(void)
> > >  		}
> > >  	} while (++it != end);
> > >
> > > +	/* real device-nodes managed by udev */
> > > +	if (access(udev_usb_path, F_OK) == 0)
> > > +		return udev_usb_path;
> > > +
> > >  	return NULL;
> > >  }
> > >
> >
> > Two issues with this: F_OK only guarantees that the path exists, it
> > does not guarantee that it is readable like this function guarantees
> > for usbfs_paths, and access() shouldn't be used because of its
> > security implications, you're better off using open() and testing for fd.
> >
> > Hello, David. I think this function doesn't need check the permission.
> > What this function need do is to find the usbfs mount point. If the
> > path exists but cannot read, we cannot report as it's not exits. And
> > when we read files, open() will return an error and user can check if
> > it's need to upgrade his access right.
> >
> 
> Your email client doesn't seem to be quoting messages correctly :)
> 
> Anyway, this patch is inconsistent with the rest of the function.  The other two
> paths are checked with open(O_RDONLY) followed by a close() to address my
> second comment and we certainly wouldn't want to return a path that exists by
> is unreadable: we'd want to fallback to one of the other possibilities.  So if
> anybody is going to extend this in the future like you have, it would be possible
> to return /dev/bus/usb even though we can't read it.  That's a bad result.
> 
> Please consider doing it the proper way: by doing open(O_RDONLY), close()
> instead of access() -- if you don't understand why, read access(2) -- and in an
> extendable way.

I see. Thanks for your comments. I will correct and resend it again.
