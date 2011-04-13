Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab1DMK5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:57:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:36923 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1DMK5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:57:04 -0400
Message-ID: <4DA58179.40004@linutronix.de>
Date: Wed, 13 Apr 2011 12:56:57 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Tatyana Brokhman <tlinder@codeaurora.org>, gregkh@suse.de,
        linux-arm-msm@vger.kernel.org, balbi@ti.com, ablay@codeaurora.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] usb/gadget: don't deploy SS descriptors if SS is
 not enabled.
References: <20110411175917.GE4018@linutronix.de> <1302636896-12717-1-git-send-email-bigeasy@linutronix.de> <1302636896-12717-5-git-send-email-bigeasy@linutronix.de> <4DA57F0F.1090609@ru.mvista.com>
In-Reply-To: <4DA57F0F.1090609@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.

Hello Sergei,

> Cleaned-up example:
> 
> (in header)
>     #ifndef CONFIG_NET_FUNKINESS
>     static inline void init_funky_net (struct net_device *d) {}
>     #endif
> 
> (in the code itself)
>     dev = alloc_etherdev (sizeof(struct funky_private));
>     if (!dev)
>         return -ENODEV;
>     init_funky_net(dev);

The problem here is that the code is included via

   #include "composite.c

so we don't really use header files. The alternative would be to use the
gadget_is_super_speed() function but that one takes a gadget as argument.
Preferences?

> 
> WBR, Sergei

Sebastian
