Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945925Ab2ERKXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:23:17 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:55640 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967636Ab2ERKXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:23:14 -0400
Message-ID: <4FB6230C.2080604@mev.co.uk>
Date: Fri, 18 May 2012 11:23:08 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120516 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: cleanup all the comedi_driver 'detach'
 functions
References: <201205171711.14968.hartleys@visionengravers.com>
In-Reply-To: <201205171711.14968.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-18 01:11, H Hartley Sweeten wrote:
> 2. Remove all the printk noise in the detach functions
>
> All of the printk output is really just noise. The user did a rmmod to
> unload the driver, we really don't need to tell them about it.

I disagree.  It's not that unusual for drivers to report device removal. 
  (It's not necessarily due to an rmmod either, not that that really 
matters.)

> Also, some of the messages are output using:
>
>          dev_dbg(dev->hw_dev, ...
> or
>          dev_info(dev->hw_dev, ...
>
> Unfortunately the hw_dev value is only used by drivers that are doing
> DMA. For most drivers this variable is going to be NULL so the output
> is not going to work as expected.

Agreed, those are bugs introduced by someone else's "cleanup"!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
