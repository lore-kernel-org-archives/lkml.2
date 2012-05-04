Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482Ab2EDTca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:32:30 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53771 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab2EDTc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:32:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC v2 1/5] PM, Runtime, Add power_must_be_on flag
Date: Fri, 4 May 2012 21:37:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <1336119221-21146-2-git-send-email-ying.huang@intel.com>
In-Reply-To: <1336119221-21146-2-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205042137.16425.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 04, 2012, Huang Ying wrote:
> The extreme way to save device power in runtime is to turn off power
> of device.  For example, D3cold for PCIe bus and ZPODD (Zero Power
> Optical Disk Drive) for SATA bus will do that.
> 
> But sometimes power off is not expected, some possible reason is as
> follow
> 
> - power off device usually incurs longer resume latency, if it exceeds
>   power QoS requirement, power off should be disabled.
> 
> - For some buses, device in power off state can not support remote
>   wakeup.  If remote wakeup is desired, power off should be disabled.
> 
> In general, whether to put a device into power off state should be
> decided by the driver of the device, but for some buses, whether to
> put a device into power off state may be done by the parent of the
> device.  For example, a PCIe end point device may be put into power
> off state by the PCIe port connected to it.
> 
> So a flag is introduced for the children devices to tell the parent
> device, whether it should be put into power off state.
> 
> This flag is also used for device driver to tell bus layer whether it
> is OK to be powered off.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

I would be almost fine with this patch, if [2/5] were not present.

However, if you introduce a flag like this, you need to put checks
against it into all places where power may be removed from devices,
like the generic PM domains framework (but not only there).

Thanks,
Rafael


> ---
>  include/linux/pm.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -536,6 +536,7 @@ struct dev_pm_info {
>  	unsigned int		irq_safe:1;
>  	unsigned int		use_autosuspend:1;
>  	unsigned int		timer_autosuspends:1;
> +	unsigned int		power_must_be_on:1;
>  	enum rpm_request	request;
>  	enum rpm_status		runtime_status;
>  	int			runtime_error;
> 
> 

