Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2GQQT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:19:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50668 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753611Ab2GQQT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:19:27 -0400
Message-ID: <1342541966.15318.4.camel@joe2Laptop>
Subject: Re: [PATCH 01/15] Drivers: hv: Format GUIDS as per MSFT standards
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        virtualization@lists.linux-foundation.org, olaf@aepfle.de,
        apw@canonical.com
Date: Tue, 17 Jul 2012 09:19:26 -0700
In-Reply-To: <20120717160402.GA20481@kroah.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
	 <1342298060-12662-1-git-send-email-kys@microsoft.com>
	 <20120717160402.GA20481@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 09:04 -0700, Greg KH wrote:
> On Sat, Jul 14, 2012 at 01:34:06PM -0700, K. Y. Srinivasan wrote:
> > Format GUIDS as per MSFT standard. This makes interacting with MSFT
> > tool stack easier.
[]
> > diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
[]
> > @@ -147,7 +147,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
> >  
> >  	if (!strcmp(dev_attr->attr.name, "class_id")) {
> >  		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
> > -			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
> > +			       "%02x%02x-%02x%02x%02x%02x%02x%02x}\n",
> 
> As Joe pointed out, please just use the printk modifier the kernel
> already has for GUIDS, and don't roll your own here.  That will work
> properly for you, right?

%pU became available in 2.6.33

I think one of their support targets is RHEL6 which
I believe is 2.6.32+.


