Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab2EXRhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:37:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47254 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab2EXRht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:37:49 -0400
Date: Thu, 24 May 2012 13:31:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 2/4] xen/hvc: Fix error cases around
 HVM_PARAM_CONSOLE_PFN
Message-ID: <20120524173110.GE24934@phenom.dumpdata.com>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
 <1337795222-29946-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1205241145200.26786@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205241145200.26786@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:47:12AM +0100, Stefano Stabellini wrote:
> On Wed, 23 May 2012, Konrad Rzeszutek Wilk wrote:
> > We weren't resetting the parameter to be passed in to a
> > known default. Nor were we checking the return value of
> > hvm_get_parameter.
> > 
> > CC: stable@kernel.org
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >
> >  drivers/tty/hvc/hvc_xen.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> > index afc7fc2..3277f0e 100644
> > --- a/drivers/tty/hvc/hvc_xen.c
> > +++ b/drivers/tty/hvc/hvc_xen.c
> > @@ -219,7 +219,8 @@ static int xen_hvm_console_init(void)
> >  	if (r < 0)
> >  		goto err;
> >  	info->evtchn = v;
> > -	hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
> > +	v = 0;
> > +	r = hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
> >  	if (r < 0)
> >  		goto err;
> >  	mfn = v;
> 
> Is 0 the right default here?
> Maybe something invalid like (~0UL) would be better?

Perhaps both? The zero is the default non-initialized value. But
-0UL is also a good check value.

