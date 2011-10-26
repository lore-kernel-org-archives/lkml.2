Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1JZFl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 01:41:59 -0400
Received: from 8.mo3.mail-out.ovh.net ([87.98.172.249]:53771 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753934Ab1JZFl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 01:41:57 -0400
X-Greylist: delayed 1507 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 01:41:57 EDT
Date: Wed, 26 Oct 2011 07:16:04 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        akpm@linux-foundation.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 1/7] amp/remoteproc: add framework for controlling
 remote processors
Message-ID: <20111026051604.GT2638@game.jcrosoft.org>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
 <1319536106-25802-2-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319536106-25802-2-git-send-email-ohad@wizery.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 10923199421357009716
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -300
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeftddrheekucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddmnehlihhnuhigfeigucdlqdeftddmnehvohhiugdpihhnthculddquddttddmnehnohcuhhhoshhtuchurhhlucdlfedtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:48 Tue 25 Oct     , Ohad Ben-Cohen wrote:
> Modern SoCs typically employ a central symmetric multiprocessing (SMP)
> application processor running Linux, with several other asymmetric
> multiprocessing (AMP) heterogeneous processors running different instances
> of operating system, whether Linux or any other flavor of real-time OS.
> 
> Booting a remote processor in an AMP configuration typically involves:
> - Loading a firmware which contains the OS image
> - Allocating and providing it required system resources (e.g. memory)
> - Programming an IOMMU (when relevant)
> - Powering on the device
> 
> This patch introduces a generic framework that allows drivers to do
> that. In the future, this framework will also include runtime power
> management and error recovery.
> 
> Based on (but now quite far from) work done by Fernando Guzman Lugo
> <fernando.lugo@ti.com>.
> 
> ELF loader was written by Mark Grosen <mgrosen@ti.com>, based on
> msm's Peripheral Image Loader (PIL) by Stephen Boyd <sboyd@codeaurora.org>.
> 
> Designed with Brian Swetland <swetland@google.com>.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Brian Swetland <swetland@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  Documentation/amp/remoteproc.txt             |  324 ++++++
>  MAINTAINERS                                  |    7 +
>  drivers/Kconfig                              |    2 +
>  drivers/Makefile                             |    1 +
>  drivers/amp/Kconfig                          |    9 +
>  drivers/amp/Makefile                         |    1 +
>  drivers/amp/remoteproc/Kconfig               |    3 +
>  drivers/amp/remoteproc/Makefile              |    6 +
>  drivers/amp/remoteproc/remoteproc_core.c     | 1410 ++++++++++++++++++++++++++
>  drivers/amp/remoteproc/remoteproc_internal.h |   44 +
>  include/linux/amp/remoteproc.h               |  265 +++++
>  11 files changed, 2072 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/amp/remoteproc.txt
>  create mode 100644 drivers/amp/Kconfig
>  create mode 100644 drivers/amp/Makefile
>  create mode 100644 drivers/amp/remoteproc/Kconfig
>  create mode 100644 drivers/amp/remoteproc/Makefile
>  create mode 100644 drivers/amp/remoteproc/remoteproc_core.c
>  create mode 100644 drivers/amp/remoteproc/remoteproc_internal.h
>  create mode 100644 include/linux/amp/remoteproc.h
> 
> diff --git a/Documentation/amp/remoteproc.txt b/Documentation/amp/remoteproc.txt
> new file mode 100644
> index 0000000..63cecd9
> --- /dev/null
> +++ b/Documentation/amp/remoteproc.txt
> @@ -0,0 +1,324 @@
> +Remote Processor Framework
> +
> +1. Introduction
> +
> +Modern SoCs typically have heterogeneous remote processor devices in asymmetric
> +multiprocessing (AMP) configurations, which may be running different instances
> +of operating system, whether it's Linux or any other flavor of real-time OS.
> +
> +OMAP4, for example, has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP.
> +In a typical configuration, the dual cortex-A9 is running Linux in a SMP
> +configuration, and each of the other three cores (two M3 cores and a DSP)
> +is running its own instance of RTOS in an AMP configuration.
> +
> +The remoteproc framework allows different platforms/architectures to
> +control (power on, load firmware, power off) those remote processors while
> +abstracting the hardware differences, so the entire driver doesn't need to be
> +duplicated. In addition, this framework also adds rpmsg virtio devices
> +for remote processors that supports this kind of communication. This way,
> +platform-specific remoteproc drivers only need to provide a few low-level
> +handlers, and then all rpmsg drivers will then just work
> +(for more information about the virtio-based rpmsg bus and its drivers,
> +please read Documentation/amp/rpmsg.txt).
> +
> +2. User API
> +
> +  int rproc_boot(struct rproc *rproc)
> +    - Boot a remote processor (i.e. load its firmware, power it on, ...).
> +      If the remote processor is already powered on, this function immediately
> +      returns (successfully).
> +      Returns 0 on success, and an appropriate error value otherwise.
> +      Note: to use this function you should already have a valid rproc
> +      handle. There are several ways to achieve that cleanly (devres, pdata,
> +      the way remoteproc_rpmsg.c does this, or, if this becomes prevalent, we
> +      might also consider using dev_archdata for this). See also
> +      rproc_get_by_name() below.
> +
> +  void rproc_shutdown(struct rproc *rproc)
> +    - Power off a remote processor (previously booted with rproc_boot()).
> +      In case @rproc is still being used by an additional user(s), then
> +      this function will just decrement the power refcount and exit,
> +      without really powering off the device.
> +      Every call to rproc_boot() must (eventually) be accompanied by a call
> +      to rproc_shutdown(). Calling rproc_shutdown() redundantly is a bug.
> +      Notes:
> +      - we're not decrementing the rproc's refcount, only the power refcount.
> +        which means that the @rproc handle stays valid even after
> +        rproc_shutdown() returns, and users can still use it with a subsequent
> +        rproc_boot(), if needed.
> +      - don't call rproc_shutdown() to unroll rproc_get_by_name(), exactly
> +        because rproc_shutdown() _does not_ decrement the refcount of @rproc.
> +        To decrement the refcount of @rproc, use rproc_put() (but _only_ if
> +        you acquired @rproc using rproc_get_by_name()).
> +
> +  struct rproc *rproc_get_by_name(const char *name)
> +    - Find an rproc handle using the remote processor's name, and then
> +      boot it. If it's already powered on, then just immediately return
> +      (successfully). Returns the rproc handle on success, and NULL on failure.
> +      This function increments the remote processor's refcount, so always
> +      use rproc_put() to decrement it back once rproc isn't needed anymore.
> +      Note: currently this function (and its counterpart rproc_put()) are not
> +      used anymore by the amp sub-system. We need to scrutinize the use cases
> +      that still need them, and see if we can migrate them to use the non
> +      name-based boot/shutdown interface.
> +
> +  void rproc_put(struct rproc *rproc)
> +    - Decrement @rproc's power refcount and shut it down if it reaches zero
> +      (essentially by just calling rproc_shutdown), and then decrement @rproc's
> +      validity refcount too.
> +      After this function returns, @rproc may _not_ be used anymore, and its
> +      handle should be considered invalid.
> +      This function should be called _iff_ the @rproc handle was grabbed by
> +      calling rproc_get_by_name().
> +
> +3. Typical usage
> +
> +#include <linux/amp/remoteproc.h>
> +
> +/* in case we were given a valid 'rproc' handle */
> +int dummy_rproc_example(struct rproc *my_rproc)
> +{
> +	int ret;
> +
> +	/* let's power on and boot our remote processor */
> +	ret = rproc_boot(my_rproc);
> +	if (ret) {
> +		/*
> +		 * something went wrong. handle it and leave.
> +		 */
> +	}
> +
> +	/*
> +	 * our remote processor is now powered on... give it some work
> +	 */
> +
> +	/* let's shut it down now */
> +	rproc_shutdown(my_rproc);
> +}
> +
> +4. API for implementors
> +
> +  struct rproc *rproc_alloc(struct device *dev, const char *name,
> +				const struct rproc_ops *ops,
> +				const char *firmware, int len)
> +    - Allocate a new remote processor handle, but don't register
> +      it yet. Required parameters are the underlying device, the
> +      name of this remote processor, platform-specific ops handlers,
> +      the name of the firmware to boot this rproc with, and the
> +      length of private data needed by the allocating rproc driver (in bytes).
> +
> +      This function should be used by rproc implementations during
> +      initialization of the remote processor.
> +      After creating an rproc handle using this function, and when ready,
> +      implementations should then call rproc_register() to complete
> +      the registration of the remote processor.
> +      On success, the new rproc is returned, and on failure, NULL.
> +
> +      Note: _never_ directly deallocate @rproc, even if it was not registered
> +      yet. Instead, if you just need to unroll rproc_alloc(), use rproc_free().
> +
> +  void rproc_free(struct rproc *rproc)
> +    - Free an rproc handle that was allocated by rproc_alloc.
> +      This function should _only_ be used if @rproc was only allocated,
> +      but not registered yet.
> +      If @rproc was already successfully registered (by calling
> +      rproc_register()), then use rproc_unregister() instead.
> +
> +  int rproc_register(struct rproc *rproc)
> +    - Register @rproc with the remoteproc framework, after it has been
> +      allocated with rproc_alloc().
> +      This is called by the platform-specific rproc implementation, whenever
> +      a new remote processor device is probed.
> +      Returns 0 on success and an appropriate error code otherwise.
> +      Note: this function initiates an asynchronous firmware loading
> +      context, which will look for virtio devices supported by the rproc's
> +      firmware.
> +      If found, those virtio devices will be created and added, so as a result
> +      of registering this remote processor, additional virtio drivers might get
> +      probed.
> +      Currently, though, we only support a single RPMSG virtio vdev per remote
> +      processor.
> +
> +  int rproc_unregister(struct rproc *rproc)
> +    - Unregister a remote processor, and decrement its refcount.
> +      If its refcount drops to zero, then @rproc will be freed. If not,
> +      it will be freed later once the last reference is dropped.
> +
> +      This function should be called when the platform specific rproc
> +      implementation decides to remove the rproc device. it should
> +      _only_ be called if a previous invocation of rproc_register()
> +      has completed successfully.
> +
> +      After rproc_unregister() returns, @rproc is _not_ valid anymore and
> +      it shouldn't be used. More specifically, don't call rproc_free()
> +      or try to directly free @rproc after rproc_unregister() returns;
> +      none of these are needed, and calling them is a bug.
> +
> +      Returns 0 on success and -EINVAL if @rproc isn't valid.
> +
> +5. Implementation callbacks
> +
> +These callbacks should be provided by platform-specific remoteproc
> +drivers:
> +
> +/**
> + * struct rproc_ops - platform-specific device handlers
> + * @start:	power on the device and boot it
> + * @stop:	power off the device
> + * @kick:	kick a virtqueue (virtqueue id given as a parameter)
> + */
> +struct rproc_ops {
> +	int (*start)(struct rproc *rproc);
> +	int (*stop)(struct rproc *rproc);
> +	void (*kick)(struct rproc *rproc, int vqid);
> +};
> +
> +Every remoteproc implementation should at least provide the ->start and ->stop
> +handlers. If rpmsg functionality is also desired, then the ->kick handler
> +should be provided as well.
> +
> +The ->start() handler takes an rproc handle and should then power on the
> +device and boot it (use rproc->priv to access platform-specific private data).
> +The boot address, in case needed, can be found in rproc->bootaddr (remoteproc
> +core puts there the ELF entry point).
> +On success, 0 should be returned, and on failure, an appropriate error code.
> +
> +The ->stop() handler takes an rproc handle and powers the device down.
> +On success, 0 is returned, and on failure, an appropriate error code.
> +
> +The ->kick() handler takes an rproc handle, and an index of a virtqueue
> +where new message was placed in. Implementations should interrupt the remote
> +processor and let it know it has pending messages. Notifying remote processors
> +the exact virtqueue index to look in is optional: it is easy (and not
> +too expensive) to go through the existing virtqueues and look for new buffers
> +in the used rings.
> +
> +6. Binary Firmware Structure
> +
> +At this point remoteproc only supports ELF32 firmware binaries. However,
> +it is quite expected that other platforms/devices which we'd want to
> +support with this framework will be based on different binary formats.
> +
> +When those use cases show up, we will have to decouple the binary format
> +from the framework core, so we can support several binary formats without
> +duplicating common code.
> +
> +When the firmware is parsed, its various segments are loaded to memory
> +according to the specified device address (might be a physical address
> +if the remote processor is accessing memory directly).
> +
> +In addition to the standard ELF segments, most remote processors would
> +also include a special section which we call "the resource table".
> +
> +The resource table contains system resources that the remote processor
> +requires before it should be powered on, such as allocation of physically
> +contiguous memory, or iommu mapping of certain on-chip peripherals.
> +Remotecore will only power up the device after all the resource table's
> +requirement are met.
> +
> +In addition to system resources, the resource table may also contain
> +resource entries that publish the existence of supported features
> +or configurations by the remote processor, such as trace buffers and
> +supported virtio devices (and their configurations).
> +
> +Currently the resource table is just an array of:
> +
> +/**
> + * struct fw_resource - describes an entry from the resource section
> + * @type: resource type
> + * @id: index number of the resource
> + * @da: device address of the resource
> + * @pa: physical address of the resource
> + * @len: size, in bytes, of the resource
> + * @flags: properties of the resource, e.g. iommu protection required
> + * @reserved: must be 0 atm
> + * @name: name of resource
> + */
> +struct fw_resource {
> +	u32 type;
> +	u32 id;
> +	u64 da;
> +	u64 pa;
> +	u32 len;
> +	u32 flags;
> +	u8 reserved[16];
> +	u8 name[48];
> +} __packed;
> +
> +Some resources entries are mere announcements, where the host is informed
> +of specific remoteproc configuration. Other entries require the host to
> +do something (e.g. reserve a requested resource) and possibly also reply
> +by overwriting a member inside 'struct fw_resource' with info about the
> +allocated resource.
> +
> +Different resource entries use different members of this struct,
> +with different meanings. This is pretty limiting and error-prone,
> +so the plan is to move to variable-length TLV-based resource entries,
> +where each resource will begin with a type and length fields, followed by
> +its own specific structure.
> +
> +Here are the resource types that are currently being used:
> +
> +/**
> + * enum fw_resource_type - types of resource entries
> + *
> + * @RSC_CARVEOUT:   request for allocation of a physically contiguous
> + *		    memory region.
> + * @RSC_DEVMEM:     request to iommu_map a memory-based peripheral.
> + * @RSC_TRACE:	    announces the availability of a trace buffer into which
> + *		    the remote processor will be writing logs. In this case,
> + *		    'da' indicates the device address where logs are written to,
> + *		    and 'len' is the size of the trace buffer.
> + * @RSC_VRING:	    request for allocation of a virtio vring (address should
> + *		    be indicated in 'da', and 'len' should contain the number
> + *		    of buffers supported by the vring).
> + * @RSC_VIRTIO_DEV: announces support for a virtio device, and serves as
> + *		    the virtio header. 'da' contains the virtio device
> + *		    features, 'pa' holds the virtio guest features (host
> + *		    will write them here after they're negotiated), 'len'
> + *		    holds the virtio status, and 'flags' holds the virtio
> + *		    device id (currently only VIRTIO_ID_RPMSG is supported).
> + */
> +enum fw_resource_type {
> +	RSC_CARVEOUT	= 0,
> +	RSC_DEVMEM	= 1,
> +	RSC_TRACE	= 2,
> +	RSC_VRING	= 3,
> +	RSC_VIRTIO_DEV	= 4,
> +	RSC_VIRTIO_CFG	= 5,
> +};
> +
> +Most of the resource entries share the basic idea of address/length
> +negotiation with the host: the firmware usually asks for memory
> +of size 'len' bytes, and the host needs to allocate it and provide
> +the device/physical address (when relevant) in 'da'/'pa' respectively.
> +
> +If the firmware is compiled with hard coded device addresses, and
> +can't handle dynamically allocated 'da' values, then the 'da' field
> +will contain the expected device addresses (today we actually only support
> +this scheme, as there aren't yet any use cases for dynamically allocated
> +device addresses).
> +
> +We also expect that platform-specific resource entries will show up
> +at some point. When that happens, we could easily add a new RSC_PLAFORM
> +type, and hand those resources to the platform-specific rproc driver to handle.
> +
> +7. Virtio and remoteproc
> +
> +The firmware should provide remoteproc information about virtio devices
> +that it supports, and their configurations: a RSC_VIRTIO_DEV resource entry
> +should specify the virtio device id, and subsequent RSC_VRING resource entries
> +should indicate the vring size (i.e. how many buffers do they support) and
> +where should they be mapped (i.e. which device address). Note: the alignment
> +between the consumer and producer parts of the vring is assumed to be 4096.
> +
> +At this point we only support a single virtio rpmsg device per remote
> +processor, but the plan is to remove this limitation. In addition, once we
> +move to TLV-based resource table, the plan is to have a single RSC_VIRTIO
> +entry per supported virtio device, which will include the virtio header,
> +the vrings information and the virtio config space.
> +
> +Of course, RSC_VIRTIO resource entries are only good enough for static
> +allocation of virtio devices. Dynamic allocations will also be made possible
> +using the rpmsg bus (similar to how we already do dynamic allocations of
> +rpmsg channels; read more about it in rpmsg.txt).
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ace8f9c..2812cd7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1205,6 +1205,13 @@ L:	lm-sensors@lm-sensors.org
>  S:	Maintained
>  F:	drivers/hwmon/asb100.c
>  
> +ASYNCHRONOUS MULTIPROCESSING (AMP) FRAMEWORK
> +M:	Ohad Ben-Cohen <ohad@wizery.com>
> +S:	Maintained
> +F:	drivers/amp/
> +F:	Documentation/amp/
> +F:	include/linux/amp/
> +
>  ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
>  M:	Dan Williams <dan.j.williams@intel.com>
>  W:	http://sourceforge.net/projects/xscaleiop
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 95b9e7e..dfb7d36 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -128,6 +128,8 @@ source "drivers/clocksource/Kconfig"
>  
>  source "drivers/iommu/Kconfig"
>  
> +source "drivers/amp/Kconfig"
> +
>  source "drivers/virt/Kconfig"
>  
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 7fa433a..8f41a77 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -124,6 +124,7 @@ obj-y				+= clk/
>  obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
>  obj-$(CONFIG_NFC)		+= nfc/
>  obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
> +obj-y				+= amp/
>  
>  # Virtualization drivers
>  obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
> diff --git a/drivers/amp/Kconfig b/drivers/amp/Kconfig
> new file mode 100644
> index 0000000..23a8ed1
> --- /dev/null
> +++ b/drivers/amp/Kconfig
> @@ -0,0 +1,9 @@
> +#
> +# AMP subsystem configuration
> +#
> +
> +menu "Asymmetric Multiprocessing (AMP) Framework"
> +
> +source "drivers/amp/remoteproc/Kconfig"
> +
> +endmenu
> diff --git a/drivers/amp/Makefile b/drivers/amp/Makefile
> new file mode 100644
> index 0000000..708461d
> --- /dev/null
> +++ b/drivers/amp/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_REMOTEPROC)	+= remoteproc/
> diff --git a/drivers/amp/remoteproc/Kconfig b/drivers/amp/remoteproc/Kconfig
> new file mode 100644
> index 0000000..b250b15
> --- /dev/null
> +++ b/drivers/amp/remoteproc/Kconfig
> @@ -0,0 +1,3 @@
> +# REMOTEPROC gets selected by whoever wants it
> +config REMOTEPROC
> +	tristate
> diff --git a/drivers/amp/remoteproc/Makefile b/drivers/amp/remoteproc/Makefile
> new file mode 100644
> index 0000000..2a5fd79
> --- /dev/null
> +++ b/drivers/amp/remoteproc/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Generic framework for controlling remote processors
> +#
> +
> +obj-$(CONFIG_REMOTEPROC)		+= remoteproc.o
> +remoteproc-y				:= remoteproc_core.o
> diff --git a/drivers/amp/remoteproc/remoteproc_core.c b/drivers/amp/remoteproc/remoteproc_core.c
> new file mode 100644
> index 0000000..be6774f
> --- /dev/null
> +++ b/drivers/amp/remoteproc/remoteproc_core.c
> @@ -0,0 +1,1410 @@
> +/*
> + * Remote Processor Framework
> + *
> + * Copyright (C) 2011 Texas Instruments, Inc.
> + * Copyright (C) 2011 Google, Inc.
> + *
> + * Ohad Ben-Cohen <ohad@wizery.com>
> + * Brian Swetland <swetland@google.com>
> + * Mark Grosen <mgrosen@ti.com>
> + * Fernando Guzman Lugo <fernando.lugo@ti.com>
> + * Suman Anna <s-anna@ti.com>
> + * Robert Tivy <rtivy@ti.com>
> + * Armando Uribe De Leon <x0095078@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#define pr_fmt(fmt)    "%s: " fmt, __func__
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/firmware.h>
> +#include <linux/string.h>
> +#include <linux/debugfs.h>
> +#include <linux/amp/remoteproc.h>
> +#include <linux/iommu.h>
> +#include <linux/klist.h>
> +#include <linux/elf.h>
> +#include <linux/virtio_ids.h>
> +#include <linux/virtio_ring.h>
> +
> +#include "remoteproc_internal.h"
> +
> +static void klist_rproc_get(struct klist_node *n);
> +static void klist_rproc_put(struct klist_node *n);
> +
> +/*
> + * klist of the available remote processors.
> + *
> + * We need this in order to support name-based lookups (needed by the
> + * rproc_get_by_name()).
> + *
> + * That said, we don't use rproc_get_by_name() anymore within the amp
> + * framework. The use cases that do require its existence should be
> + * scrutinized, and hopefully migrated to rproc_boot() using device-based
> + * binding.
> + *
> + * If/when this materializes, we could drop the klist (and the by_name
> + * API).
> + */
> +static DEFINE_KLIST(rprocs, klist_rproc_get, klist_rproc_put);
> +
> +typedef int (*rproc_handle_resources_t)(struct rproc *rproc,
> +				struct fw_resource *rsc, int len);
> +
> +/*
> + * This is the IOMMU fault handler we register with the IOMMU API
> + * (when relevant; not all remote processors access memory through
> + * an IOMMU).
> + *
> + * IOMMU core will invoke this handler whenever the remote processor
> + * will try to access an unmapped device address.
> + *
> + * Currently this is mostly a stub, but it will be later used to trigger
> + * the recovery of the remote processor.
> + */
> +static int rproc_iommu_fault(struct iommu_domain *domain, struct device *dev,
> +		unsigned long iova, int flags)
> +{
> +	dev_err(dev, "iommu fault: da 0x%lx flags 0x%x\n", iova, flags);
> +
> +	/*
> +	 * Let the iommu core know we're not really handling this fault;
> +	 * we just plan to use this as a recovery trigger.
> +	 */
> +	return -ENOSYS;
> +}
> +
> +static int rproc_enable_iommu(struct rproc *rproc)
> +{
> +	struct iommu_domain *domain;
> +	struct device *dev = rproc->dev;
> +	int ret;
> +
> +	/*
> +	 * We currently use iommu_present() to decide if an IOMMU
> +	 * setup is needed.
> +	 *
> +	 * This works for simple cases, but will easily fail with
> +	 * platforms that do have an IOMMU, but not for this specific
> +	 * rproc.
> +	 *
> +	 * This will be easily solved by introducing hw capabilities
> +	 * that will be set by the remoteproc driver.
> +	 */
> +	if (!iommu_present(dev->bus)) {
> +		dev_err(dev, "iommu not found\n");
> +		return -ENODEV;
> +	}
> +
> +	domain = iommu_domain_alloc(dev->bus);
> +	if (!domain) {
> +		dev_err(dev, "can't alloc iommu domain\n");
> +		return -ENOMEM;
> +	}
> +
> +	iommu_set_fault_handler(domain, rproc_iommu_fault);
> +
> +	ret = iommu_attach_device(domain, dev);
> +	if (ret) {
> +		dev_err(dev, "can't attach iommu device: %d\n", ret);
> +		goto free_domain;
> +	}
> +
> +	rproc->domain = domain;
> +
> +	return 0;
> +
> +free_domain:
> +	iommu_domain_free(domain);
> +	return ret;
> +}
> +
> +static void rproc_disable_iommu(struct rproc *rproc)
> +{
> +	struct iommu_domain *domain = rproc->domain;
> +	struct device *dev = rproc->dev;
> +
> +	if (!domain)
> +		return;
> +
> +	iommu_detach_device(domain, dev);
> +	iommu_domain_free(domain);
> +
> +	return;
> +}
> +
> +/*
> + * Some remote processors will ask us to allocate them physically contiguous
> + * memory regions (which we call "carveouts"), and map them to specific
> + * device addresses (which are hardcoded in the firmware).
> + *
> + * They may then ask us to copy objects into specific device addresses (e.g.
> + * code/data sections) or expose us certain symbols in other device address
> + * (e.g. their trace buffer).
> + *
> + * This function is an internal helper with which we can go over the allocated
> + * carveouts and translate specific device address to kernel virtual addresses
> + * so we can access the referenced memory.
> + *
> + * Note: phys_to_virt(iommu_iova_to_phys(rproc->domain, da)) will work too,
> + * but only on kernel direct mapped RAM memory. Instead, we're just using
> + * here the output of the DMA API, which should be more correct.
> + */
> +static void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
> +{
> +	struct rproc_mem_entry *carveout;
> +	void *ptr = NULL;
> +
> +	list_for_each_entry(carveout, &rproc->carveouts, node) {
> +		int offset = da - carveout->da;
> +
> +		/* try next carveout if da is too small */
> +		if (offset < 0)
> +			continue;
> +
> +		/* try next carveout if da is too large */
> +		if (offset + len > carveout->len)
> +			continue;
> +
> +		ptr = carveout->va + offset;
> +
> +		break;
> +	}
> +
> +	return ptr;
> +}
> +
> +/**
> + * rproc_load_segments() - load firmware segments to memory
> + * @rproc: remote processor which will be booted using these fw segments
> + * @elf_data: the content of the ELF firmware image
> + *
> + * This function loads the firmware segments to memory, where the remote
> + * processor expects them.
> + *
> + * Some remote processors will expect their code and data to be placed
> + * in specific device addresses, and can't have them dynamically assigned.
> + *
> + * We currently support only those kind of remote processors, and expect
> + * the program header's paddr member to contain those addresses. We then go
> + * through the physically contiguous "carveout" memory regions which we
> + * allocated (and mapped) earlier on behalf of the remote processor,
> + * and "translate" device address to kernel addresses, so we can copy the
> + * segments where they are expected.
On STM Soc you can upload the firmware code where you want
the you just have to specify in 2 register where the entry point of the co-pro

we need to support this too

the elf can be self relocated, I used barebox this way.

BTW do you plan to support CMA as a lot of copro will request a big
contineuous memory to work on between the cpus.

I've to go to the ELCE will continue the review later

Best Regards,
J.
