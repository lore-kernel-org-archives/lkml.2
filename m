Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab0LNQTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:19:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:60496 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758112Ab0LNQTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:19:42 -0500
Date: Tue, 14 Dec 2010 08:11:30 -0800
From: Greg KH <gregkh@suse.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>
Subject: Re: [PATCH] base: add sysfs socs info
Message-ID: <20101214161130.GB1857@suse.de>
References: <1292330417-13703-1-git-send-email-plagnioj@jcrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292330417-13703-1-git-send-email-plagnioj@jcrosoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 01:40:17PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> this provide an easy way to register soc information
> 
> arch, family, model, id, revision
> 
> as this for at91sam9g20
> 
> $ cat /sys/devices/system/soc/soc0/arch
> current
> $ cat /sys/devices/system/soc/soc0/family
> at91
> $ cat /sys/devices/system/soc/soc0/id
> at91sam9g20
> $ cat /sys/devices/system/soc/soc0/model
> 0x00000000019905a0
> $ cat /sys/devices/system/soc/soc0/revision
> 1.1

What is this for?  When you add sysfs files, you are required to add
entries to the Documentation/ABI/ files as well, please always provide
this so we are able to review the code easier.

> +/*
> + * register_soc - Setup a sysfs device for a SOC.
> + *
> + * Initialize and register the SOC device.
> + */
> +int register_soc(struct soc *soc)
> +{
> +	int err;
> +
> +	if (!soc)
> +		return -EINVAL;
> +
> +	soc->sysdev.id = nb_socs;
> +	soc->sysdev.cls = &soc_sysdev_class;
> +
> +	if (!soc->arch)
> +		soc->arch = arch_current;
> +
> +	err = sysdev_register(&soc->sysdev);
> +
> +	if (err)
> +		return err;
> +
> +	err = sysdev_create_file(&soc->sysdev, &attr_arch);
> +
> +	if (err)
> +		goto end;

<snip>

Please use an attribute group, it makes the code simpler and easier to
read.

> +struct soc {
> +	u64 id;
> +	char *arch;
> +	char *family;
> +	char *model;
> +	char *revision;
> +	struct sys_device sysdev;
> +};

What is a "SOC"?  A "Small Ordinary Creature"?

And does every system have one of these?  Just one?  Not multiple?  We
need a whole lot more information here as to why this code is needed,
and who will be using it.

Also, isn't this information already in /proc/cpu/ today?

thanks,

greg k-h
