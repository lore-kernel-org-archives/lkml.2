Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab1D0CbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 22:31:21 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:54126 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab1D0CbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 22:31:19 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: RE: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
Thread-Topic: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
Thread-Index: AQHMBCwlOahkyDWQA0Cj/4uI6AAO6ZRxNFuA///EzKA=
Date: Wed, 27 Apr 2011 02:31:18 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DD1C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-8-git-send-email-kys@microsoft.com>
 <20110426224545.GC31974@kroah.com>
In-Reply-To: <20110426224545.GC31974@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, April 26, 2011 6:46 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> Abhishek Kane (Mindtree Consulting PVT LTD)
> Subject: Re: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
> cleanup accordingly
> 
> On Tue, Apr 26, 2011 at 09:20:25AM -0700, K. Y. Srinivasan wrote:
> > The vmbus driver cannot be unloaded; the windows host does not
> > permit this. Cleanup accordingly.
> 
> Woah, you just prevented this driver from ever being able to be
> unloaded.

It was never unloadable; while the driver defined an exit routine, 
there were couple of issues unloading the vmbus driver:
 
1) All guest resources given to the host could not be recovered.

2) Windows host would not permit reloading the driver without 
rebooting the guest.

All I did was acknowledge the current state and cleanup 
accordingly. This is not unique to Hyper-V; for what it is worth,
the Xen platform_pci  driver which is equivalent to the vmbus driver
is also not unlodable (the last time I checked).

> 
> That's not a "cleanup" that's a major change in how things work.  I'm
> sure, if you want to continue down this line, there are more things you
> can remove from the code, right?
> 
> What is the real issue here?  What happens if you unload the bus?  What
> goes wrong?  Can it be fixed?

This needs to be fixed on the host side. I have notified them of the issue. 

> 
> This is a pretty big commitment...

These drivers only load when Linux is hosted on  a Hyper-V platform;
I am not sure why it is a "big commitment" given that the host does not 
permit reloading this driver without rebooting the guest. 

Regards,

K. Y

