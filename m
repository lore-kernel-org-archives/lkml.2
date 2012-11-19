Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2KSVw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:52:27 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:53697 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab2KSVwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:52:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI / platform: Initialize ACPI handles of platform devices in advance
Date: Mon, 19 Nov 2012 22:56:51 +0100
Message-ID: <2759563.fok65Kthx8@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121119210528.GJ17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <1610515.dOb8aMkzLk@vostro.rjw.lan> <20121119210528.GJ17774@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 19, 2012 11:05:28 PM Mika Westerberg wrote:
> On Mon, Nov 19, 2012 at 09:44:21PM +0100, Rafael J. Wysocki wrote:
> > So, we want to have acpi_handle (or acpi_node) in addition to of_node in struct
> > device (to be used in the analogous way plus for the execution of AML methods),
> > but we don't want all users of device.h to have to include ACPI headers
> > where the acpi_handle data type is defined.  For this reason, we're using
> > (void *) as its data type now, which let's say I'm not really happy with.
> > 
> > I've been thinking about that for quite a while, though, and I'm not really
> > sure what to do about that.  Perhaps we could define something like
> > 
> > struct acpi_dev_node {
> > #ifdef CONFIG_ACPI
> > 	void *handle;
> > #endif
> > };
> > 
> > in device.h and use that as "struct acpi_dev_node acpi_node;" in struct device.
> > Then, we could add the following macro
> > 
> > #ifdef CONFIG_ACPI
> > #define ACPI_HANDLE(dev)	((dev)->acpi_node.handle)
> > #else
> > #define ACPI_HANDLE(dev)	(NULL)
> > #endif
> > 
> > and redefine DEVICE_ACPI_HANDLE(dev) as ((acpi_handle)ACPI_HANDLE(dev)).
> > 
> > Then, the $subject patch would add "struct acpi_dev_node acpi_node;" to
> > struct platform_device_info and use ACPI_HANDLE(dev) instead of accessing
> > the struct device's field directly.
> 
> In addition to struct platform_device_info, we are also going to add
> similar to struct i2c_board_info. There already is of_node pointer so I was
> thinking to add acpi_handle like you did for platform_device.

Yeah, that's kind of something that comes to mind immediately. :-)

> Type of that pointer of course needs to be figured out :)

Yup.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
