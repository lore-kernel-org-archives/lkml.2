Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2FLM74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:59:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62165 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2FLM7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:59:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 06/14] mfd: Initialise the DB8500 PRCMU driver at core_initcall time
Date: Tue, 12 Jun 2012 12:59:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Samuel Ortiz <sameo@linux.intel.com>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <CACRpkdYoQFhBfRaPMBiVTiD979b+8708oS1qCPm+iyy5OZe2bw@mail.gmail.com> <4FD6FF6C.6040500@linaro.org>
In-Reply-To: <4FD6FF6C.6040500@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206121259.38807.arnd@arndb.de>
X-Provags-ID: V02:K0:aPcVl++fSR1NkvqID7EUaF419HZ+IZoTtaQconxtPy1
 kAkC0vWthbSUZ6fZvBR2sRiviNJVWEMAjfF3XuqII8yDAGrKvq
 4mgRE1kFW3fOTjkTz4a3dTa1zVzddIiJ/A/VkObIHCphJ3liAo
 bsNz2gXxS7MZ7Q/Vj8l0dRLCAyFRUNbm+ZcGLMYdXbTqCYPWjk
 4rY+mSkvEH6KYL3Bgn0gIvp2wmWvB8/AyA/NVEMeqvBzyKAjDk
 wlh0THVi6Fg69s47dSCaMkexaT8X1gvc+7Y+aGVIQ7gh9iD6tx
 n2yJbyd3xZrTSHqiFQfkWfEEfM5evCyAinH0cjXgzvKhqwFXmn
 kjWhsdHNDXZt+LHvOk+8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2012, Lee Jones wrote:
> On 11/06/12 22:01, Linus Walleij wrote:
> > Hm what shall we do when we run out of initlevels? I think this was the
> > kind of thing that deferred probe should solve. Usually changing this kind
> > of thing has side effects so I'm a bit hesitant.
> 
> Ah yes, I remember now. The IRQ domain needs to be in place before the 
> Device Tree is parsed by the Open Firmware subsystem. If it's not the 
> error "no irq domain found" is triggered and the IRQs are never mapped.
> 
> I'd be happy to take a second opinion, but I believe this (and the other 
> core_initcall patch) is required.

It's still just a hack. The real solution that we discussed last time it
came up is to defer the translation of irq numbers until device driver
probe time, and bail out with -EPROBE_DEFER if you try to use a device
whose interrupt is not available yet.

	Arnd
