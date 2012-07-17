Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2GQBfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:35:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50137 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GQBfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1207021900100.1784@c4eb>
References: <alpine.LFD.2.02.1207021900100.1784@c4eb>
Date: Tue, 17 Jul 2012 09:35:02 +0800
Message-ID: <CACVXFVM+u+o=R0M31mqqzmtRN4YvqgUKvJZKfBYtgH15JDh3bQ@mail.gmail.com>
Subject: Re: [PATCH] driver core: move uevent call to driver_register
From: Ming Lei <ming.lei@canonical.com>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 1:08 AM, Sebastian Ott <sebott@linux.vnet.ibm.com> wrote:

> --- a/drivers/base/driver.c
> +++ b/drivers/base/driver.c
> @@ -187,6 +187,9 @@ int driver_register(struct device_driver
>         ret = driver_add_groups(drv, drv->groups);
>         if (ret)
>                 bus_remove_driver(drv);
> +
> +       kobject_uevent(&drv->p->kobj, KOBJ_ADD);

You should just send the uevent if 'ret' equals to zero., otherwise
OOPS may be triggered by kobject_uevent() after the 'drv' has been
removed.


Thanks,
--
Ming Lei
