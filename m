Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab1KJWL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 17:11:58 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33640 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab1KJWL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 17:11:57 -0500
Message-ID: <4EBC4C27.3070400@gmail.com>
Date: Fri, 11 Nov 2011 09:11:51 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Marcus Folkesson <marcus.folkesson@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        m.szyprowski@samsung.com
Subject: Re: ioremap on system memory
References: <CAM8FrKJ8OeavZxTBJBONw76UBBzS_mQYMZuS6Chf8+Po6yqDgA@mail.gmail.com>
In-Reply-To: <CAM8FrKJ8OeavZxTBJBONw76UBBzS_mQYMZuS6Chf8+Po6yqDgA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/11 19:06, Marcus Folkesson wrote:

> Hi,
> 
> I'm working with a custom based platform based on OMAP-L138.
> A driver we are using is ioremapping system memory. It does this to
> share data between the GPP and DSP core.
> This is not allowed in later kernel versions since ARMv6+ does not support this.
> 
> Is there any good(and easy) way to get around this or is it so
> fundamentally wrong that the driver should be written from scratch?


Cc'ed the ARM kernel list and Marek Szyprowski (CMA developer). The CMA
patches I think do what you want, but I am not sure if they are merged
yet. The other solution (again, I'm not an expert on this area) is to
not pass the region of memory you want to manage as part of Linux's
normal system memory. See how the OMAP framebuffer driver reserves a
region of SDRAM (arch/arm/plat-omap/fb.c).

Some one else on the ARM list can probably explain in more detail.

~Ryan

