Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab1DHWBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 18:01:39 -0400
Received: from kroah.org ([198.145.64.141]:44293 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1DHWBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 18:01:38 -0400
Date: Fri, 8 Apr 2011 15:01:57 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][WAS:bcmai][PATCH V2] axi: add AXI bus driver
Message-ID: <20110408220157.GC26019@kroah.com>
References: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 09:45:00PM +0200, Rafał Miłecki wrote:
> Cc: Michael Büsch <mb@bu3sch.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: George Kashperko <george@znau.edu.ua>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: linux-arm-kernel@lists.infradead.org <linux-arm-kernel@lists.infradead.org>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linuxdriverproject <devel@linuxdriverproject.org>
> Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This is second try for introducing new bus driver.
> V2: Rename to axi
>     Use DEFINE_PCI_DEVICE_TABLE in bridge
>     Make use of pr_fmt and pr_*
>     Store core class
>     Rename bridge to not b43 specific
>     Replace magic 0x1000 with BCMAI_CORE_SIZE
>     Remove some old "ssb" names and defines
>     Move BCMAI_ADDR_BASE def
>     Add drvdata field
> TODO:
> - Interrupts
> - Reloading driver

Please add to the TODO list:
	- Documentation/ABI entries for new sysfs files
	- proper Kconfig entry documentation for the different options
	- remove unneeded pcicore_write* wrapper functions that do
	  nothing.


> +static void axi_release_core_dev(struct device *dev)
> +{
> +	kfree(dev);
> +}

This is wrong, unless you are really only creating a 'struct device'.
Why are you doing that instead of embedding struct device in your
structure?

thanks,

greg k-h
