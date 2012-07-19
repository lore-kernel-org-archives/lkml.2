Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab2GSQcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:32:35 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42501 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2GSQcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:32:33 -0400
Date: Thu, 19 Jul 2012 19:32:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/90] staging: comedi: comedidev.h: introduce
 comedi_to_pci_dev() helper
Message-ID: <20120719163211.GD16291@mwanda>
References: <201207181824.15722.hartleys@visionengravers.com>
 <5007D1E0.4050503@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F00206AA91644B@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206AA91644B@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 11:20:52AM -0500, H Hartley Sweeten wrote:
> On Thursday, July 19, 2012 2:23 AM, Ian Abbott wrote:
> > On 2012-07-19 02:24, H Hartley Sweeten wrote:
> >> Introduce a wrapper for to_pci_dev() to allow the comedi pci drivers
> >> to store the pci_dev pointer in the comedi_device hw_dev variable and
> >> retrieve it easily.
> >>
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >> Cc: Ian Abbott <abbotti@mev.co.uk>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> ---
> >>   drivers/staging/comedi/comedidev.h | 5 +++++
> >>   1 file changed, 5 insertions(+)
> >>
> >> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> >> index de8c99c..620222d 100644
> >> --- a/drivers/staging/comedi/comedidev.h
> >> +++ b/drivers/staging/comedi/comedidev.h
> >> @@ -446,6 +446,11 @@ static inline void comedi_set_hw_dev(struct comedi_device *dev,
> >>   	}
> >>   }
> >>
> >> +static inline struct pci_dev *comedi_to_pci_dev(struct comedi_device *dev)
> >> +{
> >> +	return to_pci_dev(dev->hw_dev);
> >> +}
> >> +
> >
> > That needs to be something like:
> >
> >	return dev->hw_dev ? to_pci_dev(dev->hw_dev) : NULL;
> 
> Hmm.. I'm not really sure.
> 
> I assumed that the container_of() macro would return NULL if the ptr passed to
> it was NULL. But, I'm not sure how this actually unwinds for that case.
> 
> Greg, do you know if the NULL check is needed? It's is possible that the dev->hw_dev
> pointer could be NULL.
> 

container_of() just does pointer math with the offset.  Since
->hw_dev is not the first member of the pci_dev struct then
to_pci_dev() never returns NULL.  If you give it a NULL pointer it
returns a bogus pointer back.

regards,
dan carpenter

