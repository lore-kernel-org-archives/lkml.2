Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423218Ab2JaQYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:24:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48056 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423155Ab2JaQYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:24:11 -0400
Date: Wed, 31 Oct 2012 09:24:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 list <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/5] driver core / ACPI: Move ACPI support to core device
 and driver types
Message-ID: <20121031162407.GA318@kroah.com>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan>
 <1825320.jYYkSTpTOm@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1825320.jYYkSTpTOm@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 10:38:29AM +0100, Rafael J. Wysocki wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> With ACPI 5 we are starting to see devices that don't natively support
> discovery but can be enumerated with the help of the ACPI namespace.
> Typically, these devices can be represented in the Linux device driver
> model as platform devices or some serial bus devices, like SPI or I2C
> devices.
> 
> Since we want to re-use existing drivers for those devices, we need a
> way for drivers to specify the ACPI IDs of supported devices, so that
> they can be matched against device nodes in the ACPI namespace.  To
> this end, it is sufficient to add a pointer to an array of supported
> ACPI device IDs, that can be provided by the driver, to struct device.
> 
> Moreover, things like ACPI power management need to have access to
> the ACPI handle of each supported device, because that handle is used
> to invoke AML methods associated with the corresponding ACPI device
> node.  The ACPI handles of devices are now stored in the archdata
> member structure of struct device whose definition depends on the
> architecture and includes the ACPI handle only on x86 and ia64. Since
> the pointer to an array of supported ACPI IDs is added to struct
> device_driver in an architecture-independent way, it is logical to
> move the ACPI handle from archdata to struct device itself at the same
> time.  This also makes code more straightforward in some places and
> follows the example of Device Trees that have a poiter to struct
> device_node in there too.
> 
> This changeset is based on Mika Westerberg's work.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  arch/ia64/include/asm/device.h |    3 ---
>  arch/x86/include/asm/device.h  |    3 ---
>  drivers/acpi/glue.c            |   14 ++++++--------
>  include/acpi/acpi_bus.h        |    2 +-
>  include/linux/device.h         |    4 ++++
>  5 files changed, 11 insertions(+), 15 deletions(-)

The driver core pieces look fine to me:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

