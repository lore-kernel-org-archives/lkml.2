Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab1KRNwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:52:39 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:55830 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab1KRNwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:52:38 -0500
Date: Fri, 18 Nov 2011 08:52:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: ANNIE LI <annie.li@oracle.com>, "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 2/3] xen/granttable: Grant tables V2
 implementation
Message-ID: <20111118135221.GC12433@phenom.dumpdata.com>
References: <4EC3B62F.6080702@oracle.com>
 <1321451372-13596-1-git-send-email-annie.li@oracle.com>
 <4EC62FE5.2080608@oracle.com>
 <1321614166.3664.311.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321614166.3664.311.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4EC66321.00CC,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +                       xen_raw_printk(str);
> > +                       panic(str);
> 
> I expect you've just copied this style from elsewhere but I really
> dislike this duplication of prints. If panic is not useful here we
> really ought to address that at the root instead of going around
> patching things to print every panic message twice. I thought
> earlyprintk was supposed to solve this problem. Perhaps a generic
> early_panic_print could be added to the panic code?

We are using this combo in swiotlb-xen and as well in the xen pci.
We could declere a 'xen_raw_panic' that would do the job?

The problem is that panic() uses the "late" printk mechanism (so
it goes through the buffer that ends up not beign flushed) and the
panic never sees the light. The 'xen_raw_printk' is synchronous..

But I wonder if the panic surfaces if 'earlyprintk=xen' is used?
At which point it might be that the those extra xen_raw_printk
become pointless?
