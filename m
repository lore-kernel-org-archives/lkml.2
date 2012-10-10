Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2JJNIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:08:17 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:38347 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2JJNIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:08:15 -0400
Message-ID: <1349874065.23493.23.camel@misato.fc.hp.com>
Subject: Re: acpi : acpi_bus_trim() stops removing devices when failing to
 remove the device
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        wency@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com
Date: Wed, 10 Oct 2012 07:01:05 -0600
In-Reply-To: <5074CA61.3010802@jp.fujitsu.com>
References: <5073E4CC.3090600@jp.fujitsu.com>
	 <1349800566.23493.9.camel@misato.fc.hp.com>
	 <5074CA61.3010802@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 10:07 +0900, Yasuaki Ishimatsu wrote:
 :
> >>   	if (acpi_drv) {
> >>   		if (acpi_drv->ops.notify)
> >>   			acpi_device_remove_notify_handler(acpi_dev);

THIS CALL

> >> -		if (acpi_drv->ops.remove)
> >> -			acpi_drv->ops.remove(acpi_dev, acpi_dev->removal_type);
> >> +		if (acpi_drv->ops.remove) {
> >> +			ret = acpi_drv->ops.remove(acpi_dev,
> >> +						   acpi_dev->removal_type);
> >> +			if (ret)
> >
> > Hi Yasuaki,
> >
> > Shouldn't the notify handler be reinstalled here if it was removed by
> > the acpi_device_remove_notify_handler() above?
> 
> I do not reinstall the notify handler.
> The function has not been removed on linux-3.6. And the patch is created
> on linux-3.6. So the function remains in the patch.

Umm... I am not sure what you meant.  Let me clarify my comment.  When
acpi_drv->ops.remove() failed, I thought we would need to roll-back the
procedure done by the acpi_device_remove_notify_handler() call, which I
indicated as "THIS CALL" above.  So, in this error path, don't we need
something like below?

if (acpi_drv->ops.notify)
	acpi_device_install_notify_handler(acpi_dev)

Thanks,
-Toshi




