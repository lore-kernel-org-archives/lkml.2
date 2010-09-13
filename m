Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0IMQEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:04:51 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:57630 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0IMQEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:04:50 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2010 12:04:50 EDT
Message-ID: <4C8E4898.7090407@collabora.co.uk>
Date: Mon, 13 Sep 2010 16:51:52 +0100
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Buffer allocation question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to allocate some fairly large buffers which will be transferred 
via virtio to a hypervisor.

the pages dont have to be contiguous physically and aside from the first 
page int he transfer, the kernel wont really care about the contents of 
the buffer.

the pages do need to be mapped into userspace contiguously, however. 
They are also often dynamically resized.

the buffers can be quite large, and there can be several in flight at a 
given time. They must always be present in physical space (or virtio 
gets upset)

Obviously kmalloc() is out of the question, and given the size / 
quantity of the buffers, vmalloc() space is getting tight.

I'm struggling to find a good example of how this should be done.

the buffers will usually be filled all in one go, so it seems silly to 
fault them in a page at a time.

my first thought (before realising how limited vmalloc space is) was to 
vmalloc() them in my mmap() function, but this approach ran into trouble 
when I discovered that the mmap() call does not get called if the vma 
grows, so I cant then hook in and allocate more vmalloc() space.

It seems like it would be sensible to let userspace allocate the memory 
and then mmap() that range, but I've been told this is a bad idea.

Whats the best approach here? With the buffers being large I dont really 
want to transmit them in tiny bits either.

-Ian
