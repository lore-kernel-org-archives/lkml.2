Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0INGwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 02:52:42 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.31]:39638 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab0INGwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 02:52:40 -0400
Message-ID: <4C8F1BC8.4010201@ladisch.de>
Date: Tue, 14 Sep 2010 08:52:56 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Ian Molton <ian.molton@collabora.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Buffer allocation question
References: <4C8E4898.7090407@collabora.co.uk>
In-Reply-To: <4C8E4898.7090407@collabora.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Molton wrote:
> I need to allocate some fairly large buffers which will be transferred 
> via virtio to a hypervisor.
> 
> the pages dont have to be contiguous physically and aside from the first 
> page int he transfer, the kernel wont really care about the contents of 
> the buffer.
> 
> the pages do need to be mapped into userspace contiguously, however. 

See drivers/firewire/core-iso.c, which uses fixed-size buffers.

> They are also often dynamically resized.
> ...
> my first thought (before realising how limited vmalloc space is) was to 
> vmalloc() them in my mmap() function, but this approach ran into trouble 
> when I discovered that the mmap() call does not get called if the vma 
> grows, so I cant then hook in and allocate more vmalloc() space.

You can set vma->vm_ops.

> the buffers will usually be filled all in one go, so it seems silly to 
> fault them in a page at a time.

AFAICS you don't have a choice when resizing.


Regards,
Clemens
