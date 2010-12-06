Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0LFKgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 05:36:32 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:20833 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab0LFKgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 05:36:31 -0500
X-IronPort-AV: E=Sophos;i="4.59,305,1288569600"; 
   d="scan'208";a="3199958"
Date: Mon, 6 Dec 2010 10:36:32 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Vasiliy G Tolstov <v.tolstov@selfip.ru>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH 0/2] Xen PV on HVM multiple PV consoles
In-Reply-To: <1291404900.5298.15.camel@mobile>
Message-ID: <alpine.DEB.2.00.1012061035070.9029@kaball-desktop>
References: <alpine.DEB.2.00.1012011715070.14723@kaball-desktop>  <1291236234.22027.0.camel@mobile>  <alpine.DEB.2.00.1012021720170.14723@kaball-desktop> <1291404900.5298.15.camel@mobile>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010, Vasiliy G Tolstov wrote:
> On Thu, 2010-12-02 at 17:21 +0000, Stefano Stabellini wrote:
> > On Wed, 1 Dec 2010, Vasiliy G Tolstov wrote:
> > > On Wed, 2010-12-01 at 18:25 +0000, Stefano Stabellini wrote:
> > > > Hi all,
> > > > this small patch series achieves two goals:
> > > > 
> > > > - make PV consoles work for PV on HVM guests;
> > > > 
> > > > - implement support for multiple PV consoles for PV and PV on HVM guests.
> > > > 
> > > > Stefano Stabellini (2):
> > > >       hvc_xen: support PV on HVM consoles
> > > >       hvc_xen: implement multiconsole support
> > > > 
> > > >  drivers/char/hvc_xen.c             |  479 ++++++++++++++++++++++++++++++++----
> > > >  include/xen/interface/hvm/params.h |    6 +-
> > > >  2 files changed, 441 insertions(+), 44 deletions(-)
> > > > 
> > > > A branch with these patches on 2.6.37-rc4 is available here:
> > > > 
> > > > git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.37-rc4-pvhvm-pvconsole
> > > > 
> > > > Cheers,
> > > 
> > > Does it possible to apply only this 2 patches on stable-2.6.32.x and get
> > > working serial consoles?
> > > 
> > 
> > I backported the two patches to stable-2.6.32 and created a new branch
> > that is stable-2.6.32.x + support PV on HVM consoles + implement
> > multiconsole support:
> > 
> > git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git stable-2.6.32-pvconsole
> > 
> > I still haven't tested it with xend though.
> 
> Kernel crushed =(. Use config file from 64 bit fully worked
> configuration, what does it mean? How can i find reason for this crush?


Could you please add CONFIG_DEBUG_INFO=y to your kernel config, so that
we can see the name of the functions in the stack trace?

