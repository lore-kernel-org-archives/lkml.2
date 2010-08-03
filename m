Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0HCO34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:29:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52917 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753995Ab0HCO3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:29:54 -0400
Date: Tue, 3 Aug 2010 10:29:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Valdis.Kletnieks@vt.edu
cc: "Justin P. Mattock" <justinmattock@gmail.com>, <linux-usb@vger.kernel.org>,
        <dbrownell@users.sourceforge.net>, <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2]drivers/usb/core/sysfs.c Fix variable 'retval' set
 but not used
In-Reply-To: <58611.1280834905@localhost>
Message-ID: <Pine.LNX.4.44L0.1008031027250.1853-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 Valdis.Kletnieks@vt.edu wrote:

> On Mon, 02 Aug 2010 21:26:28 PDT, "Justin P. Mattock" said:
> > diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
> 
> >  	if (alt->string)
> > -		retval = device_create_file(&intf->dev, &dev_attr_interface);
> > +		device_create_file(&intf->dev, &dev_attr_interface);
> >  	intf->sysfs_files_created = 1;
> >  	return 0;

Justin, did you try compiling your new code?  Those unused values are 
there because device_create_file is declared as __must_check.

> What should the code do if device_create_file() manages to fail? Yes, ignoring
> the return value is one option, but is it the best one?  'return ret;' might be
> another one. Somebody who understands this code and has more caffeine than me
> should look this over.

Failure to create a file in sysfs is almost never fatal and usually not 
even dangerous.  Ignoring the error is generally better than failing 
the entire operation.

Alan Stern

