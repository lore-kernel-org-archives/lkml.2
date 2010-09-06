Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab0IFNvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 09:51:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36498 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0IFNvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 09:51:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X7YYADD8VRLBp+coeu9LUr42jB0E5rZsdRYLALN3FBvd8Md21HfxvuUU38risNRpJP
         6DunOrHQFtZMqFN5kr84WueS37TXWpjoExX3EHM29Ffx2NKd2pKlnvXjwicXScu61RnT
         XGXcQ1hwEQjq1gQffQeGT9CSOgHWFLH2XGyQA=
Date: Mon, 6 Sep 2010 17:50:56 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Julia Lawall <julia@diku.dk>, Ben Hutchings <ben@decadent.org.uk>,
        Mike Gilks <mike.kernel@gilksonline.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] staging: rtl8192u: improve error path
Message-ID: <20100906135055.GA9632@albatros>
References: <1283711561-7332-1-git-send-email-segooon@gmail.com>
 <20100906101138.GA31249@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100906101138.GA31249@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 12:11 +0200, Dan Carpenter wrote:
> On Sun, Sep 05, 2010 at 10:32:41PM +0400, Kulikov Vasiliy wrote:
> > +fail2:
> > +	rtl8192_down(dev);
> > +	if (priv->pFirmware) {
> > +		kfree(priv->pFirmware);
> > +		priv->pFirmware = NULL;
> > +	}
> > +	rtl8192_usb_deleteendpoints(dev);
> > +	destroy_workqueue(priv->priv_wq);
> > +	mdelay(10);
> 
> What's this delay for?

It was copied from rtl8192_usb_disconnect(), I don't know why it has
mdelay(10). But it's better to keep the old deallocation code, it should
have the same problems (if original code has any).

-- 
Vasiliy
