Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab1IIP3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 11:29:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758909Ab1IIP3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 11:29:08 -0400
Date: Fri, 9 Sep 2011 08:24:56 -0700
From: Greg KH <gregkh@suse.de>
To: Olaf Hering <olaf@aepfle.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH] Staging: hv: storvsc: Show the modulename in
 /sys/class/scsi_host/*/proc_name
Message-ID: <20110909152456.GA26556@suse.de>
References: <20110908162650.GA10699@aepfle.de>
 <20110908191237.GB8552@suse.de>
 <20110909084523.GA20517@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909084523.GA20517@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 10:45:23AM +0200, Olaf Hering wrote:
> On Thu, Sep 08, Greg KH wrote:
> 
> > On Thu, Sep 08, 2011 at 06:26:50PM +0200, Olaf Hering wrote:
> 
> > > +++ b/drivers/staging/hv/storvsc_drv.c
> > > @@ -1333,7 +1333,8 @@ static DEF_SCSI_QCMD(storvsc_queuecomman
> > >  /* Scsi driver */
> > >  static struct scsi_host_template scsi_driver = {
> > >  	.module	=		THIS_MODULE,
> > > -	.name =			"storvsc_host_t",
> > > +	.name =			"hv_storvsc",
> > > +	.proc_name =		"hv_storvsc",
> > 
> > Shouldn't this be MODULE_NAME so it handles any potential name change in
> > the future and makes it a bit more obvious as to what is going on here?
> 
> MODULE_NAME is just another define and appearently not used to assemble
> a kernel module. Is DRV_NAME depreciated?

Sorry, I should have said KBUILD_MODNAME, that will give you what you
want here.

greg k-h
