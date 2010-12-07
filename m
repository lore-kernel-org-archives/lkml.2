Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0LGKbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:31:12 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:36942 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0LGKbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:31:10 -0500
X-IronPort-AV: E=Sophos;i="4.59,310,1288569600"; 
   d="scan'208";a="3219714"
Date: Tue, 7 Dec 2010 10:30:59 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Vasiliy G Tolstov <v.tolstov@selfip.ru>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH 0/2] Xen PV on HVM multiple PV consoles
In-Reply-To: <1291640614.32324.85.camel@work.selfip.ru>
Message-ID: <alpine.DEB.2.00.1012071026430.2390@kaball-desktop>
References: <alpine.DEB.2.00.1012011715070.14723@kaball-desktop>  <1291236234.22027.0.camel@mobile>  <alpine.DEB.2.00.1012021720170.14723@kaball-desktop>  <1291404900.5298.15.camel@mobile>  <alpine.DEB.2.00.1012061035070.9029@kaball-desktop>
 <1291640614.32324.85.camel@work.selfip.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010, Vasiliy G Tolstov wrote:
> On Mon, 2010-12-06 at 10:36 +0000, Stefano Stabellini wrote:
> 
> > 
> > Could you please add CONFIG_DEBUG_INFO=y to your kernel config, so that
> > we can see the name of the functions in the stack trace?
> > 
> 
> After add debug kernel not crushed. I'm test more expensive it now. Can
> You provide ps auxwww | grep qemu-dm after creating domain with two
> serial consoles? (sles does not have libxl, i want to write now wrapper
> to qemu-dm, after that try to compile rpm from spec to support libxl).
> 

There is no need for any special command line arguments to qemu-dm, it
is going to create as many PV serials as configured on xenstored by
libxl, give a look at tools/libxl/libxl.c:libxl_device_console_add.
The output of the serial is the one specified on the node "output" on
xenstore.
