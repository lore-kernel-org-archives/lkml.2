Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2EaVnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 17:43:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45990 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2EaVnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 17:43:07 -0400
Message-ID: <4FC7E610.5060207@gmail.com>
Date: Thu, 31 May 2012 17:43:44 -0400
From: John Moser <john.r.moser@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Is this code right in zram?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

before I go stomping all over other peoples' work and sending idiotic 
patches, I think I'll ask.  Since I have no clue what I'm doing.

in drivers/staging/zram.c out of 3.4 (I just grabbed the source hours 
ago), I see this on lines 810-822:

        /* Allocate the device array and initialize each one */
         pr_info("Creating %u devices ...\n", num_devices);
         zram_devices = kzalloc(num_devices * sizeof(struct zram), 
GFP_KERNEL);
         if (!zram_devices) {
                 ret = -ENOMEM;
                 goto unregister;
         }

         for (dev_id = 0; dev_id < num_devices; dev_id++) {
                 ret = create_device(&zram_devices[dev_id], dev_id);
                 if (ret)
                         goto free_devices;
         }

Curiosity got me to here:

http://lwn.net/Articles/147014/

So assuming this, what I see here is:

  - kmalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
  - memset() that to 0
  - immediately fill in this RAM without reading it

I'm wondering what the immediate need is to fill the area with zeros?  
Also curious as to whether the kzalloc() thing should better be 
kcalloc(num_devices, sizeof(struct zram), GFP_KERNEL) as a matter of 
convention.
