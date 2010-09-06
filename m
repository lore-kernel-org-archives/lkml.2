Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0IFSDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:03:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59515 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab0IFSD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:03:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=J6X0sT+lNdDa48PpSgya6M7HGimIJ6R1BzMJAjSnSiMbZ1/Uy/zp0juOXGotsb8XjM
         lyWB03QdNLOD29Me+eKWi/RXJIVD4vZ0RdAVE78z2AEJ3US4Y6MeAec6wRyieEUQyGfX
         /umqGl3EtieO0mvQyLKeSKWFnfZyRXWm6b0B0=
Date: Mon, 6 Sep 2010 20:02:40 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Julia Lawall <julia@diku.dk>, Ben Hutchings <ben@decadent.org.uk>,
        Mike Gilks <mike.kernel@gilksonline.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] staging: rtl8192u: improve error path
Message-ID: <20100906180240.GC2764@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Julia Lawall <julia@diku.dk>, Ben Hutchings <ben@decadent.org.uk>,
	Mike Gilks <mike.kernel@gilksonline.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1283711561-7332-1-git-send-email-segooon@gmail.com> <20100906101138.GA31249@bicker> <20100906135055.GA9632@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100906135055.GA9632@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 05:50:56PM +0400, Kulikov Vasiliy wrote:
> On Mon, Sep 06, 2010 at 12:11 +0200, Dan Carpenter wrote:
> > On Sun, Sep 05, 2010 at 10:32:41PM +0400, Kulikov Vasiliy wrote:
> > > +fail2:
> > > +	rtl8192_down(dev);
> > > +	if (priv->pFirmware) {
> > > +		kfree(priv->pFirmware);
> > > +		priv->pFirmware = NULL;
> > > +	}
> > > +	rtl8192_usb_deleteendpoints(dev);
> > > +	destroy_workqueue(priv->priv_wq);
> > > +	mdelay(10);
> > 
> > What's this delay for?
> 
> It was copied from rtl8192_usb_disconnect(), I don't know why it has
> mdelay(10). But it's better to keep the old deallocation code, it should
> have the same problems (if original code has any).
> 

I think the delay in rtl8192_usb_disconnect() is because we reset the
device.  (Of course, in that case, it would have been better to move the
delay into rtl8192_reset().  And also the reset code has been commented
out.)

In this case here, the delay is serves no purpose and should be removed.

regards,
dan carpenter
