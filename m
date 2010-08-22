Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab0HVUsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 16:48:19 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:39400 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab0HVUsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 16:48:16 -0400
Date: Sun, 22 Aug 2010 22:48:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Thomas <pthomas8589@gmail.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: (ads7871) Fix ads7871_probe init path
Message-ID: <20100822224805.0b84d94a@hyperion.delvare>
In-Reply-To: <1282487126.23014.11.camel@phoenix>
References: <1282487126.23014.11.camel@phoenix>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Sun, 22 Aug 2010 22:25:26 +0800, Axel Lin wrote:
> >From 81e895683eaecb9e196c57c36b774c0908069d83 Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Sun, 22 Aug 2010 22:10:01 +0800
> Subject: [PATCH] hwmon: (ads7871) Fix ads7871_probe init path
> 
> This patch includes below fixes:
> 
> 1. remove 'status' variable
> 2. remove unneeded initialization of 'err' variable
> 3. return missing error code if sysfs_create_group fail.
> 4. fix the init sequence as:
>    - check hardware existence
>    - kzalloc for ads7871_data
>    - sysfs_create_group
>    - hwmon_device_register
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> 
> hi Jean,
> This patch is against linux-next ( on top of previous patch ).
> Reviews are welcome.

Looks good. I've folded this patch into the old one, and will send the
result to Linux shortly.

> I think it's ok to call sysfs_create_group() before hwmon_device_register().
> If hwmon_device_register failed, the device is not working anyway.
> We just need to make sure all the allocated resources are reclaimed in error path before return error.

Agreed.

-- 
Jean Delvare
