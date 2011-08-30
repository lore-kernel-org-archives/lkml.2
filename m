Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1H3Hzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:55:40 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:19664 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1H3Hzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:55:39 -0400
Date: Tue, 30 Aug 2011 09:52:18 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, <gregkh@suse.de>, <martyn.welch@ge.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] staging: vme: add struct vme_dev for VME devices
Message-ID: <20110830075218.GA3056@becoht-mvanga>
Mail-Followup-To: "Emilio G. Cota" <cota@braap.org>,
	Greg KH <greg@kroah.com>, gregkh@suse.de, martyn.welch@ge.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1314608570-32766-1-git-send-email-manohar.vanga@cern.ch>
 <1314608570-32766-3-git-send-email-manohar.vanga@cern.ch>
 <20110829175241.GC10250@kroah.com>
 <20110829235508.GA30400@flamenco.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110829235508.GA30400@flamenco.cs.columbia.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Emilio,

On Mon, Aug 29, 2011 at 07:55:08PM -0400, Emilio G. Cota wrote:
> On Mon, Aug 29, 2011 at 10:52:41 -0700, Greg KH wrote:
> > On Mon, Aug 29, 2011 at 11:02:49AM +0200, Manohar Vanga wrote:
> > > --- a/drivers/staging/vme/vme_bridge.h
> > > +++ b/drivers/staging/vme/vme_bridge.h
> > > @@ -115,9 +115,8 @@ struct vme_bridge {
> > >  	struct list_head bus_list; /* list of VME buses */
> > >  	struct module *owner;	/* module that owns the bridge */
> > >  
> > > -	struct device dev[VME_SLOTS_MAX];	/* Device registered with
> > > -						 * device model on VME bus
> > > -						 */
> > > +	struct vme_dev dev[VME_SLOTS_MAX];	/* Device registered
> > > +						 * on VME bus */
> > 
> > Overall, this is the right way to go, using a vme_dev.
> > 
> > BUT, you should never have a static list of devices, these should be
> > pointers, not actual structures here, otherwise your reference counting
> > just got all messed up and is wrong.
> > 
> > And yes, I know you didn't create the code this way, but it needs to be
> > fixed _before_ you make this kind of a change.
> 
> True, I overlooked this while reviewing >_<
> 
> Manohar, have a look at vme_unregister_driver_ng() and
> __vme_register_driver_bus() in this patch:
>  
>     http://article.gmane.org/gmane.linux.kernel/1054046

I actually threw the static devices out of the code in patch 3. I didn't
introduce it here as I thought the changes were unrelated (introducing
struct vme_dev across the code and getting rid of that static device
array).

-- 
/manohar
