Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2GQQcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:32:55 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33622 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2GQQcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:32:53 -0400
Date: Tue, 17 Jul 2012 09:32:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        virtualization@lists.linux-foundation.org, olaf@aepfle.de,
        apw@canonical.com
Subject: Re: [PATCH 01/15] Drivers: hv: Format GUIDS as per MSFT standards
Message-ID: <20120717163248.GA29345@kroah.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-1-git-send-email-kys@microsoft.com>
 <20120717160402.GA20481@kroah.com>
 <1342541966.15318.4.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342541966.15318.4.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 09:19:26AM -0700, Joe Perches wrote:
> On Tue, 2012-07-17 at 09:04 -0700, Greg KH wrote:
> > On Sat, Jul 14, 2012 at 01:34:06PM -0700, K. Y. Srinivasan wrote:
> > > Format GUIDS as per MSFT standard. This makes interacting with MSFT
> > > tool stack easier.
> []
> > > diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> []
> > > @@ -147,7 +147,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
> > >  
> > >  	if (!strcmp(dev_attr->attr.name, "class_id")) {
> > >  		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
> > > -			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
> > > +			       "%02x%02x-%02x%02x%02x%02x%02x%02x}\n",
> > 
> > As Joe pointed out, please just use the printk modifier the kernel
> > already has for GUIDS, and don't roll your own here.  That will work
> > properly for you, right?
> 
> %pU became available in 2.6.33
> 
> I think one of their support targets is RHEL6 which
> I believe is 2.6.32+.

That's nice, but it's nothing that I care about for in-kernel code, nor
should anyone else.

greg k-h
