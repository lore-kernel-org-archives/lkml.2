Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab1KROBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:01:16 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:27653 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab1KROBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:01:15 -0500
X-IronPort-AV: E=Sophos;i="4.69,533,1315180800"; 
   d="scan'208";a="9011392"
Subject: Re: [Xen-devel] Re: [PATCH 2/3] xen/granttable: Grant tables V2
 implementation
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: ANNIE LI <annie.li@oracle.com>, "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>
Date: Fri, 18 Nov 2011 14:00:44 +0000
In-Reply-To: <20111118135221.GC12433@phenom.dumpdata.com>
References: <4EC3B62F.6080702@oracle.com>
	 <1321451372-13596-1-git-send-email-annie.li@oracle.com>
	 <4EC62FE5.2080608@oracle.com>
	 <1321614166.3664.311.camel@zakaz.uk.xensource.com>
	 <20111118135221.GC12433@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1321624845.3664.354.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 13:52 +0000, Konrad Rzeszutek Wilk wrote:
> > > +                       xen_raw_printk(str);
> > > +                       panic(str);
> > 
> > I expect you've just copied this style from elsewhere but I really
> > dislike this duplication of prints. If panic is not useful here we
> > really ought to address that at the root instead of going around
> > patching things to print every panic message twice. I thought
> > earlyprintk was supposed to solve this problem. Perhaps a generic
> > early_panic_print could be added to the panic code?
> 
> We are using this combo in swiotlb-xen and as well in the xen pci.
> We could declere a 'xen_raw_panic' that would do the job?
> 
> The problem is that panic() uses the "late" printk mechanism (so
> it goes through the buffer that ends up not beign flushed) and the
> panic never sees the light.

So lets fix that instead of working around it...

>  The 'xen_raw_printk' is synchronous..
> 
> But I wonder if the panic surfaces if 'earlyprintk=xen' is used?
> At which point it might be that the those extra xen_raw_printk
> become pointless?

I think panic's do come out with earlyprintk (unless they are truly
super early).

Ian.



