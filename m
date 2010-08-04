Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab0HDBuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:50:46 -0400
Received: from tuxonice.net ([74.207.252.127]:33057 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758045Ab0HDBuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:50:44 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C58C771.6040505@tuxonice.net>
Date: Wed, 04 Aug 2010 11:50:41 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
References: <1280465201.2600.10.camel@shrek.rexursive.com>	 <1280486667.2608.1.camel@shrek.rexursive.com>	 <4C534C9D.8000600@tuxonice.net>	 <1280532174.2583.1.camel@shrek.rexursive.com>	 <4C5362E7.3000706@tuxonice.net>	 <1280538184.2583.11.camel@shrek.rexursive.com>	 <4C537A01.5040808@tuxonice.net>	 <1280540035.2658.5.camel@shrek.rexursive.com>	 <1280551286.3097.6.camel@shrek.rexursive.com>	 <20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>	 <1280710453.2727.8.camel@shrek.rexursive.com>	 <20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>	 <1280712068.2671.0.camel@shrek.rexursive.com>	 <20100802102750.7d414819.kamezawa.hiroyu@jp.fujitsu.com>	 <1280713381.2673.2.camel@shrek.rexursive.com> <1280800750.3305.4.camel@shrek.rexursive.com>
In-Reply-To: <1280800750.3305.4.camel@shrek.rexursive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Sorry for the delay in replying.

On 03/08/10 11:59, Bojan Smojver wrote:
>> From all this, I only got "In swsusp_free()" printed on resume. So, it
> seems that save_image() does indeed free those vmalloc()-ed buffers and
> they are not saved in the image.
>
> I even put this in hibernate.c:
> ---------------------
>          /* Restore control flow magically appears here */
>          restore_processor_state();
>          if (!in_suspend)
>                  platform_leave(platform_mode);
>
>          printk(KERN_ERR "Resumed, checking swsusp_lzo_buffers.\n");
>          if (swsusp_lzo_buffers) {
>                  printk (KERN_ERR "Setting vmalloc() buffers.\n");
>                  memset(swsusp_lzo_buffers, 0, 80 * PAGE_SIZE);
>          }
> ---------------------
>
> This printed just "Resumed, checking swsusp_lzo_buffers.", meaning it
> was already set to NULL.
>
> Any further comments on this? Nigel, what do you reckon?

I don't see what all the fuss was about. save_image is called after the 
snapshot is made (hibernate called hibernation_snapshot to create the 
image, then swsusp_write which in turn calls save_image), so there's no 
possibility of the memory allocated by it being included in the image or 
of a memory leak ocuring as a result.

Regards,

Nigel
