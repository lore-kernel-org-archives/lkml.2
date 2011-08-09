Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1HIJ2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:28:32 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:19709 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1HIJ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:28:31 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGjC0PECMV
X-RZG-CLASS-ID: mo00
Date: Tue, 9 Aug 2011 11:28:12 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Konrad <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/3] xen/pv-on-hvm kexec: add xs_introduce to
 shutdown watches from old kernel
Message-ID: <20110809092812.GA7283@aepfle.de>
References: <20110804162053.723541930@aepfle.de>
 <20110804162054.096018606@aepfle.de>
 <1312881318.26263.44.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1312881318.26263.44.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, Ian Campbell wrote:

> > +++ linux-3.0/drivers/xen/xenbus/xenbus_xs.c

> > +	return xs_error(xs_talkv(XBT_NIL, XS_INTRODUCE, iov,
> > +				 ARRAY_SIZE(iov), NULL));
> 
> What should we do if this fails?

There is not much other than printk and move on.
A kexec boot cant be detected from withing kexec.

> > +	snprintf(domid, sizeof(domid), "%u", DOMID_SELF);
> > +	snprintf(mfn, sizeof(mfn), "%lu", xen_store_mfn);
> > +	snprintf(port, sizeof(port), "%d", xen_store_evtchn);
> 
> These can be within the if, or better within the xs_introduce function
> itself.

Yes, thats true. I will rearrange the code.

Olaf
