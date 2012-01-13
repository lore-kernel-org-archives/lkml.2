Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2AMEMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 23:12:47 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52122 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2AMEMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 23:12:44 -0500
MIME-Version: 1.0
In-Reply-To: <4F0ECE29.3060109@mvista.com>
References: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
	<4F0ECE29.3060109@mvista.com>
Date: Fri, 13 Jan 2012 13:12:44 +0900
Message-ID: <CANKRQngF4nedC9KCyBV0aHf69Xg1ssb0DtYsNMAVnDfmN=k88g@mail.gmail.com>
Subject: Re: [PATCH 1/6 v2] usb/gadget/pch_udc: Fix disconnect issue
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei

2012/1/12 Sergei Shtylyov <sshtylyov@mvista.com>:
>> CAUSE:
>> When the driver calls dev->driver->disconnect(), it is not calling
>> spinlock().
>
>
>   spin_unlock(), you mean?

It means that there is not the following sentence in the previous source.
I think this is a cause of system freeze.
> +               spin_unlock(&dev->lock);
> +               spin_lock(&dev->lock);

I correct myself below.
CAUSE:
The driver calls dev->driver->disconnect() without calling
spin_unlock(&dev->lock).

thanks,
tomoya
