Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0HCPgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:36:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46617 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751611Ab0HCPgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:36:47 -0400
Date: Tue, 3 Aug 2010 11:36:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: Valdis.Kletnieks@vt.edu, <linux-usb@vger.kernel.org>,
        <dbrownell@users.sourceforge.net>, <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2]drivers/usb/core/sysfs.c Fix variable 'retval' set
 but not used
In-Reply-To: <4C582B2B.3080804@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1008031134340.1853-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, Justin P. Mattock wrote:

> On 08/03/2010 07:29 AM, Alan Stern wrote:
> > On Tue, 3 Aug 2010 Valdis.Kletnieks@vt.edu wrote:
> >
> >> On Mon, 02 Aug 2010 21:26:28 PDT, "Justin P. Mattock" said:
> >>> diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
> >>
> >>>   	if (alt->string)
> >>> -		retval = device_create_file(&intf->dev,&dev_attr_interface);
> >>> +		device_create_file(&intf->dev,&dev_attr_interface);
> >>>   	intf->sysfs_files_created = 1;
> >>>   	return 0;
> >
> > Justin, did you try compiling your new code?  Those unused values are
> > there because device_create_file is declared as __must_check.
> >
> 
> I went as far as compiling, once I saw no warning then figured o.k
> I'll send out what I have for feedback then go from there.
> (and just for the record I want to thank those who took the time to go 
> through and give feedback).

It's a little surprising that you didn't get any warning.  I guess you
don't have CONFIG_ENABLE_MUST_CHECK turned on.

Alan Stern

