Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab1FUHzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:55:36 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:51307 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1FUHzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:55:35 -0400
Message-ID: <4E004E73.2040408@ladisch.de>
Date: Tue, 21 Jun 2011 09:55:31 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
CC: Manuel Estrada Sainz <ranty@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Getting request_firmware() filename info from user space
References: <B2150E1E4418E1438554A300EA5040E40DDE603CE3@ITSVLEX06.it.maxim-ic.internal>
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40DDE603CE3@ITSVLEX06.it.maxim-ic.internal>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hsiang wrote:
> Using the kernel request_firmware() function, it seems one can send any file by:
>     cat myfile.bin > /sys/class/firmware/xxxx/data
> 
> How does the user space code obtain the filename parameter specified in the request_firmware() call?
> 
> The documentation says $DEVPATH and $FIRMWARE variables are provided in
> the environment, but "echo $FIRMWARE" prints an empty string.

drivers/base/firmware_class.c has:

static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
{
	struct firmware_priv *fw_priv = to_firmware_priv(dev);

	if (add_uevent_var(env, "FIRMWARE=%s", fw_priv->fw_id))
		return -ENOMEM;
	if (add_uevent_var(env, "TIMEOUT=%i", loading_timeout))
		return -ENOMEM;
	if (add_uevent_var(env, "ASYNC=%d", fw_priv->nowait))
		return -ENOMEM;

	return 0;
}

Are these available at least in the udev rule?


Regards,
Clemens
