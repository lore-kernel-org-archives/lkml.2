Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab1COPcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:32:19 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48409 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab1COPcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:32:18 -0400
X-IronPort-AV: E=Sophos;i="4.62,322,1297036800"; 
   d="scan'208";a="4800250"
Date: Tue, 15 Mar 2011 15:31:47 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Daniel Kiper <dkiper@net-space.pl>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        "v.tolstov@selfip.ru" <v.tolstov@selfip.ru>,
        "pasik@iki.fi" <pasik@iki.fi>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Bootup fix for _brk_end being != _end
In-Reply-To: <20110315153001.GD12730@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1103151530290.3382@kaball-desktop>
References: <20110308214429.GA27331@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1103091359290.2968@kaball-desktop> <20110315142957.GB12730@router-fw-old.local.net-space.pl> <20110315144821.GA11586@dumpdata.com>
 <20110315153001.GD12730@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011, Daniel Kiper wrote:
> On Tue, Mar 15, 2011 at 10:48:21AM -0400, Konrad Rzeszutek Wilk wrote:
> > > > > Additionally, I suggest to apply patch prepared by Steffano Stabellini
> > > > > (https://lkml.org/lkml/2011/1/31/232) which fixes memory management
> > > > > issue in Xen guest. I was not able boot guest machine without
> > > > > above mentioned patch.
> > > >
> > > > after some discussions we came up with a different approach to fix the
> > > > issue; I sent a couple of patches a little while ago:
> > > >
> > > > https://lkml.org/lkml/2011/2/28/410
> > >
> > > I tested git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.38-tip-fixes
> > > and it works on x86_64, however, it does not work on i386. Tested as
> > > unprivileged guest on Xen Ver. 4.1.0-rc2-pre. On i386 domain crashes
> > > silently at early boot stage :-(((.
> >
> > Details? Can you provide the 'xenctx' output of where it crashed?
> 
> As I wrote above domain is dying and I am not able to connect to it using
> xenctx after crash :-(((. I do not know how to do that in another way.
> 

try adding:

extra = "loglevel=9 debug earlyprintk=xenboot"
