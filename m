Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2KATZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:25:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:59669 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab2KATZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:25:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,695,1344236400"; 
   d="scan'208";a="214114950"
Date: Thu, 1 Nov 2012 12:25:17 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Alexis R. Cortes" <alexis.cortes@ti.com>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 26/85] usb: host: xhci: New system added for Compliance Mode
 Patch on SN65LVPE502CP
Message-ID: <20121101192517.GL29270@xanatos>
References: <20121026000031.107227138@linuxfoundation.org>
 <20121026000033.747087636@linuxfoundation.org>
 <1351358293.4834.14.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351358293.4834.14.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 06:18:13PM +0100, Ben Hutchings wrote:
> On Thu, 2012-10-25 at 17:05 -0700, Greg Kroah-Hartman wrote:
> > 3.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: "Alexis R. Cortes" <alexis.cortes@ti.com>
> > 
> > commit 470809741a28c3092279f4e1f3f432e534d46068 upstream.
> > 
> > This minor change adds a new system to which the "Fix Compliance Mode
> > on SN65LVPE502CP Hardware" patch has to be applied also.
> > 
> > System added:
> > Vendor: Hewlett-Packard. System Model: Z1
> [...]
> > --- a/drivers/usb/host/xhci.c
> > +++ b/drivers/usb/host/xhci.c
> > @@ -479,7 +479,8 @@ static bool compliance_mode_recovery_tim
> >  
> >  	if (strstr(dmi_product_name, "Z420") ||
> >  			strstr(dmi_product_name, "Z620") ||
> > -			strstr(dmi_product_name, "Z820"))
> > +			strstr(dmi_product_name, "Z820") ||
> > +			strstr(dmi_product_name, "Z1"))
> 
> This will also match any future models with extra digits after the '1'.
> It might be worth using a slightly stricter match.

Hmm, Ben has a point.  We don't want to have the timer run on a machine
that really doesn't need the quirk, or we impact battery life.

Alex, can you make a new patch that fixes this?

Sarah Sharp
