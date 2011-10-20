Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1JTIJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:09:45 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35123 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1JTIJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:09:43 -0400
Date: Thu, 20 Oct 2011 16:08:59 +0800
From: liu ping fan <pingfank@linux.vnet.ibm.com>
To: "canquan.shen" <shencanquan@huawei.com>
Cc: linux-kernel@vger.kernel.org, seabios@seabios.org, qemu-devel@nongnu.org,
        aliguori@us.ibm.com, dave@linux.vnet.ibm.com,
        gong.chen@linux.intel.com, len.brown@intel.com
Subject: Re: [PATCH 1/1] ACPI: Call ACPI remove handler when handling ACPI
 eject event
Message-ID: <20111020080858.GA5808@oc8440477808.ibm.com>
References: <1318992821-10552-1-git-send-email-pingfank@linux.vnet.ibm.com>
 <1318992821-10552-2-git-send-email-pingfank@linux.vnet.ibm.com>
 <4E9E48FB.4010807@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E9E48FB.4010807@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 11:50:19AM +0800, canquan.shen wrote:
> Hi ping fan,
>    Your patch is similar with my patch, my patch name is "acpi: Fix
> CPU hot removal problem".
I saw your patch, a little similar. BTW, how are things going on? It is a
long time since V0 patch
> 
> Thanks.
> Canquan.Shen
> 2011-10-19
> 
> On 2011/10/19 10:53, pingfank@linux.vnet.ibm.com wrote:
> >From: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
> >
> >Call the remove handler for ACPI_NOTIFY_EJECT_REQUEST
> >
> >Signed-off-by: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
> >---
> >  drivers/acpi/bus.c      |    2 +-
> >  drivers/acpi/scan.c     |    2 +-
> >  include/acpi/acpi_bus.h |    2 ++
> >  3 files changed, 4 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> >index 437ddbf..d06ec6d 100644
> >--- a/drivers/acpi/bus.c
> >+++ b/drivers/acpi/bus.c
> >@@ -764,7 +764,7 @@ static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
> >  		break;
> >
> >  	case ACPI_NOTIFY_EJECT_REQUEST:
> >-		/* TBD */
> >+		acpi_os_hotplug_execute(acpi_bus_hot_remove_device, handle);
> >  		break;
> >
> >  	case ACPI_NOTIFY_DEVICE_CHECK_LIGHT:
> >diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> >index 449c556..3b97b61 100644
> >--- a/drivers/acpi/scan.c
> >+++ b/drivers/acpi/scan.c
> >@@ -83,7 +83,7 @@ acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, cha
> >  }
> >  static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
> >
> >-static void acpi_bus_hot_remove_device(void *context)
> >+void acpi_bus_hot_remove_device(void *context)
> >  {
> >  	struct acpi_device *device;
> >  	acpi_handle handle = context;
> >diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> >index 6cd5b64..b19c09d 100644
> >--- a/include/acpi/acpi_bus.h
> >+++ b/include/acpi/acpi_bus.h
> >@@ -310,6 +310,8 @@ extern int unregister_acpi_notifier(struct notifier_block *);
> >
> >  extern int register_acpi_bus_notifier(struct notifier_block *nb);
> >  extern void unregister_acpi_bus_notifier(struct notifier_block *nb);
> >+extern void acpi_bus_hot_remove_device(void *context);
> >+
> >  /*
> >   * External Functions
> >   */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
