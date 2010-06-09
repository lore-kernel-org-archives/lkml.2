Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab0FIIYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:24:15 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:47626 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755567Ab0FIIYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:24:13 -0400
Message-ID: <000901cb07ad$234e6cf0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       <andrew.chih.howe.khor@intel.com>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <000501cae2eb$de97e950$66f8800a@maildom.okisemi.com> <201004231657.57466.arnd@arndb.de>
Subject: Re: [PATCH] Topcliff PHUB: Add The Packet Hub driver [1/2]
Date: Wed, 9 Jun 2010 17:24:06 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd

We have added our comment for your email in line.
If you have any question, let me know.

After modifying , we will resubmit our phub pach.(Today or tommorow)

Thanks,
Ohtake.

----- Original Message ----- 
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "NETDEV" <netdev@vger.kernel.org>; "Wang, Yong Y" <yong.y.wang@intel.com>; "Wang, Qi" <qi.wang@intel.com>;
<andrew.chih.howe.khor@intel.com>
Sent: Friday, April 23, 2010 11:57 PM
Subject: Re: [PATCH] Topcliff PHUB: Add The Packet Hub driver [1/2]


> On Friday 23 April 2010, Masayuki Ohtake wrote:

>
> You have submitted this driver to the netdev list, but put
> the code into drivers/char. If this is really a network driver,
> it should probably go into drivers/net, otherwise it needs to be
> reviewed on the main linux-kernel mailing list.
PHUB is not network driver.

>
> If you want it to be applied as a staging driver first, change
> the code location to drivers/staging first a
We don't want it to be applied as a staging driver first.

>
> >diff -urN linux-2.6.33.1/drivers/char/Kconfig
> >topcliff-2.6.33.1/drivers/char/Kconfig
> >--- linux-2.6.33.1/drivers/char/Kconfig 2010-03-16 01:09:39.000000000 +0900
> >+++ topcliff-2.6.33.1/drivers/char/Kconfig 2010-04-14 18:19:10.000000000
> >+0900
> >@@ -4,6 +4,13 @@
>
> Evidently, your email client breaks line-wrapping. This means that it's
> not possibly to apply the patch. Please see Documentation/email-clients.txt
> on how to fix this.
We used outlook express.
But now, we use thunderbird.

>
> To make sure this does not happen again, you can send the patch to yourself
> and try to apply it from the email as a test before you send it to a
> mailing list.
>
> > menu "Character devices"
> >
> >+config PCH_PHUB
> >+        tristate "PCH PHUB"
> >+        depends on PCI
> >+        help
> >+          If you say yes to this option, support will be included for the
> >+          PCH Packet Hub Host controller.
> >+
> > config VT
> >  bool "Virtual terminal" if EMBEDDED
> >  depends on !S390
>
> This description also should be more helpful. This could be the same
> text that you will put in the patch description above.
We agree.
We will add in detail.

>
> >diff -urN linux-2.6.33.1/drivers/char/pch_phub/pch_common.h
> >topcliff-2.6.33.1/drivers/char/pch_phub/pch_common.h
> >--- linux-2.6.33.1/drivers/char/pch_phub/pch_common.h 1970-01-01
> >09:00:00.000000000 +0900
> >+++ topcliff-2.6.33.1/drivers/char/pch_phub/pch_common.h 2010-04-14
> >15:29:48.000000000 +0900
> >@@ -0,0 +1,147 @@
> >+/*!
> >+ * @file pch_common.h
> >+ * @brief Provides the macro definitions used by all files.
> >+ * @version 1.0.0.0
> >+ * @section
>
> You seem to use a tool for processing the comments into documentation,
> which is good. However, the syntax you use is incompatible with the
> one used in the kernel and should be changed to the 'kerneldoc'
> format, see Documentation/kernel-doc-nano-HOWTO.txt.
Referring 'kernel-doc-nano-HOWTO.txt', we will modify.

>
> >+/*! @ingroup Global
> >+@def      PCH_WRITE8
> >+@brief   Macro for writing 8 bit data to an io/mem address
> >+*/
> >+#define PCH_WRITE8(val, addr)   iowrite8((val), (void __iomem *)(addr))
> >+/*! @ingroup Global
> >+@def      PCH_LOG
> >+@brief   Macro for writing 16 bit data to an io/mem address
> >+*/
> >+#define PCH_WRITE16(val, addr)  iowrite16((val), (void __iomem *)(addr))
> >+/*! @ingroup Global
> >+@def      PCH_LOG
> >+@brief   Macro for writing 32 bit data to an io/mem address
>
> In general, wrapping kernel functions in a driver specific macro that
> does not do anything else is discouraged. It's best to delete these
> macros and change the code to use the underlying interfaces directly.
We have deleted unnecessary wrapping.

>
> >+#ifndef __PCH_DEBUG_H__
> >+#define __PCH_DEBUG_H__
> >+
> >+#ifdef MODULE
> >+#define PCH_LOG(level, fmt, args...) printk(level "%s:" fmt "\n",\
> >+       THIS_MODULE->name, ##args)
> >+#else
> >+#define PCH_LOG(level, fmt, args...) printk(level "%s:" fmt "\n" ,\
> >+        __FILE__, ##args)
> >+#endif
> >+
> >+
> >+#ifdef DEBUG
> >+ #define PCH_DEBUG(fmt, args...) PCH_LOG(KERN_DEBUG, fmt, ##args)
> >+#else
> >+ #define PCH_DEBUG(fmt, args...)
> >+#endif
> >+
> >+#ifdef PCH_TRACE_ENABLED
> >+ #define PCH_TRACE PCH_DEBUG
> >+#else
> >+ #define PCH_TRACE(fmt, args...)
> >+#endif
> >+
> >+#define PCH_TRACE_ENTER PCH_TRACE("Enter %s", __func__)
> >+#define PCH_TRACE_EXIT  PCH_TRACE("Exit %s", __func__)
>
> For these macros, we already have existing interfaces in the kernel,
> you should remove yours and use dev_dbg, dev_info, pr_debug etc.
We have replaced our original function to linux function.

>
> The tracing functions can probably just be removed here. If you
> feel that you need tracing, please take a look at the kernel
> tracing subsystem. There is an excellent series of articles
> about tracing at http://lwn.net/Articles/383362/.
We have deleted tracing function.

>
> >+/**
> >+ * file_operations structure initialization
> >+ */
> >+const struct file_operations pch_phub_fops = {
> >+ .owner = THIS_MODULE,
> >+ .open = pch_phub_open,
> >+ .release = pch_phub_release,
> >+ .ioctl = pch_phub_ioctl,
> >+};
>
> New code should use the 'unlocked_ioctl' callback instead of 'ioctl'.
We agree.

>
> The whitespace in this patch is damaged: indentation of code should
> be done with tabs instead of spaces. It's not clear if the code is
> written like this, or it was damaged by your email client.
>
> If the problem is part of your actual code, have a look at
> Documentation/CodingStyle for how it should look like.
We use thunderbird now.
Thus, we think our patch is not damaged.

>
> >+/*function implementations*/
> >+
> >+/*! @ingroup PHUB_InterfaceLayerAPI
> >+  @fn  int pch_phub_open( struct inode *inode,struct file *file)
> >+  @remarks  Implements the Initializing and opening of the Packet Hub
> >module.
> >+  @param  inode  [@ref INOUT] Contains the reference of the inode
> >+         structure
> >+  @param  file  [@ref INOUT] Contains the reference of the file structure
> >+  @retval returnvalue [@ref OUT] contains the result for the concerned
> >+         attempt.
> >+  The result would generally comprise of success code
> >+  or failure code. The failure code will indicate reason for
> >+  failure.
> >+  @see
> >+  EBUSY
> >+  */
> >+int pch_phub_open(struct inode *inode, struct file *file)
> >+{
>
> Since this is not an exported interface, it the function should
> probably be marked 'static'.
We have modified definition as 'static'.

>
> >+ int ret_value = PCH_PHUB_SUCCESS;
> >+ struct pch_phub_reqt *p_pch_phub_reqt;
> >+ unsigned long addr_offset;
> >+ unsigned long data;
> >+ unsigned long mask;
> >+
> >+ do {
> >+  if (pch_phub_suspended == true) {
> >+   PCH_LOG(KERN_ERR, "pch_phub_ioctl : "
> >+    "suspend initiated returning =%d\n",
> >+    PCH_PHUB_FAIL);
> >+   ret_value = PCH_PHUB_FAIL;
> >+   break;
> >+  }
>
> Using the do { ... } while (0) construct in this way is not wrong,
> but unconventional. The way this is normally done in Linux is to
> have a goto target at the end.
We have deleted unnecessary '{ ...}' and while(0).

>
> The macros PCH_PHUB_SUCCESS and PCH_PHUB_FAIL should probably
> be removed, because they are not standard error codes. By convention,
> you should return 0 for success in ioctl or one of the errno.h
> values for failure, as you do below.
We have replaced our original returned value to linux's returned value.

>
> >+  p_pch_phub_reqt = (struct pch_phub_reqt *)arg;
> >+  ret_value =
> >+   copy_from_user((void *)&addr_offset,
> >+    (void *)&p_pch_phub_reqt->addr_offset,
> >+    sizeof(addr_offset));
> >+  if (ret_value) {
> >+   PCH_LOG(KERN_ERR, "pch_phub_ioctl : "
> >+    "copy_from_user fail returning =%d\n",
> >+    -EFAULT);
> >+   ret_value = -EFAULT;
> >+   break;
> >+  }
>
> It is much easier to use get_user() here than copy_from_user.
We have replaced copy_from_user to get_user.

>
> The definition of struct pch_phub_reqt is problematic because
> it contains members of type 'unsigned long'. This means that
> a 32 bit user process uses a different data structure than a
> 64 bit kernel.
>
> Ideally, you only pass a single integer as an ioctl argument.
> There are cases where it needs to be a data structure, but
> if that happens, you should only use members types like __u32
> or __u64, not long or pointer.
We have defined as u32 type.

>
> >+  switch (cmd) {
> >+  case IOCTL_PHUB_READ_REG:
> >+   {
> >+
> >+    pch_phub_read_reg(addr_offset, &data);
> >+    PCH_DEBUG("pch_phub_ioctl  : Invoked "
> >+     "pch_phub_read_reg successfully\n");
> >+
> >+    ret_value =
> >+        copy_to_user((void *)&p_pch_phub_reqt->
> >+       data, (void *)&data,
> >+       sizeof(data));
> >+    if (ret_value) {
> >+     PCH_LOG(KERN_ERR, "pch_phub_ioctl : "
> >+     "copy_to_user fail returning =%d\n",
> >+      -EFAULT);
> >+     ret_value = -EFAULT;
> >+     break;
> >+    }
> >+    break;
> >+   }
> >+
> >+  case IOCTL_PHUB_WRITE_REG:
> >+   {
> >+
> >+    ret_value =
> >+        copy_from_user((void *)&data,
> >+         (void *)&p_pch_phub_reqt->
> >+         data, sizeof(data));
> >+    if (ret_value) {
> >+     PCH_LOG(KERN_ERR, "pch_phub_ioctl : "
> >+     "copy_from_user fail returning =%d\n",
> >+      -EFAULT);
> >+     ret_value = -EFAULT;
> >+     break;
> >+    }
> >+    pch_phub_write_reg(addr_offset, data);
> >+    PCH_DEBUG("pch_phub_ioctl  : Invoked "
> >+     "pch_phub_write_reg successfully\n");
> >+    break;
> >+   }
>
> My feeling is that this ioctl interface is too
> low-level in general. You only export access to specific
> registers, not to functionality exposed by them.
> The best kernel interfaces are defined in a way that
> is independent of the underlying hardware and
> convert generic commands into device specific commands.
>
> If you really want to allow direct register access,
> a simpler way would be to map the memory into the user
> address space using the mmap() operation and not
> provide any ioctl commands.
Packet Hub has function accessing many resisters.
Thus, we think current spec is better.

>
> I don't see any range cheching on the addr_offset
> argument, which means that a malicious user can use this
> function to access not only your device, but any data
> in the kernel address space.
We have implemented range limitaion code.

>
> Note that your open count does not protect the
> hardware from concurrent access, because a file
> descriptor can be shared by multiple user threads.
> You can probably safely drop that count.
We will implement using mutex.

>
> >+/*! @ingroup PHUB_InterfaceLayer
> >+  @def IOCTL_PHUB_READ_REG
> >+  @brief Outlines the read register function signature.
> >+  */
> >+#define IOCTL_PHUB_READ_REG (_IOW(PHUB_IOCTL_MAGIC, 1, unsigned long))
>
> If I read your code correctly, you actually pass a struct pch_phub_reqt
> argument, not an unsigned long argument, so this definition should be
> changed accordingly. The same applies to the other ioctl commands.
I have modified as 'u32'.

>
>
> Your patch continues in a second email, which is not how you normally
> split submissions. When there is a logical separation between parts
> of the driver, make multiple patches, each with a separate description
> of what the patch does.
>
> In case of this driver, that does not seem necessary. In fact, it seems
> to me like it is simple enough to become a single source file, which
> would simplify it even more because you no longer need header files
> defining the interface between parts of the driver.
We agree.

>
> Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



