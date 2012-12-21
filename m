Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2LURRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 12:17:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31779 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LURRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 12:17:43 -0500
Date: Fri, 21 Dec 2012 12:17:15 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
Cc: key@linux.vnet.ibm.com, mail@srajiv.net, jeremy@goop.org,
        tpmdd-devel@lists.sourceforge.net, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] add xen-tpmfront.ko: Xen Virtual TPM frontend driver
Message-ID: <20121221171715.GE25526@phenom.dumpdata.com>
References: <1353421985-25398-1-git-send-email-matthew.fioravante@jhuapl.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353421985-25398-1-git-send-email-matthew.fioravante@jhuapl.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 09:33:05AM -0500, Matthew Fioravante wrote:

Hey Matthew,

Sorry for the late response. 


I ran this throught checkpatch I got these:


CHECK: spinlock_t definition without comment
#476: FILE: drivers/char/tpm/xen-tpmfront_if.c:62:
+	spinlock_t tx_lock;

CHECK: Alignment should match open parenthesis
#520: FILE: drivers/char/tpm/xen-tpmfront_if.c:106:
+tx_buffer_copy(struct tx_buffer *txb, const u8 *src, int len,
+		int isuserbuffer)

CHECK: Alignment should match open parenthesis
#673: FILE: drivers/char/tpm/xen-tpmfront_if.c:259:
+		gnttab_end_foreign_access(tp->ring_ref,
+				0, (unsigned long)tp->tx);

WARNING: Avoid CamelCase: <XenbusStateConnected>
#727: FILE: drivers/char/tpm/xen-tpmfront_if.c:313:
+	xenbus_switch_state(dev, XenbusStateConnected);

CHECK: Alignment should match open parenthesis
#1014: FILE: drivers/char/tpm/xen-tpmfront_if.c:600:
+		gnttab_grant_foreign_access_ref(tx->ref,
+				tp->backend_id,

CHECK: memory barrier without comment
#1023: FILE: drivers/char/tpm/xen-tpmfront_if.c:609:
+	mb();

CHECK: Alignment should match open parenthesis
#1085: FILE: drivers/char/tpm/xen-tpmfront_if.c:671:
+	if (gnttab_alloc_grant_references(TPMIF_TX_RING_SIZE,
+				&gref_head) < 0) {

CHECK: Alignment should match open parenthesis
#1197: FILE: drivers/char/tpm/xen-tpmfront_vtpm.c:89:
+transmission_set_req_buffer(struct transmission *t,
+		unsigned char *buffer, size_t len)

CHECK: Alignment should match open parenthesis
#1217: FILE: drivers/char/tpm/xen-tpmfront_vtpm.c:109:
+transmission_set_res_buffer(struct transmission *t,
+		const unsigned char *buffer, size_t len)

CHECK: Alignment should match open parenthesis
#1348: FILE: drivers/char/tpm/xen-tpmfront_vtpm.c:240:
+		interruptible_sleep_on_timeout(&vtpms->resp_wait_queue,
+				1000);

CHECK: Alignment should match open parenthesis
#1402: FILE: drivers/char/tpm/xen-tpmfront_vtpm.c:294:
+		if (time_after(jiffies,
+					vtpms->disconnect_time + HZ * 10)) {

CHECK: Blank lines aren't necessary after an open brace '{'
#1412: FILE: drivers/char/tpm/xen-tpmfront_vtpm.c:304:
+		if (_vtpm_send_queued(chip) == 0) {
+

CHECK: Alignment should match open parenthesis
#1490: FILE: drivers/char/tpm/xen-tpmfront_vtpm.c:382:
+				list_add(&qt->next,
+						&vtpms->queued_requests);

CHECK: Alignment should match open parenthesis
#1551: FILE: drivers/char/tpm/xen-tpmfront_vtpm.c:443:
+	if (vtpms->current_response ||
+			0 != (vtpms->flags & DATAEX_FLAG_QUEUED_ONLY)) {

CHECK: spinlock_t definition without comment
#1666: FILE: drivers/char/tpm/xen-tpmfront_vtpm.h:9:
+	spinlock_t           req_list_lock;

CHECK: spinlock_t definition without comment
#1672: FILE: drivers/char/tpm/xen-tpmfront_vtpm.h:15:
+	spinlock_t           resp_list_lock;

total: 0 errors, 1 warnings, 15 checks, 1387 lines checked

/home/konrad/tpm has style problems, please review.


I like your description - and I think you should have it
in the git commit _and_ in a Documentation/*somewhere*

> This patch ports the xen vtpm frontend driver for linux
> from the linux-2.6.18-xen.hg tree to linux-stable. This
> driver is designed be used with the mini-os tpmback driver
> in Xen as part of the new mini-os virtual tpm subsystem.
> 
> Included in this commit message is the first draft of the
> vtpm documentation.  See docs/misc/vtpm.txt for an updated
> version. Contact the xen-devel@lists.xen.org mailing list
> for details.
> 
> Copyright (c) 2010-2012 United States Government, as represented by
> the Secretary of Defense.  All rights reserved.
> November 12 2012
> Authors: Matthew Fioravante (JHUAPL),
> 
> This document describes the virtual Trusted Platform Module (vTPM)
> subsystem
> for Xen. The reader is assumed to have familiarity with building and
> installing
> Xen, Linux, and a basic understanding of the TPM and vTPM concepts.
> 
> ------------------------------
> INTRODUCTION
> ------------------------------
> The goal of this work is to provide a TPM functionality to a virtual
> guest operating system (a DomU).  This allows programs to interact
> with a TPM in a virtual system the same way they interact with a TPM
> on the physical system.  Each guest gets its own unique, emulated,
> software TPM.  However, each of the vTPM's secrets (Keys, NVRAM, etc)
> are managed by a vTPM Manager domain, which seals the secrets to
> the Physical TPM.  Thus, the vTPM subsystem extends the chain of
> trust rooted in the hardware TPM to virtual machines in Xen.
> Each major component of vTPM is implemented as a separate domain,
> providing secure separation guaranteed by the hypervisor. The
> vTPM domains are implemented in mini-os to reduce memory and
> processor overhead.
> 
> This mini-os vTPM subsystem was built on top of the previous vTPM
> work done by IBM and Intel corporation.
> 
> ------------------------------
> DESIGN OVERVIEW
> ------------------------------
> 
> The architecture of vTPM is described below:
> 
> +------------------+
> |    Linux DomU    | ...
> |       |  ^       |
> |       v  |       |
> |   xen-tpmfront   |
> +------------------+
>         |  ^
>         v  |
> +------------------+
> | mini-os/tpmback  |
> |       |  ^       |
> |       v  |       |
> |  vtpm-stubdom    | ...
> |       |  ^       |
> |       v  |       |
> | mini-os/tpmfront |
> +------------------+
>         |  ^
>         v  |
> +------------------+
> | mini-os/tpmback  |
> |       |  ^       |
> |       v  |       |
> |   vtpmmgrdom     |
> |       |  ^       |
> |       v  |       |
> | mini-os/tpm_tis  |
> +------------------+
>         |  ^
>         v  |
> +------------------+
> |   Hardware TPM   |
> +------------------+
>  * Linux DomU: The Linux based guest that wants to use a vTPM. There
>                may be more than one of these.
> 
>  * xen-tpmfront.ko: Linux kernel virtual TPM frontend driver. This
>                     driver provides vTPM access to a para-virtualized
>                     Linux based DomU.
> 
>  * mini-os/tpmback: Mini-os TPM backend driver. The Linux frontend
>                     driver connects to this backend driver to facilitate
>                     communications between the Linux DomU and its vTPM.
>                     This driver is also used by vtpmmgrdom to communicate
>                     with vtpm-stubdom.
> 
>  * vtpm-stubdom: A mini-os stub domain that implements a vTPM. There is
>                  a one to one mapping between running vtpm-stubdom
>                  instances and logical vtpms on the system. The vTPM
>                  Platform Configuration Registers (PCRs) are all
> 		 initialized to zero.
> 
>  * mini-os/tpmfront: Mini-os TPM frontend driver. The vTPM mini-os
>                      domain vtpm-stubdom uses this driver to
>                      communicate with vtpmmgrdom. This driver could
>                      also be used separately to implement a mini-os
>                      domain that wishes to use a vTPM of
>                      its own.
> 
>  * vtpmmgrdom: A mini-os domain that implements the vTPM manager.
>                There is only one vTPM manager and it should be running
>                during the entire lifetime of the machine.  This domain
>                regulates access to the physical TPM on the system and
>                secures the persistent state of each vTPM.
> 
>  * mini-os/tpm_tis: Mini-os TPM version 1.2 TPM Interface Specification
>                     (TIS) driver. This driver used by vtpmmgrdom to talk
>                     directly to the hardware TPM. Communication is
>                     facilitated by mapping hardware memory pages into
>                     vtpmmgrdom.
> 
>  * Hardware TPM: The physical TPM that is soldered onto the motherboard.
> 
> ------------------------------
> INSTALLATION
> ------------------------------
> 
> Prerequisites:
> --------------
> You must have an x86 machine with a TPM on the motherboard.
> The only software requirement to compiling vTPM is cmake.
> You must use libxl to manage domains with vTPMs. 'xm' is
> deprecated and does not support vTPM.
> 
> Compiling the XEN tree:
> -----------------------
> 
> Compile and install the XEN tree as usual. Be sure to build and install
> the stubdom tree.
> 
> Compiling the LINUX dom0 kernel:
> --------------------------------
> 
> The Linux dom0 kernel has no special prerequisites.
> 
> Compiling the LINUX domU kernel:
> --------------------------------
> 
> The domU kernel used by domains with vtpms must
> include the xen-tpmfront.ko driver. It can be built
> directly into the kernel or as a module.
> 
> CONFIG_TCG_TPM=y
> CONFIG_TCG_XEN=y
> 
> ------------------------------
> VTPM MANAGER SETUP
> ------------------------------
> 
> Manager disk image setup:
> -------------------------
> 
> The vTPM Manager requires a disk image to store its
> encrypted data. The image does not require a filesystem
> and can live anywhere on the host disk. The image does not need
> to be large. 8 to 16 Mb should be sufficient.
> 
> Manager config file:
> --------------------
> 
> The vTPM Manager domain (vtpmmgrdom) must be started like
> any other Xen virtual machine and requires a config file.
> The manager requires a disk image for storage and permission
> to access the hardware memory pages for the TPM. An
> example configuration looks like the following.
> 
> kernel="/usr/lib/xen/boot/vtpmmgrdom.gz"
> memory=16
> disk=["file:/var/vtpmmgrdom.img,hda,w"]
> name="vtpmmgrdom"
> iomem=["fed40,5"]
> 
> The iomem line tells xl to allow access to the TPM
> IO memory pages, which are 5 pages that start at
> 0xfed40000.
> 
> Starting and stopping the manager:
> ----------------------------------
> 
> The vTPM manager should be started at boot, you may wish to
> create an init script to do this.
> 
> Once initialization is complete you should see the following:
> INFO[VTPM]: Waiting for commands from vTPM's:
> 
> To shutdown the manager you must destroy it. To avoid data corruption,
> only destroy the manager when you see the above "Waiting for commands"
> message. This ensures the disk is in a consistent state.
> 
> ------------------------------
> VTPM AND LINUX PVM SETUP
> ------------------------------
> 
> In the following examples we will assume we have Linux
> guest named "domu" with its associated configuration
> located at /home/user/domu. It's vtpm will be named
> domu-vtpm.
> 
> vTPM disk image setup:
> ----------------------
> 
> The vTPM requires a disk image to store its persistent
> data. The image does not require a filesystem. The image
> does not need to be large. 8 Mb should be sufficient.
> 
> vTPM config file:
> -----------------
> 
> The vTPM domain requires a configuration file like
> any other domain. The vTPM requires a disk image for
> storage and a TPM frontend driver to communicate
> with the manager. An example configuration is given:
> 
> kernel="/usr/lib/xen/boot/vtpm-stubdom.gz"
> memory=8
> disk=["file:/home/user/domu/vtpm.img,hda,w"]
> name="domu-vtpm"
> vtpm=["backend=vtpmmgrdom,uuid=ac0a5b9e-cbe2-4c07-b43b-1d69e46fb839"]
> 
> The vtpm= line sets up the tpm frontend driver. The backend must set
> to vtpmmgrdom. You are required to generate a uuid for this vtpm.
> You can use the uuidgen unix program or some other method to create a
> uuid. The uuid uniquely identifies this vtpm to manager.
> 
> If you wish to clear the vTPM data you can either recreate the
> disk image or change the uuid.
> 
> Linux Guest config file:
> ------------------------
> 
> The Linux guest config file needs to be modified to include
> the Linux tpmfront driver. Add the following line:
> 
> vtpm=["backend=domu-vtpm"]
> 
> Currently only paravirtualized guests are supported.
> 
> Launching and shut down:
> ------------------------
> 
> To launch a Linux guest with a vTPM we first have to start the vTPM
> domain.
> 
> After initialization is complete, you should see the following:
> Info: Waiting for frontend domain to connect..
> 
> Next, launch the Linux guest
> 
> If xen-tpmfront was compiled as a module, be sure to load it
> in the guest.
> 
> After the Linux domain boots and the xen-tpmfront driver is loaded,
> you should see the following on the vtpm console:
> 
> Info: VTPM attached to Frontend X/Y
> 
> If you have trousers and tpm_tools installed on the guest, you can test
> the vtpm.
> 
> On guest:
> 
> The version command should return the following:
>   TPM 1.2 Version Info:
>   Chip Version:        1.2.0.7
>   Spec Level:          2
>   Errata Revision:     1
>   TPM Vendor ID:       ETHZ
>   TPM Version:         01010000
>   Manufacturer Info:   4554485a
> 
> You should also see the command being sent to the vtpm console as well
> as the vtpm saving its state. You should see the vtpm key being
> encrypted and stored on the vtpmmgrdom console.
> 
> To shutdown the guest and its vtpm, you just have to shutdown the guest
> normally. As soon as the guest vm disconnects, the vtpm will shut itself
> down automatically.
> 
> On guest:
> 
> You may wish to write a script to start your vtpm and guest together.
> 
> ------------------------------
> MORE INFORMATION
> ------------------------------
> 
> See stubdom/vtpmmgr/README for more details about how
> the manager domain works, how to use it, and its command line
> parameters.
> 
> See stubdom/vtpm/README for more specifics about how vtpm-stubdom
> operates and the command line options it accepts.
> 
> Signed-off-by: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
> ---
>  drivers/char/tpm/Kconfig             |   11 +
>  drivers/char/tpm/Makefile            |    2 +
>  drivers/char/tpm/tpm.h               |   10 +
>  drivers/char/tpm/xen-tpmfront_if.c   |  688 ++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/xen-tpmfront_vtpm.c |  543 +++++++++++++++++++++++++++
>  drivers/char/tpm/xen-tpmfront_vtpm.h |   55 +++
>  include/xen/interface/io/tpmif.h     |   65 ++++
>  7 files changed, 1374 insertions(+)
>  create mode 100644 drivers/char/tpm/xen-tpmfront_if.c
>  create mode 100644 drivers/char/tpm/xen-tpmfront_vtpm.c
>  create mode 100644 drivers/char/tpm/xen-tpmfront_vtpm.h
>  create mode 100644 include/xen/interface/io/tpmif.h
> 
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index 915875e..23d272f 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -81,4 +81,15 @@ config TCG_IBMVTPM
>  	  will be accessible from within Linux.  To compile this driver
>  	  as a module, choose M here; the module will be called tpm_ibmvtpm.
>  
> +config TCG_XEN
> +	tristate "XEN TPM Interface"
> +	depends on TCG_TPM && XEN
> +	---help---
> +	  If you want to make TPM support available to a Xen user domain,
> +	  say Yes and it will be accessible from within Linux. See
> +	  the manpages for xl, xl.conf, and docs/misc/vtpm.txt in
> +	  the Xen source repository for more details.
> +	  To compile this driver as a module, choose M here; the module
> +	  will be called xen-tpmfront.
> +
>  endif # TCG_TPM
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index 5b3fc8b..0161f05 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -17,3 +17,5 @@ obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
>  obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
>  obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
>  obj-$(CONFIG_TCG_IBMVTPM) += tpm_ibmvtpm.o
> +obj-$(CONFIG_TCG_XEN) += xen-tpmfront.o
> +xen-tpmfront-y = xen-tpmfront_if.o xen-tpmfront_vtpm.o
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 8ef7649..b575892 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -328,6 +328,16 @@ extern int tpm_pm_resume(struct device *);
>  extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
>  			     wait_queue_head_t *);
>  
> +static inline void *chip_get_private(const struct tpm_chip *chip)
> +{
> +	return chip->vendor.data;
> +}
> +
> +static inline void chip_set_private(struct tpm_chip *chip, void *priv)
> +{
> +	chip->vendor.data = priv;
> +}
> +
>  #ifdef CONFIG_ACPI
>  extern int tpm_add_ppi(struct kobject *);
>  extern void tpm_remove_ppi(struct kobject *);
> diff --git a/drivers/char/tpm/xen-tpmfront_if.c b/drivers/char/tpm/xen-tpmfront_if.c
> new file mode 100644
> index 0000000..ba7fad8
> --- /dev/null
> +++ b/drivers/char/tpm/xen-tpmfront_if.c
> @@ -0,0 +1,688 @@
> +/*
> + * Copyright (c) 2005, IBM Corporation
> + *
> + * Author: Stefan Berger, stefanb@us.ibm.com
> + * Grant table support: Mahadevan Gomathisankaran
> + *
> + * This code has been derived from drivers/xen/netfront/netfront.c
> + *
> + * Copyright (c) 2002-2004, K A Fraser
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation; or, when distributed
> + * separately from the Linux kernel or incorporated into other
> + * software packages, subject to the following license:
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this source file (the "Software"), to deal in the Software without
> + * restriction, including without limitation the rights to use, copy, modify,
> + * merge, publish, distribute, sublicense, and/or sell copies of the Software,
> + * and to permit persons to whom the Software is furnished to do so, subject to
> + * the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
> + * IN THE SOFTWARE.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/mutex.h>
> +#include <linux/uaccess.h>
> +#include <xen/events.h>
> +#include <xen/interface/grant_table.h>
> +#include <xen/interface/io/tpmif.h>
> +#include <xen/grant_table.h>
> +#include <xen/xenbus.h>
> +#include <xen/page.h>
> +#include "tpm.h"
> +#include "xen-tpmfront_vtpm.h"
> +
> +#define GRANT_INVALID_REF 0
> +
> +/* local structures */
> +struct tpm_private {
> +	struct tpm_chip *chip;
> +
> +	struct tpmif_tx_interface *tx;
> +	atomic_t refcnt;
> +	unsigned int evtchn;
> +	u8 is_connected;
> +	u8 is_suspended;

Perhaps those two could be 'bool'?
> +
> +	spinlock_t tx_lock;
> +
> +	struct tx_buffer *tx_buffers[TPMIF_TX_RING_SIZE];
> +
> +	atomic_t tx_busy;
> +	void *tx_remember;
> +
> +	domid_t backend_id;
> +	wait_queue_head_t wait_q;
> +
> +	struct xenbus_device *dev;
> +	int ring_ref;
> +};
> +
> +struct tx_buffer {
> +	unsigned int size;	/* available space in data */
> +	unsigned int len;	/* used space in data */
> +	unsigned char *data;	/* pointer to a page */
> +};
> +
> +
> +/* locally visible variables */
> +static grant_ref_t gref_head;
> +static struct tpm_private *my_priv;

Should 'my_priv' have a lock?

> +
> +/* local function prototypes */
> +static irqreturn_t tpmif_int(int irq,
> +		void *tpm_priv);
> +static void tpmif_rx_action(unsigned long unused);
> +static int tpmif_connect(struct xenbus_device *dev,
> +		struct tpm_private *tp,
> +		domid_t domid);
> +static DECLARE_TASKLET(tpmif_rx_tasklet, tpmif_rx_action, 0);

Why make it a tasklet and not a thread? That way you can also
remove the usage of ATOMIC and use the GFP_KERNEL.

> +static int tpmif_allocate_tx_buffers(struct tpm_private *tp);
> +static void tpmif_free_tx_buffers(struct tpm_private *tp);
> +static void tpmif_set_connected_state(struct tpm_private *tp,
> +		u8 newstate);
> +static int tpm_xmit(struct tpm_private *tp,
> +		const u8 *buf, size_t count, int userbuffer,
> +		void *remember);
> +static void destroy_tpmring(struct tpm_private *tp);
> +
> +static inline int
> +tx_buffer_copy(struct tx_buffer *txb, const u8 *src, int len,
> +		int isuserbuffer)
> +{
> +	int copied = len;
> +
> +	if (len > txb->size)
> +		copied = txb->size;

 'len' is an 'int' and 'txb->size' is an 'unsigned int'.
If 'len' is -1, this comparison would end up becoming
UINT_MAX + 1 + -1  > txb->size - which would always be
true (I think - I can't recall if the compiler would
cast 'int' to an 'unsigned int' or the other way).
And then we would copy txb->size instead of 0.
Depending on the 'src' this might blow up.

Perhaps a check if len is less than or equal zero? Or
maybe not using 'int' for the 'len'?


> +	if (isuserbuffer) {
> +		if (copy_from_user(txb->data, src, copied))
> +			return -EFAULT;
> +	} else {
> +		memcpy(txb->data, src, copied);
> +	}
> +	txb->len = len;
> +	return copied;

I think just making it 'unsigned int' would be easier.

> +}
> +
> +static inline struct tx_buffer *tx_buffer_alloc(void)
> +{
> +	struct tx_buffer *txb;
> +
> +	txb = kzalloc(sizeof(struct tx_buffer), GFP_KERNEL);
> +	if (!txb)
> +		return NULL;
> +
> +	txb->len = 0;
> +	txb->size = PAGE_SIZE;
> +	txb->data = (unsigned char *)__get_free_page(GFP_KERNEL);
> +	if (txb->data == NULL) {
> +		kfree(txb);
> +		txb = NULL;
> +	}
> +
> +	return txb;
> +}
> +
> +
> +static inline void tx_buffer_free(struct tx_buffer *txb)
> +{
> +	if (txb) {
> +		free_page((long)txb->data);
> +		kfree(txb);
> +	}
> +}
> +
> +/**************************************************************
> +  Utility function for the tpm_private structure
> + **************************************************************/
> +static void tpm_private_init(struct tpm_private *tp)
> +{
> +	spin_lock_init(&tp->tx_lock);
> +	init_waitqueue_head(&tp->wait_q);
> +	atomic_set(&tp->refcnt, 1);
> +}
> +
> +static void tpm_private_put(void)
> +{
> +	if (!atomic_dec_and_test(&my_priv->refcnt))
> +		return;

So no lock - so what happens if you have _two_ threads
calling this? The first decrements the refcnt, and decides
its time to clear it up - goes through the kfree and sets
my_priv == NULL. At the same instant the other thread goes
in and calls 'atomic_dec_and_test' on the my_priv which
has been set to NULL. Boom!

Unless there is some lock being held _before_ tpm_private_put
is called - in which you should a comment about it.
> +
> +	tpmif_free_tx_buffers(my_priv);
> +	kfree(my_priv);
> +	my_priv = NULL;
> +}
> +
> +static struct tpm_private *tpm_private_get(void)
> +{
> +	int err;
> +
> +	if (my_priv) {
> +		atomic_inc(&my_priv->refcnt);
> +		return my_priv;
> +	}
> +
> +	my_priv = kzalloc(sizeof(struct tpm_private), GFP_KERNEL);
> +	if (!my_priv)
> +		return NULL;
> +
> +	tpm_private_init(my_priv);
> +	err = tpmif_allocate_tx_buffers(my_priv);
> +	if (err < 0)
> +		tpm_private_put();
> +
> +	return my_priv;
> +}
> +
> +/**************************************************************
> +
> +  The interface to let the tpm plugin register its callback
> +  function and send data to another partition using this module
> +
> + **************************************************************/
> +
> +static DEFINE_MUTEX(suspend_lock);
> +/*
> + * Send data via this module by calling this function
> + */
> +int vtpm_vd_send(struct tpm_private *tp,

I think this can be static?

> +		const u8 *buf, size_t count, void *ptr)
> +{
> +	int sent;
> +
> +	mutex_lock(&suspend_lock);
> +	sent = tpm_xmit(tp, buf, count, 0, ptr);
> +	mutex_unlock(&suspend_lock);
> +
> +	return sent;
> +}
> +
> +/**************************************************************
> +  XENBUS support code
> + **************************************************************/
> +
> +static int setup_tpmring(struct xenbus_device *dev,
> +		struct tpm_private *tp)
> +{
> +	struct tpmif_tx_interface *sring;
> +	int err;
> +
> +	tp->ring_ref = GRANT_INVALID_REF;
> +
> +	sring = (void *)__get_free_page(GFP_KERNEL);
> +	if (!sring) {
> +		xenbus_dev_fatal(dev, -ENOMEM, "allocating shared ring");
> +		return -ENOMEM;
> +	}
> +	tp->tx = sring;
> +
> +	err = xenbus_grant_ring(dev, virt_to_mfn(tp->tx));
> +	if (err < 0) {
> +		free_page((unsigned long)sring);
> +		tp->tx = NULL;
> +		xenbus_dev_fatal(dev, err, "allocating grant reference");
> +		goto fail;
> +	}
> +	tp->ring_ref = err;
> +
> +	err = tpmif_connect(dev, tp, dev->otherend_id);
> +	if (err)
> +		goto fail;
> +
> +	return 0;
> +fail:
> +	destroy_tpmring(tp);
> +	return err;
> +}
> +
> +
> +static void destroy_tpmring(struct tpm_private *tp)
> +{
> +	tpmif_set_connected_state(tp, 0);
> +
> +	if (tp->ring_ref != GRANT_INVALID_REF) {
> +		gnttab_end_foreign_access(tp->ring_ref,
> +				0, (unsigned long)tp->tx);
> +		tp->ring_ref = GRANT_INVALID_REF;
> +		tp->tx = NULL;

Shouldn't you free_page it first? Looking at the code below, if
it fails at:

	err = tpmif_connect(dev, tp, dev->otherend_id);

then we go to 'destroy_tpmring' which would tear down the
connection. But we still have tp->tx page allocated at
that point?

> +	}
> +
> +	if (tp->evtchn)
> +		unbind_from_irqhandler(irq_from_evtchn(tp->evtchn), tp);
> +
> +	tp->evtchn = GRANT_INVALID_REF;
> +}
> +
> +
> +static int talk_to_backend(struct xenbus_device *dev,
> +		struct tpm_private *tp)
> +{
> +	const char *message = NULL;
> +	int err;
> +	struct xenbus_transaction xbt;
> +
> +	err = setup_tpmring(dev, tp);
> +	if (err) {
> +		xenbus_dev_fatal(dev, err, "setting up ring");
> +		goto out;
> +	}
> +
> +again:
> +	err = xenbus_transaction_start(&xbt);
> +	if (err) {
> +		xenbus_dev_fatal(dev, err, "starting transaction");
> +		goto destroy_tpmring;
> +	}
> +
> +	err = xenbus_printf(xbt, dev->nodename,
> +			"ring-ref", "%u", tp->ring_ref);
> +	if (err) {
> +		message = "writing ring-ref";
> +		goto abort_transaction;
> +	}
> +
> +	err = xenbus_printf(xbt, dev->nodename, "event-channel", "%u",
> +			tp->evtchn);
> +	if (err) {
> +		message = "writing event-channel";
> +		goto abort_transaction;
> +	}
> +
> +	err = xenbus_transaction_end(xbt, 0);
> +	if (err == -EAGAIN)
> +		goto again;
> +	if (err) {
> +		xenbus_dev_fatal(dev, err, "completing transaction");
> +		goto destroy_tpmring;
> +	}
> +
> +	xenbus_switch_state(dev, XenbusStateConnected);
> +
> +	return 0;
> +
> +abort_transaction:
> +	xenbus_transaction_end(xbt, 1);
> +	if (message)
> +		xenbus_dev_error(dev, err, "%s", message);
> +destroy_tpmring:
> +	destroy_tpmring(tp);
> +out:
> +	return err;
> +}
> +
> +/**
> + * Callback received when the backend's state changes.
> + */
> +static void backend_changed(struct xenbus_device *dev,
> +		enum xenbus_state backend_state)
> +{
> +	struct tpm_private *tp = tpm_private_from_dev(&dev->dev);
> +
> +	switch (backend_state) {
> +	case XenbusStateInitialising:
> +	case XenbusStateInitWait:
> +	case XenbusStateInitialised:
> +	case XenbusStateReconfiguring:
> +	case XenbusStateReconfigured:
> +	case XenbusStateUnknown:
> +		break;
> +
> +	case XenbusStateConnected:
> +		tpmif_set_connected_state(tp, 1);

Can that '1' be a true or false?

> +		break;
> +
> +	case XenbusStateClosing:
> +		tpmif_set_connected_state(tp, 0);

The same here.
> +		xenbus_frontend_closed(dev);
> +		break;
> +
> +	case XenbusStateClosed:
> +		tpmif_set_connected_state(tp, 0);

And here.
> +		if (tp->is_suspended == 0)
> +			device_unregister(&dev->dev);
> +		xenbus_frontend_closed(dev);
> +		break;
> +	}
> +}
> +
> +static int tpmfront_probe(struct xenbus_device *dev,
> +		const struct xenbus_device_id *id)
> +{
> +	int err;
> +	int handle;
> +	struct tpm_private *tp = tpm_private_get();
> +
> +	if (!tp)
> +		return -ENOMEM;
> +
> +	tp->chip = init_vtpm(&dev->dev, tp);
> +	if (IS_ERR(tp->chip))
> +		return PTR_ERR(tp->chip);
> +
> +	err = xenbus_scanf(XBT_NIL, dev->nodename,
> +			"handle", "%i", &handle);

Not '%li' ? Ah I guess not since it is 'int'. But why not
'long' ? (Xen netback looks to be using 'long').

> +	if (XENBUS_EXIST_ERR(err))
> +		return err;
> +
> +	if (err < 0) {
> +		xenbus_dev_fatal(dev, err, "reading virtual-device");
> +		return err;
> +	}
> +
> +	tp->dev = dev;
> +
> +	err = talk_to_backend(dev, tp);
> +	if (err) {
> +		tpm_private_put();
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +static int __devexit tpmfront_remove(struct xenbus_device *dev)
> +{
> +	struct tpm_private *tp = tpm_private_from_dev(&dev->dev);
> +	destroy_tpmring(tp);
> +	cleanup_vtpm(&dev->dev);
> +	return 0;
> +}
> +
> +static int tpmfront_suspend(struct xenbus_device *dev)
> +{
> +	struct tpm_private *tp = tpm_private_from_dev(&dev->dev);
> +	u32 ctr;
> +
> +	/* Take the lock, preventing any application from sending. */
> +	mutex_lock(&suspend_lock);
> +	tp->is_suspended = 1;

bool?

> +
> +	for (ctr = 0; atomic_read(&tp->tx_busy); ctr++) {
> +		/* Wait for a request to be responded to. */
> +		interruptible_sleep_on_timeout(&tp->wait_q, 100);

So if the request never comes back (b/c the backend crashed), then
what should we do?

> +	}
> +

Why no 'mutex_unlock' 

> +	return 0;
> +}
> +
> +static int tpmfront_suspend_finish(struct tpm_private *tp)
> +{

No mutex_lock ?

> +	tp->is_suspended = 0;
> +	/* Allow applications to send again. */

So you are holding on the mutex across the different backend
states? Can you explain when this function gets called as a result
of tpmfront_suspend?

> +	mutex_unlock(&suspend_lock);
> +	return 0;
> +}
> +
> +static int tpmfront_resume(struct xenbus_device *dev)
> +{
> +	struct tpm_private *tp = tpm_private_from_dev(&dev->dev);
> +	destroy_tpmring(tp);
> +	return talk_to_backend(dev, tp);
> +}
> +
> +static int tpmif_connect(struct xenbus_device *dev,
> +		struct tpm_private *tp,
> +		domid_t domid)
> +{
> +	int err;
> +
> +	tp->backend_id = domid;
> +	tp->evtchn = GRANT_INVALID_REF;
> +
> +	err = xenbus_alloc_evtchn(dev, &tp->evtchn);
> +	if (err)
> +		return err;
> +
> +	err = bind_evtchn_to_irqhandler(tp->evtchn, tpmif_int,
> +			0, "tpmif", tp);
> +	if (err <= 0)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static const struct xenbus_device_id tpmfront_ids[] = {
> +	{ "vtpm" },

Hm, I thought it would be 'vtpm2'?

> +	{ "" }
> +};
> +MODULE_ALIAS("xen:vtpm");
> +
> +static DEFINE_XENBUS_DRIVER(tpmfront, ,
> +		.probe = tpmfront_probe,
> +		.remove =  __devexit_p(tpmfront_remove),
> +		.resume = tpmfront_resume,
> +		.otherend_changed = backend_changed,
> +		.suspend = tpmfront_suspend,
> +		);
> +
> +static int tpmif_allocate_tx_buffers(struct tpm_private *tp)

> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < TPMIF_TX_RING_SIZE; i++) {
> +		tp->tx_buffers[i] = tx_buffer_alloc();
> +		if (!tp->tx_buffers[i]) {
> +			tpmif_free_tx_buffers(tp);
> +			return -ENOMEM;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void tpmif_free_tx_buffers(struct tpm_private *tp)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < TPMIF_TX_RING_SIZE; i++)
> +		tx_buffer_free(tp->tx_buffers[i]);
> +}
> +
> +static void tpmif_rx_action(unsigned long priv)
> +{
> +	struct tpm_private *tp = (struct tpm_private *)priv;
> +	int i = 0;
> +	unsigned int received;
> +	unsigned int offset = 0;
> +	u8 *buffer;
> +	struct tpmif_tx_request *tx = &tp->tx->ring[i].req;
> +
> +	atomic_set(&tp->tx_busy, 0);
> +	wake_up_interruptible(&tp->wait_q);
> +
> +	received = tx->size;

No check if the size is out of whack? Say bigger than a PAGE_SIZE?
The ring could have been corrupted.

> +
> +	buffer = kmalloc(received, GFP_ATOMIC);

No 'kzalloc' ?

> +	if (!buffer)
> +		return;
> +
> +	for (i = 0; i < TPMIF_TX_RING_SIZE && offset < received; i++) {
> +		struct tx_buffer *txb = tp->tx_buffers[i];
> +		struct tpmif_tx_request *tx;
> +		unsigned int tocopy;
> +
> +		tx = &tp->tx->ring[i].req;
> +		tocopy = tx->size;

So.. on the first loop you get the tx->size from the same place as
what 'received' got. But on the second loop, the tx->size is from another
request. What if the first tx->size was 8 bytes, the next request
had 8 as well. Wouldn't we end up crashing as buffer was only allocated
to hold 8 bytes?

> +		if (tocopy > PAGE_SIZE)
> +			tocopy = PAGE_SIZE;
> +
> +		memcpy(&buffer[offset], txb->data, tocopy);
> +
> +		gnttab_release_grant_reference(&gref_head, tx->ref);
> +
> +		offset += tocopy;
> +	}
> +
> +	vtpm_vd_recv(tp->chip, buffer, received, tp->tx_remember);
> +	kfree(buffer);
> +}
> +
> +
> +static irqreturn_t tpmif_int(int irq, void *tpm_priv)
> +{
> +	struct tpm_private *tp = tpm_priv;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tp->tx_lock, flags);
> +	tpmif_rx_tasklet.data = (unsigned long)tp;
> +	tasklet_schedule(&tpmif_rx_tasklet);
> +	spin_unlock_irqrestore(&tp->tx_lock, flags);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +
> +static int tpm_xmit(struct tpm_private *tp,
> +		const u8 *buf, size_t count, int isuserbuffer,
> +		void *remember)
> +{
> +	struct tpmif_tx_request *tx;
> +	int i;
> +	unsigned int offset = 0;
> +
> +	spin_lock_irq(&tp->tx_lock);
> +
> +	if (unlikely(atomic_read(&tp->tx_busy))) {
> +		spin_unlock_irq(&tp->tx_lock);
> +		return -EBUSY;
> +	}
> +
> +	if (tp->is_connected != 1) {

Use a bool here.
> +		spin_unlock_irq(&tp->tx_lock);
> +		return -EIO;
> +	}
> +
> +	for (i = 0; count > 0 && i < TPMIF_TX_RING_SIZE; i++) {
> +		struct tx_buffer *txb = tp->tx_buffers[i];
> +		int copied;
> +
> +		if (!txb) {
> +			spin_unlock_irq(&tp->tx_lock);
> +			return -EFAULT;
> +		}
> +
> +		copied = tx_buffer_copy(txb, &buf[offset], count,
> +				isuserbuffer);
> +		if (copied < 0) {
> +			/* An error occurred */
> +			spin_unlock_irq(&tp->tx_lock);
> +			return copied;
> +		}
> +		count -= copied;
> +		offset += copied;
> +
> +		tx = &tp->tx->ring[i].req;
> +		tx->addr = virt_to_machine(txb->data).maddr;
> +		tx->size = txb->len;
> +		tx->unused = 0;
> +
> +		/* Get the granttable reference for this page. */
> +		tx->ref = gnttab_claim_grant_reference(&gref_head);
> +		if (tx->ref == -ENOSPC) {
> +			spin_unlock_irq(&tp->tx_lock);
> +			return -ENOSPC;
> +		}
> +		gnttab_grant_foreign_access_ref(tx->ref,
> +				tp->backend_id,
> +				virt_to_mfn(txb->data),
> +				0 /*RW*/);
> +		wmb();
> +	}
> +
> +	atomic_set(&tp->tx_busy, 1);
> +	tp->tx_remember = remember;
> +
> +	mb();
> +
> +	notify_remote_via_evtchn(tp->evtchn);
> +
> +	spin_unlock_irq(&tp->tx_lock);
> +	return offset;
> +}
> +
> +
> +static void tpmif_notify_upperlayer(struct tpm_private *tp)
> +{
> +	/* Notify upper layer about the state of the connection to the BE. */
> +	vtpm_vd_status(tp->chip, (tp->is_connected
> +				? TPM_VD_STATUS_CONNECTED
> +				: TPM_VD_STATUS_DISCONNECTED));
> +}
> +
> +
> +static void tpmif_set_connected_state(struct tpm_private *tp, u8 is_connected)
> +{
> +	/*
> +	 * Don't notify upper layer if we are in suspend mode and
> +	 * should disconnect - assumption is that we will resume
> +	 * The mutex keeps apps from sending.
> +	 */
> +	if (is_connected == 0 && tp->is_suspended == 1)

Bool's.

> +		return;
> +
> +	/*
> +	 * Unlock the mutex if we are connected again
> +	 * after being suspended - now resuming.
> +	 * This also removes the suspend state.
> +	 */
> +	if (is_connected == 1 && tp->is_suspended == 1)
> +		tpmfront_suspend_finish(tp);
> +
> +	if (is_connected != tp->is_connected) {
> +		tp->is_connected = is_connected;
> +		tpmif_notify_upperlayer(tp);
> +	}
> +}
> +
> +
> +
> +/* =================================================================
> + * Initialization function.
> + * =================================================================
> + */
> +
> +
> +static int __init tpmif_init(void)
> +{
> +	struct tpm_private *tp;
> +
> +	if (!xen_domain())
> +		return -ENODEV;

So this can run in HVM, PV, and dom0. You tested it in all of
the cases?

> +
> +	tp = tpm_private_get();
> +	if (!tp)
> +		return -ENOMEM;
> +
> +	if (gnttab_alloc_grant_references(TPMIF_TX_RING_SIZE,
> +				&gref_head) < 0) {
> +		tpm_private_put();
> +		return -EFAULT;
> +	}
> +
> +	return xenbus_register_frontend(&tpmfront_driver);
> +}
> +module_init(tpmif_init);
> +
> +static void __exit tpmif_exit(void)
> +{
> +	xenbus_unregister_driver(&tpmfront_driver);
> +	gnttab_free_grant_references(gref_head);
> +	tpm_private_put();
> +}
> +module_exit(tpmif_exit);
> +
> +MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/char/tpm/xen-tpmfront_vtpm.c b/drivers/char/tpm/xen-tpmfront_vtpm.c
> new file mode 100644
> index 0000000..d70f1df
> --- /dev/null
> +++ b/drivers/char/tpm/xen-tpmfront_vtpm.c
> @@ -0,0 +1,543 @@
> +/*
> + * Copyright (C) 2006 IBM Corporation
> + *
> + * Authors:
> + * Stefan Berger <stefanb@us.ibm.com>
> + *
> + * Generic device driver part for device drivers in a virtualized
> + * environment.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + *
> + */
> +
> +#include <linux/uaccess.h>
> +#include <linux/list.h>
> +#include <linux/device.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include "tpm.h"
> +#include "xen-tpmfront_vtpm.h"
> +
> +/* read status bits */
> +enum {
> +	STATUS_BUSY = 0x01,
> +	STATUS_DATA_AVAIL = 0x02,
> +	STATUS_READY = 0x04
> +};

And for what variable is this used? Is this
related to the 'struct transmission' ?

> +
> +struct transmission {
> +	struct list_head next;
> +
> +	unsigned char *request;
> +	size_t  request_len;
> +	size_t  request_buflen;
> +
> +	unsigned char *response;
> +	size_t  response_len;
> +	size_t  response_buflen;
> +
> +	unsigned int flags;

I presume this is for the DATEEX_FLAG_QUEUED_ONLY ?
> +};
> +
> +enum {
> +	TRANSMISSION_FLAG_WAS_QUEUED = 0x1

Hmm, for which variable is this?

> +};
> +
> +
> +enum {
> +	DATAEX_FLAG_QUEUED_ONLY = 0x1

You should have one for the default entry of '0' as well.
> +};
> +
> +
> +/* local variables */
> +
> +/* local function prototypes */
> +static int _vtpm_send_queued(struct tpm_chip *chip);
> +
> +
> +/* =============================================================
> + * Some utility functions
> + * =============================================================
> + */
> +static void vtpm_state_init(struct vtpm_state *vtpms)
> +{
> +	vtpms->current_request = NULL;
> +	spin_lock_init(&vtpms->req_list_lock);
> +	init_waitqueue_head(&vtpms->req_wait_queue);
> +	INIT_LIST_HEAD(&vtpms->queued_requests);
> +
> +	vtpms->current_response = NULL;
> +	spin_lock_init(&vtpms->resp_list_lock);
> +	init_waitqueue_head(&vtpms->resp_wait_queue);
> +
> +	vtpms->disconnect_time = jiffies;
> +}
> +
> +
> +static inline struct transmission *transmission_alloc(void)
> +{
> +	return kzalloc(sizeof(struct transmission), GFP_ATOMIC);

GFP_ATOMIC? Not GFP_KERNEL? Ah, that is b/c you are using a tasklet.
Why not use a thread?

> +}
> +
> +static unsigned char *
> +transmission_set_req_buffer(struct transmission *t,
> +		unsigned char *buffer, size_t len)
> +{
> +	if (t->request_buflen < len) {
> +		kfree(t->request);
> +		t->request = kmalloc(len, GFP_KERNEL);
> +		if (!t->request) {
> +			t->request_buflen = 0;
> +			return NULL;
> +		}
> +		t->request_buflen = len;
> +	}
> +
> +	memcpy(t->request, buffer, len);
> +	t->request_len = len;
> +
> +	return t->request;
> +}
> +
> +static unsigned char *
> +transmission_set_res_buffer(struct transmission *t,
> +		const unsigned char *buffer, size_t len)
> +{
> +	if (t->response_buflen < len) {
> +		kfree(t->response);
> +		t->response = kmalloc(len, GFP_ATOMIC);
> +		if (!t->response) {
> +			t->response_buflen = 0;
> +			return NULL;
> +		}
> +		t->response_buflen = len;
> +	}
> +
> +	memcpy(t->response, buffer, len);
> +	t->response_len = len;
> +
> +	return t->response;
> +}

You could collapse these two functions, and in the
'struct transmission' have something like this:

struct payload {
	unsigned char* data;
	ssize_t	len;
	ssize_t buflen;
};

struct transmission {
	struct list_head next;
	struct payload request;
	struct payload response;
	...
}

And then just pass in 'struct payload' to one of those
functions.

> +static inline void transmission_free(struct transmission *t)
> +{
> +	kfree(t->request);
> +	kfree(t->response);
> +	kfree(t);
> +}
> +
> +/* =============================================================
> + * Interface with the lower layer driver
> + * =============================================================
> + */
> +/*
> + * Lower layer uses this function to make a response available.
> + */
> +int vtpm_vd_recv(const struct tpm_chip *chip,
> +		const unsigned char *buffer, size_t count,
> +		void *ptr)
> +{
> +	unsigned long flags;
> +	int ret_size = 0;
> +	struct transmission *t;
> +	struct vtpm_state *vtpms;
> +
> +	vtpms = (struct vtpm_state *)chip_get_private(chip);
> +
> +	/*
> +	 * The list with requests must contain one request
> +	 * only and the element there must be the one that
> +	 * was passed to me from the front-end.
> +	 */
> +	spin_lock_irqsave(&vtpms->resp_list_lock, flags);
> +	if (vtpms->current_request != ptr) {
> +		spin_unlock_irqrestore(&vtpms->resp_list_lock, flags);
> +		return 0;
> +	}
> +	t = vtpms->current_request;
> +	if (t) {
> +		transmission_free(t);
> +		vtpms->current_request = NULL;
> +	}
> +
> +	t = transmission_alloc();
> +	if (t) {
> +		if (!transmission_set_res_buffer(t, buffer, count)) {
> +			transmission_free(t);
> +			spin_unlock_irqrestore(&vtpms->resp_list_lock, flags);
> +			return -ENOMEM;
> +		}
> +		ret_size = count;
> +		vtpms->current_response = t;
> +		wake_up_interruptible(&vtpms->resp_wait_queue);
> +	}
> +	spin_unlock_irqrestore(&vtpms->resp_list_lock, flags);
> +
> +	return ret_size;
> +}
> +
> +
> +/*
> + * Lower layer indicates its status (connected/disconnected)
> + */
> +void vtpm_vd_status(const struct tpm_chip *chip, u8 vd_status)
> +{
> +	struct vtpm_state *vtpms;
> +
> +	vtpms = (struct vtpm_state *)chip_get_private(chip);
> +
> +	vtpms->vd_status = vd_status;
> +	if ((vtpms->vd_status & TPM_VD_STATUS_CONNECTED) == 0)
> +		vtpms->disconnect_time = jiffies;
> +}
> +
> +/* =============================================================
> + * Interface with the generic TPM driver
> + * =============================================================
> + */
> +static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
> +{
> +	int rc = 0;
> +	unsigned long flags;
> +	struct vtpm_state *vtpms;
> +
> +	vtpms = (struct vtpm_state *)chip_get_private(chip);
> +
> +	/*
> +	 * Check if the previous operation only queued the command
> +	 * In this case there won't be a response, so I just
> +	 * return from here and reset that flag. In any other
> +	 * case I should receive a response from the back-end.
> +	 */
> +	spin_lock_irqsave(&vtpms->resp_list_lock, flags);
> +	if ((vtpms->flags & DATAEX_FLAG_QUEUED_ONLY) != 0) {
> +		vtpms->flags &= ~DATAEX_FLAG_QUEUED_ONLY;
> +		spin_unlock_irqrestore(&vtpms->resp_list_lock, flags);
> +		/*
> +		 * The first few commands (measurements) must be
> +		 * queued since it might not be possible to talk to the
> +		 * TPM, yet.
> +		 * Return a response of up to 30 '0's.

Is 30 a magic constant? Can you use a #define.

> +		 */
> +
> +		count = min_t(size_t, count, 30);
> +		memset(buf, 0x0, count);
> +		return count;
> +	}
> +	/*
> +	 * Check whether something is in the responselist and if
> +	 * there's nothing in the list wait for something to appear.
> +	 */
> +
> +	if (!vtpms->current_response) {
> +		spin_unlock_irqrestore(&vtpms->resp_list_lock, flags);
> +		interruptible_sleep_on_timeout(&vtpms->resp_wait_queue,
> +				1000);
> +		spin_lock_irqsave(&vtpms->resp_list_lock, flags);
> +	}
> +
> +	if (vtpms->current_response) {
> +		struct transmission *t = vtpms->current_response;
> +		vtpms->current_response = NULL;
> +		rc = min(count, t->response_len);
> +		memcpy(buf, t->response, rc);
> +		transmission_free(t);
> +	}
> +
> +	spin_unlock_irqrestore(&vtpms->resp_list_lock, flags);
> +	return rc;
> +}
> +
> +static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
> +{
> +	int rc = 0;
> +	unsigned long flags;
> +	struct transmission *t = transmission_alloc();
> +	struct vtpm_state *vtpms;
> +
> +	vtpms = (struct vtpm_state *)chip_get_private(chip);
> +
> +	if (!t)
> +		return -ENOMEM;
> +	/*
> +	 * If there's a current request, it must be the
> +	 * previous request that has timed out.
> +	 */
> +	spin_lock_irqsave(&vtpms->req_list_lock, flags);
> +	if (vtpms->current_request != NULL) {
> +		dev_warn(chip->dev, "Sending although there is a request outstanding.\n"
> +				"         Previous request must have timed out.\n");
> +		transmission_free(vtpms->current_request);
> +		vtpms->current_request = NULL;
> +	}
> +	spin_unlock_irqrestore(&vtpms->req_list_lock, flags);
> +
> +	/*
> +	 * Queue the packet if the driver below is not
> +	 * ready, yet, or there is any packet already
> +	 * in the queue.
> +	 * If the driver below is ready, unqueue all
> +	 * packets first before sending our current
> +	 * packet.
> +	 * For each unqueued packet, except for the
> +	 * last (=current) packet, call the function
> +	 * tpm_xen_recv to wait for the response to come
> +	 * back.
> +	 */
> +	if ((vtpms->vd_status & TPM_VD_STATUS_CONNECTED) == 0) {
> +		if (time_after(jiffies,
> +					vtpms->disconnect_time + HZ * 10)) {
> +			rc = -ENOENT;
> +		} else {
> +			goto queue_it;
> +		}
> +	} else {
> +		/*
> +		 * Send all queued packets.
> +		 */
> +		if (_vtpm_send_queued(chip) == 0) {
> +
> +			vtpms->current_request = t;
> +
> +			rc = vtpm_vd_send(vtpms->tpm_private,
> +					buf,
> +					count,
> +					t);
> +			/*
> +			 * The generic TPM driver will call
> +			 * the function to receive the response.
> +			 */
> +			if (rc < 0) {
> +				vtpms->current_request = NULL;
> +				goto queue_it;
> +			}
> +		} else {
> +queue_it:
> +			if (!transmission_set_req_buffer(t, buf, count)) {
> +				transmission_free(t);
> +				rc = -ENOMEM;
> +				goto exit;
> +			}
> +			/*
> +			 * An error occurred. Don't event try
> +			 * to send the current request. Just
> +			 * queue it.
> +			 */
> +			spin_lock_irqsave(&vtpms->req_list_lock, flags);
> +			vtpms->flags |= DATAEX_FLAG_QUEUED_ONLY;
> +			list_add_tail(&t->next, &vtpms->queued_requests);
> +			spin_unlock_irqrestore(&vtpms->req_list_lock, flags);
> +		}
> +	}
> +
> +exit:
> +	return rc;
> +}
> +
> +
> +/*
> + * Send all queued requests.
> + */
> +static int _vtpm_send_queued(struct tpm_chip *chip)
> +{
> +	int rc;
> +	int error = 0;
> +	unsigned long flags;
> +	unsigned char buffer[1];
> +	struct vtpm_state *vtpms;
> +	vtpms = (struct vtpm_state *)chip_get_private(chip);
> +
> +	spin_lock_irqsave(&vtpms->req_list_lock, flags);
> +
> +	while (!list_empty(&vtpms->queued_requests)) {
> +		/*
> +		 * Need to dequeue them.
> +		 * Read the result into a dummy buffer.
> +		 */
> +		struct transmission *qt = (struct transmission *)
> +			vtpms->queued_requests.next;
> +		list_del(&qt->next);
> +		vtpms->current_request = qt;
> +		spin_unlock_irqrestore(&vtpms->req_list_lock, flags);
> +
> +		rc = vtpm_vd_send(vtpms->tpm_private,
> +				qt->request,
> +				qt->request_len,
> +				qt);
> +
> +		if (rc < 0) {
> +			spin_lock_irqsave(&vtpms->req_list_lock, flags);
> +			qt = vtpms->current_request;
> +			if (qt != NULL) {
> +				/*
> +				 * requeue it at the beginning
> +				 * of the list
> +				 */
> +				list_add(&qt->next,
> +						&vtpms->queued_requests);
> +			}
> +			vtpms->current_request = NULL;
> +			error = 1;
> +			break;
> +		}
> +		/*
> +		 * After this point qt is not valid anymore!
> +		 * It is freed when the front-end is delivering
> +		 * the data by calling tpm_recv
> +		 */
> +		/*
> +		 * Receive response into provided dummy buffer
> +		 */
> +		rc = vtpm_recv(chip, buffer, sizeof(buffer));
> +		spin_lock_irqsave(&vtpms->req_list_lock, flags);
> +	}
> +
> +	spin_unlock_irqrestore(&vtpms->req_list_lock, flags);
> +
> +	return error;
> +}
> +
> +static void vtpm_cancel(struct tpm_chip *chip)
> +{
> +	unsigned long flags;
> +	struct vtpm_state *vtpms = (struct vtpm_state *)chip_get_private(chip);
> +
> +	spin_lock_irqsave(&vtpms->resp_list_lock, flags);
> +
> +	if (!vtpms->current_response && vtpms->current_request) {
> +		spin_unlock_irqrestore(&vtpms->resp_list_lock, flags);
> +		interruptible_sleep_on(&vtpms->resp_wait_queue);
> +		spin_lock_irqsave(&vtpms->resp_list_lock, flags);
> +	}
> +
> +	if (vtpms->current_response) {
> +		struct transmission *t = vtpms->current_response;
> +		vtpms->current_response = NULL;
> +		transmission_free(t);
> +	}
> +
> +	spin_unlock_irqrestore(&vtpms->resp_list_lock, flags);
> +}
> +
> +static u8 vtpm_status(struct tpm_chip *chip)
> +{
> +	u8 rc = 0;
> +	unsigned long flags;
> +	struct vtpm_state *vtpms;
> +
> +	vtpms = (struct vtpm_state *)chip_get_private(chip);
> +
> +	spin_lock_irqsave(&vtpms->resp_list_lock, flags);
> +	/*
> +	 * Data are available if:
> +	 *  - there's a current response
> +	 *  - the last packet was queued only (this is fake, but necessary to
> +	 *      get the generic TPM layer to call the receive function.)
> +	 */
> +	if (vtpms->current_response ||
> +			0 != (vtpms->flags & DATAEX_FLAG_QUEUED_ONLY)) {
> +		rc = STATUS_DATA_AVAIL;
> +	} else if (!vtpms->current_response && !vtpms->current_request) {
> +		rc = STATUS_READY;
> +	}
> +
> +	spin_unlock_irqrestore(&vtpms->resp_list_lock, flags);
> +	return rc;
> +}
> +
> +static const struct file_operations vtpm_ops = {
> +	.owner = THIS_MODULE,
> +	.llseek = no_llseek,
> +	.open = tpm_open,
> +	.read = tpm_read,
> +	.write = tpm_write,
> +	.release = tpm_release,
> +};
> +
> +static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
> +static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
> +static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
> +static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
> +static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
> +static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
> +		NULL);
> +static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
> +static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
> +
> +static struct attribute *vtpm_attrs[] = {
> +	&dev_attr_pubek.attr,
> +	&dev_attr_pcrs.attr,
> +	&dev_attr_enabled.attr,
> +	&dev_attr_active.attr,
> +	&dev_attr_owned.attr,
> +	&dev_attr_temp_deactivated.attr,
> +	&dev_attr_caps.attr,
> +	&dev_attr_cancel.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group vtpm_attr_grp = { .attrs = vtpm_attrs };
> +
> +#define TPM_LONG_TIMEOUT   (10 * 60 * HZ)
> +
> +static struct tpm_vendor_specific tpm_vtpm = {
> +	.recv = vtpm_recv,
> +	.send = vtpm_send,
> +	.cancel = vtpm_cancel,
> +	.status = vtpm_status,
> +	.req_complete_mask = STATUS_BUSY | STATUS_DATA_AVAIL,
> +	.req_complete_val  = STATUS_DATA_AVAIL,
> +	.req_canceled = STATUS_READY,
> +	.attr_group = &vtpm_attr_grp,
> +	.miscdev = {
> +		.fops = &vtpm_ops,
> +	},
> +	.duration = {
> +		TPM_LONG_TIMEOUT,
> +		TPM_LONG_TIMEOUT,
> +		TPM_LONG_TIMEOUT,
> +	},
> +};
> +
> +struct tpm_chip *init_vtpm(struct device *dev,
> +		struct tpm_private *tp)
> +{
> +	long rc;
> +	struct tpm_chip *chip;
> +	struct vtpm_state *vtpms;
> +
> +	vtpms = kzalloc(sizeof(struct vtpm_state), GFP_KERNEL);
> +	if (!vtpms)
> +		return ERR_PTR(-ENOMEM);
> +
> +	vtpm_state_init(vtpms);
> +	vtpms->tpm_private = tp;
> +
> +	chip = tpm_register_hardware(dev, &tpm_vtpm);
> +	if (!chip) {
> +		rc = -ENODEV;
> +		goto err_free_mem;
> +	}
> +
> +	chip_set_private(chip, vtpms);
> +
> +	return chip;
> +
> +err_free_mem:
> +	kfree(vtpms);
> +
> +	return ERR_PTR(rc);
> +}
> +
> +void cleanup_vtpm(struct device *dev)
> +{
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +	struct vtpm_state *vtpms = (struct vtpm_state *)chip_get_private(chip);
> +	tpm_remove_hardware(dev);
> +	kfree(vtpms);
> +}
> diff --git a/drivers/char/tpm/xen-tpmfront_vtpm.h b/drivers/char/tpm/xen-tpmfront_vtpm.h
> new file mode 100644
> index 0000000..16cf323
> --- /dev/null
> +++ b/drivers/char/tpm/xen-tpmfront_vtpm.h
> @@ -0,0 +1,55 @@
> +#ifndef XEN_TPMFRONT_VTPM_H
> +#define XEN_TPMFRONT_VTPM_H
> +
> +struct tpm_chip;
> +struct tpm_private;
> +
> +struct vtpm_state {
> +	struct transmission *current_request;
> +	spinlock_t           req_list_lock;
> +	wait_queue_head_t    req_wait_queue;
> +
> +	struct list_head     queued_requests;
> +
> +	struct transmission *current_response;
> +	spinlock_t           resp_list_lock;
> +	wait_queue_head_t    resp_wait_queue;
> +
> +	u8                   vd_status;

There seems to be only two states: disconnected or connected.
Why not just make it an 'bool'?

> +	u8                   flags;

What are the flag options? Were are they enumerated?
> +
> +	unsigned long        disconnect_time;
> +
> +	/*
> +	 * The following is a private structure of the underlying
> +	 * driver. It is passed as parameter in the send function.
> +	 */
> +	struct tpm_private *tpm_private;
> +};
> +
> +
> +enum vdev_status {
> +	TPM_VD_STATUS_DISCONNECTED = 0x0,
> +	TPM_VD_STATUS_CONNECTED = 0x1
> +};
> +
> +/* this function is called from tpm_vtpm.c */

OK, then why do we need to be in this header file?

> +int vtpm_vd_send(struct tpm_private *tp,
> +		const u8 *buf, size_t count, void *ptr);
> +
> +/* these functions are offered by tpm_vtpm.c */
> +struct tpm_chip *init_vtpm(struct device *,
> +		struct tpm_private *);
> +void cleanup_vtpm(struct device *);
> +int vtpm_vd_recv(const struct tpm_chip *chip,
> +		const unsigned char *buffer, size_t count, void *ptr);
> +void vtpm_vd_status(const struct tpm_chip *, u8 status);
> +
> +static inline struct tpm_private *tpm_private_from_dev(struct device *dev)
> +{
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +	struct vtpm_state *vtpms = (struct vtpm_state *)chip->vendor.data;
> +	return vtpms->tpm_private;
> +}
> +
> +#endif
> diff --git a/include/xen/interface/io/tpmif.h b/include/xen/interface/io/tpmif.h
> new file mode 100644
> index 0000000..c9e7294
> --- /dev/null
> +++ b/include/xen/interface/io/tpmif.h
> @@ -0,0 +1,65 @@
> +/******************************************************************************
> + * tpmif.h
> + *
> + * TPM I/O interface for Xen guest OSes.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this software and associated documentation files (the "Software"), to
> + * deal in the Software without restriction, including without limitation the
> + * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
> + * sell copies of the Software, and to permit persons to whom the Software is
> + * furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> + * DEALINGS IN THE SOFTWARE.
> + *
> + * Copyright (c) 2005, IBM Corporation
> + *
> + * Author: Stefan Berger, stefanb@us.ibm.com
> + * Grant table support: Mahadevan Gomathisankaran
> + *
> + * This code has been derived from tools/libxc/xen/io/netif.h
> + *
> + * Copyright (c) 2003-2004, Keir Fraser
> + */
> +
> +#ifndef __XEN_PUBLIC_IO_TPMIF_H__
> +#define __XEN_PUBLIC_IO_TPMIF_H__
> +
> +#include "../grant_table.h"
> +
> +struct tpmif_tx_request {
> +	unsigned long addr;   /* Machine address of packet.   */

unsigned long on 32-bit is 4 bytes, but on 64-bit is 8 bytes.

> +	grant_ref_t ref;      /* grant table access reference */

This entry is 4 bytes (uin32_t).
> +	uint16_t unused;
> +	uint16_t size;        /* Packet size in bytes.        */

And these are both 2 bytes.

The structure on 64-bit is: 8+4+2+2 = 16
On 32-bit: 4+4+2+2 = 12.

The big problem is the aligment of the 'unsigned long' which
is '4' on 32-bit, so if you were to 32/64 communication, the
structure would not align. See here:


32-bit
12
0==addr, 4==gref 8==unused, 10==size

64-bit
16
0==addr, 8==gref 12==unused, 14==size

From:
        printf("%d\n", sizeof(struct tpmif_tx_request));
        printf("%d==addr, %d==gref %d==unused, %d==size\n",
                offsetof(struct tpmif_tx_request, addr),
                offsetof(struct tpmif_tx_request, gref),
                offsetof(struct tpmif_tx_request, unused),
                offsetof(struct tpmif_tx_request, size));


Use uint64_t instead of 'unsigned long' that will fix that
aligment issue.

> +};
> +struct tpmif_tx_request;
> +
> +/*
> + * The TPMIF_TX_RING_SIZE defines the number of pages the
> + * front-end and backend can exchange (= size of array).
> + */
> +#define TPMIF_TX_RING_SIZE 1

You sure? It looks to be the number of array entries? That is
how it is used in the code as well.

> +
> +/* This structure must fit in a memory page. */

Would it make sense to have a BUILD_ON_BUG to make sure?

> +
> +struct tpmif_ring {
> +	struct tpmif_tx_request req;
> +};
> +struct tpmif_ring;
> +
> +struct tpmif_tx_interface {
> +	struct tpmif_ring ring[TPMIF_TX_RING_SIZE];
> +};
> +struct tpmif_tx_interface;
> +
> +#endif
> -- 
> 1.7.10.4
