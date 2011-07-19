Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1GSGP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 02:15:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63277 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1GSGP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 02:15:57 -0400
Message-ID: <4E252117.4000500@gmail.com>
Date: Tue, 19 Jul 2011 16:15:51 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Ravishankar <ravishankarkm32@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 1/2 v3] Staging: comedi: fix printk() issue in adv_pci1710.c
References: <1311054656-14207-1-git-send-email-ravishanakarkm32@gmail.com> <4E251F1F.2080406@gmail.com> <20110719061226.GF4010@shale.localdomain>
In-Reply-To: <20110719061226.GF4010@shale.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/11 16:12, Dan Carpenter wrote:
> On Tue, Jul 19, 2011 at 04:07:27PM +1000, Ryan Mallon wrote:
>> This still isn't correct. The initial printk (KERN_INFO above) has
>> no trailing newline. Here you are almost doing it correctly, except
>> that you are adding an extra newline. This error message will look
>> like this:
>>
>> comedi0: adv_pci1710:
>> comedi0: adv_pci1710: Allocation failed
>>
> Actually kmalloc() prints an message with a stack trace on failure as
> well so that would go in the middle, just before the first newline.
>

Thanks. Didn't know that. Is that a KConfig option or by default?

Either way, it's another good reason to get rid of all the KERN_CONT 
stuff in the driver.

~Ryan
