Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab0JZPOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:14:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57718 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754528Ab0JZPOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:14:53 -0400
Date: Tue, 26 Oct 2010 11:14:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 1/7] USB: gadget: file_storage: put_device() in error
 recovery
In-Reply-To: <op.vk6urgd87p4s8u@pikus>
Message-ID: <Pine.LNX.4.44L0.1010261113320.1634-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, [utf-8] Michał Nazarewicz wrote:

> >> +		if ((rc = device_create_file(&curlun->dev, &dev_attr_ro))  ||
> >> +		    (rc = device_create_file(&curlun->dev, &dev_attr_nofua)) ||
> >> +		    (rc = device_create_file(&curlun->dev, &dev_attr_file)))
> >> +			goto out;
> >
> > As long as you're changing these anyway, you may as well use the style
> > most developers seem to prefer:
> >
> > 		rc = device_create_file(&curlun->dev, &dev_attr_ro);
> > 		if (rc)
> > 			goto out;
> > 		...
> 
> But then it'd be total of 9 lines consisting of three 3-line ifs.  I decided
> that it would be more readable with a single if even though it is not compliant
> with coding style.  What do you think?  I can just resend it.

I think you should change it as I suggested.

Alan Stern

