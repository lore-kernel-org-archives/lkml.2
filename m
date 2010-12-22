Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0LVRSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 12:18:33 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18932 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab0LVRSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 12:18:31 -0500
Date: Wed, 22 Dec 2010 09:11:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: tapio.vihuri@nokia.com
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, ilkka.koskinen@nokia.com,
        samu.p.onkalo@nokia.com
Subject: Re: [PATCH 2/3] ECI: introducing ECI bus driver
Message-Id: <20101222091129.da1ecb22.randy.dunlap@oracle.com>
In-Reply-To: <1293020435-5680-3-git-send-email-tapio.vihuri@nokia.com>
References: <1293020435-5680-1-git-send-email-tapio.vihuri@nokia.com>
	<1293020435-5680-2-git-send-email-tapio.vihuri@nokia.com>
	<1293020435-5680-3-git-send-email-tapio.vihuri@nokia.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010 14:20:34 +0200 tapio.vihuri@nokia.com wrote:

> From: Tapio Vihuri <tapio.vihuri@nokia.com>
> 
> ECI bus controller is kind of bridge between host CPU I2C and ECI accessory
> ECI communication.
> 
> Signed-off-by: Tapio Vihuri <tapio.vihuri@nokia.com>
> ---
>  drivers/Kconfig           |    2 +
>  drivers/Makefile          |    1 +
>  drivers/ecibus/Kconfig    |   46 ++++
>  drivers/ecibus/Makefile   |   10 +
>  drivers/ecibus/ecibus.c   |  583 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/input/eci.h |    8 +
>  6 files changed, 650 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/ecibus/Kconfig
>  create mode 100644 drivers/ecibus/Makefile
>  create mode 100644 drivers/ecibus/ecibus.c


> diff --git a/drivers/ecibus/Kconfig b/drivers/ecibus/Kconfig
> new file mode 100644
> index 0000000..27e5e36
> --- /dev/null
> +++ b/drivers/ecibus/Kconfig
> @@ -0,0 +1,46 @@
> +#
> +# ECI driver configuration
> +#
> +menuconfig ECI
> +	bool "ECI support"
> +	help
> +	  ECI (Enhancement Control Interface) accessory support
> +
> +	  The Enhancement Control Interface functionality
> +	  ECI is better known as Multimedia Headset for Nokia phones.
> +	  If headset has many buttons, like play, vol+, vol- etc. then
> +	  it is propably ECI accessory.
> +	  Among several buttons ECI accessory contains memory for storing
> +	  several parameters.
> +
> +	  Enable ECI support in terminal so that ECI input driver is able
> +	  to communicate with ECI accessory
> +
> +if ECI
> +
> +config ECI_DEBUG
> +	boolean "Debug support for ECI drivers"
> +	depends on DEBUG_KERNEL
> +	help
> +	  Selects ECI driver debug messaging.
> +
> +	  Say "yes" to enable debug messaging (like dev_dbg and pr_debug),
> +	  sysfs, and debugfs support in ECI controller.
> +
> +comment "ECI Master Controller Drivers"
> +
> +config ECI_BUS
> +	tristate "ECI bus controller driver"
> +	select INPUT_ECI


'select' INPUT_ECI when INPUT and/or INPUT_MISC are not enabled causes this
kconfig warning:

warning: (ECI_BUS && ECI) selects INPUT_ECI which has unmet direct dependencies (!S390 && INPUT && INPUT_MISC)


> +	help
> +	  This selects a driver for the ECI bus controller
> +
> +	  ECI bus controller is kind of bridge between host CPU I2C and
> +	  ECI accessory ECI communication.
> +
> +	  Say 'y' here to statically link this module into the kernel or 'm'
> +	  to build it as a dynamically loadable module. The module will be
> +	  called ecibus.ko
> +
> +
> +endif # ECI


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
