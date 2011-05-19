Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1ESLfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:35:19 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22518 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab1ESLfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:35:17 -0400
Date: Thu, 19 May 2011 13:33:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
Message-ID: <20110519133344.285a6a14@endymion.delvare>
In-Reply-To: <20110423154707.454e1010@lxorguk.ukuu.org.uk>
References: <20110419145303.111aead7@endymion.delvare>
	<BANLkTinbO_p=sKtFJtjgpo4yrEVopq9vrw@mail.gmail.com>
	<20110423154528.4145698d@endymion.delvare>
	<20110423154707.454e1010@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan, Grant,

On Sat, 23 Apr 2011 15:47:07 +0100, Alan Cox wrote:
> > And a technical question (which makes me feel somewhat ashamed as I
> > guess I really should know the answer): the ICH is using I/O ports for
> > GPIO control, not a memory mapping. Would basic_mmio_gpio work for it
> > still?
> 
> basic_mmio_gpio would need to use iomap for this and a lot of platforms
> don't support generic iomap - so no it won't.
> 
> You don't generally want want to create sub platform devices anyway
> without care as it makes sysfs, pci removal and power management ugly and
> takes up *more* memory than repeating the code in the first places.

OK, so given that I can't use basic_mmio_gpio and Alan thinks that
having an independent driver is the way to go anyway, is there any
chance to get my code reviewed and merged? I am using it since the day
I submitted it (one month ago), it appears to work fine for me, and
it is a mandatory piece to support SMBus multiplexing on many x86 server
boards. I'd like to see it happen in kernel 2.6.40.

I can resend the patch if it helps, but I did not make any change to
the code since the first submission.

Thanks,
-- 
Jean Delvare
