Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab2CBKQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:16:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55945 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab2CBKP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:15:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of federico.vaga@gmail.com designates 10.204.154.139 as permitted sender) smtp.mail=federico.vaga@gmail.com; dkim=pass header.i=federico.vaga@gmail.com
From: Federico Vaga <federico.vaga@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org
Subject: Re: How to make a bus with heterogeneous devices?
Date: Fri, 02 Mar 2012 11:18:59 +0100
Message-ID: <1380686.VGpImaUmFA@harkonnen>
User-Agent: KMail/4.7.4 (Linux/3.2.7-1.fc16.x86_64; KDE/4.7.4; x86_64; ; )
In-Reply-To: <20120225004008.GA3973@kroah.com>
References: <20120224152051.GA23232@mail.gnudd.com> <20120225004008.GA3973@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's fine, it is what happens with lots of drivers, you can do this
> with the default attribute group assigned to that driver, right?

We can't because a driver can handle devices with different set of 
attributes. We  can't use device->groups because only if match succeed 
we know which attributes add to the device.
That's because the same driver handles several similar devices, to avoid 
proliferation of almost-identical drivers. So the drivers attaches 
attributes to the device after match succeeds.

The solution that I temporarily  implemented is the following:

> > [...]
> > 3- Attributes may be added after match succeeds, before calling
> > probe.
> > This cam be done with a "raw" call to sysfs_create_group(); then
> > groups cna be added to dev->groups so they will be removed on
> > device_unregister().
> > [...]

(with calling probe I mean calling "my" driver probe)

I know it's not a nice solution and I know it's not nice add groups to 
device->groups after registration. I can use sysfs_create_group() and 
sysfs_remove_group() without touching the device.
 
> I think you need to look at how the system bus is handled.  It just 
> went into 3.3-rc and allows for "different" types of devices to all be 
> on the same bus, with different drivers and attributes.  Let me know if 
> how that works does not work out for you.

(thank you for the reference to the patches)

I think it doesn't work in our case for the same reason we can't use 
device_driver->groups: we know too late in the register process which 
attributes add to a device, practically at the end of the registration.
Maybe I'm missing something.

-- 
Federico Vaga
