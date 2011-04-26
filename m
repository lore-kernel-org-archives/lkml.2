Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab1DZDJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 23:09:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44667 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1DZDJS (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 25 Apr 2011 23:09:18 -0400
Date: Mon, 25 Apr 2011 23:07:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 112/173] Input: xen-kbdfront - advertise either
 absolute or relative coordinates
Message-ID: <20110426030745.GA20779@dumpdata.com>
References: <46075c3a3ef08be6d70339617d6afc98@local>
 <20110425200237.859884245@pcw.home.local>
 <20110425203158.GA8427@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425203158.GA8427@aepfle.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DB63707.0026:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 10:31:58PM +0200, Olaf Hering wrote:
> On Mon, Apr 25, Willy Tarreau wrote:
> 
> > 2.6.27.59-stable review patch.  If anyone has any objections, please let us know.
> 
> These two hunks have to be removed from the patch.
> If the guest is suspended/resumed the guest has to renegotiate with the
> new qemu-dm process and set the request-abs-pointer property again.
> 

Willy,

Olaf is refering to c36b58e8a9112017c2bcc322cc98e71241814303 which is 
in the upstream kernel.

> Olaf
> 
> > @@ -267,7 +281,7 @@
> >  				   enum xenbus_state backend_state)
> >  {
> >  	struct xenkbd_info *info = dev->dev.driver_data;
> > -	int ret, val;
> > +	int val;
> >  
> >  	switch (backend_state) {
> >  	case XenbusStateInitialising:
> > @@ -278,17 +292,6 @@
> >  
> >  	case XenbusStateInitWait:
> >  InitWait:
> > -		ret = xenbus_scanf(XBT_NIL, info->xbdev->otherend,
> > -				   "feature-abs-pointer", "%d", &val);
> > -		if (ret < 0)
> > -			val = 0;
> > -		if (val) {
> > -			ret = xenbus_printf(XBT_NIL, info->xbdev->nodename,
> > -					    "request-abs-pointer", "1");
> > -			if (ret)
> > -				printk(KERN_WARNING
> > -				       "xenkbd: can't request abs-pointer");
> > -		}
> >  		xenbus_switch_state(dev, XenbusStateConnected);
> >  		break;
> >  
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
