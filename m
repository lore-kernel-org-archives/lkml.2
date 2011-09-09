Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab1IIIpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:45:41 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:48451 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1IIIpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:45:40 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjDQQEWgH
X-RZG-CLASS-ID: mo00
Date: Fri, 9 Sep 2011 10:45:23 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Greg KH <gregkh@suse.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH] Staging: hv: storvsc: Show the modulename in
 /sys/class/scsi_host/*/proc_name
Message-ID: <20110909084523.GA20517@aepfle.de>
References: <20110908162650.GA10699@aepfle.de>
 <20110908191237.GB8552@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110908191237.GB8552@suse.de>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, Greg KH wrote:

> On Thu, Sep 08, 2011 at 06:26:50PM +0200, Olaf Hering wrote:

> > +++ b/drivers/staging/hv/storvsc_drv.c
> > @@ -1333,7 +1333,8 @@ static DEF_SCSI_QCMD(storvsc_queuecomman
> >  /* Scsi driver */
> >  static struct scsi_host_template scsi_driver = {
> >  	.module	=		THIS_MODULE,
> > -	.name =			"storvsc_host_t",
> > +	.name =			"hv_storvsc",
> > +	.proc_name =		"hv_storvsc",
> 
> Shouldn't this be MODULE_NAME so it handles any potential name change in
> the future and makes it a bit more obvious as to what is going on here?

MODULE_NAME is just another define and appearently not used to assemble
a kernel module. Is DRV_NAME depreciated?

I think hv_storvsc and hv_netvsc should advertise their module names as
sysfs driver names. Digging into the hv history it could be that the
initial implementation had a storvsc.ko, and
c3260cfe8f08ca4564df61950cbebbb693aee292 introduced the hv_storvsc.ko

I will send a patch on top of that.


Olaf
