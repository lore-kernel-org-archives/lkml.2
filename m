Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0JDOKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 10:10:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57463 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0JDOKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 10:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=aexF3znRNsC/ykGUSxjExcyibsuDunyiMk5Np0GnBvqyUnwfN+W4vbg2LhTfvku7mI
         Z4t10IQDxmYmzIy2+UtucEfBsRz2XomKXRAXR5OGehk5O1xD/qwvZZmfKRhE4sPLhc1x
         4ShvEMJN73aW2KnyfasSv7Xm8FNptWgWC/cP8=
Date: Mon, 4 Oct 2010 16:10:17 +0200
From: Dan Carpenter <error27@gmail.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, nm127@freemail.hu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND/PATCH] usb: gadget: goku_udc: Fix error path
Message-ID: <20101004141017.GD5692@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Rahul Ruikar <rahul.ruikar@gmail.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	Greg Kroah-Hartman <gregkh@suse.de>, nm127@freemail.hu,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1286135940-2364-1-git-send-email-rahul.ruikar@gmail.com> <20101004122214.GA5692@bicker> <AANLkTi=K25BbWjsnVNny-9YOVEE1xNsDFMoMfc+P8sWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=K25BbWjsnVNny-9YOVEE1xNsDFMoMfc+P8sWQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 06:54:00PM +0530, Rahul Ruikar wrote:
> Dan,
> 
> Following things I tried to do with this change.
> there can be 3 cases where one need to handle device_register()
> 1) reaching error path but device_register() is never called..( ie,
> error occurred before calling device_register() function call, in this
> case "dev->reg_status" will have value "0" and in error handler
> device_unregister() or put_device() will not be called.
> 

Good point.  This is a bug in the original code.

> 2) error occurred at device_register() ( ie. it fails and calls error
> handler, this way "dev->reg_status" will have value "2" and in error
> handler, based on this value "put_device() will be called.
> 

Yeah.  But device_register() sucks.  It shouldn't require such byzantine
error handling.  Someone is working on this.

regards,
dan carpenter

> 3) error occured after device_register() success. ( ie, error occured
> due to some other function, ) in this case "dev->reg_status" will have
> value "1" and in error handler, based on this value
> "device_unregister" will be called.
> 
> but anyways someone has now proposed to change it to new usb
> interface, so this patch is of no use now.
> 
> Thanks
> Rahul Ruikar
> 

