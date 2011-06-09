Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1FIH34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:29:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63583 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab1FIH3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:29:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor management driver
Date: Thu, 9 Jun 2011 09:29:23 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Timur Tabi <timur@freescale.com>, alan@lxorguk.ukuu.org.uk,
        kumar.gala@freescale.com, benh@kernel.crashing.org, greg@kroah.com,
        akpm@kernel.org, cmetcalf@tilera.com, konrad.wilk@oracle.com,
        dsaxena@linaro.org, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org
References: <1307573154-15838-1-git-send-email-timur@freescale.com>
In-Reply-To: <1307573154-15838-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106090929.23671.arnd@arndb.de>
X-Provags-ID: V02:K0:tFFoGo89QBSPojCovYKqsfW5w0hpZ1YRpLVPLDTvmgl
 ijgnDWHC+GBUSCgAxo/JguZ6mRoxa8K/rUt6zgyCcpf8e7C0Va
 tI9HrH6nUMpTXeJn8xPaDrqRCe1+YPdHgG/UtJjwkojqGwxddl
 mEDLOFsdCj+ck7EgUXW9x1gWFxW/YUQB+SAlSHPk3WumAEsuVQ
 eL5E+UVOYUEbpmG2G95Hw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 June 2011 00:45:54 Timur Tabi wrote:
> +struct fsl_hv_ioctl_memcpy {
> +       __u32 ret;
> +       __u32 source;
> +       __u32 target;
> +       __u64 local_vaddr;
> +       __u64 remote_paddr;
> +       __u64 count;
> +};

> +struct fsl_hv_ioctl_prop {
> +       __u32 ret;
> +       __u32 handle;
> +       __u64 path;
> +       __u64 propname;
> +       __u64 propval;
> +       __u32 proplen;
> +};

These structures have implied padding. Better make it explicit by
adding the appropriate __u32 __pad1 members or similar.

> +/*
> + * ioctl commands.
> + */
> +enum {
> +       FSL_HV_IOCTL_PARTITION_RESTART = 1, /* Boot another partition */
> +       FSL_HV_IOCTL_PARTITION_GET_STATUS = 2, /* Boot another partition */
> +       FSL_HV_IOCTL_PARTITION_START = 3, /* Boot another partition */
> +       FSL_HV_IOCTL_PARTITION_STOP = 4, /* Stop this or another partition */
> +       FSL_HV_IOCTL_MEMCPY = 5, /* Copy data from one partition to another */
> +       FSL_HV_IOCTL_DOORBELL = 6, /* Ring a doorbell */
> +
> +       /* Get a property from another guest's device tree */
> +       FSL_HV_IOCTL_GETPROP = 7,
> +
> +       /* Set a property in another guest's device tree */
> +       FSL_HV_IOCTL_SETPROP = 8,
> +};

As discussed before, this one should really be using the _IOC macros to define
the commands that you use based on the structure definitions above, e.g.

#define FSL_HV_IOCTL_GETPROP _IORW(FSL_HV, 8, struct fsl_hv_ioctl_prop)

Then get rid of all the code that takes apart the ioctl command numbers
again and just do a switch/case based on the command.

	Arnd

	Arnd
