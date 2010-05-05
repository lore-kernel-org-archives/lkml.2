Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934834Ab0EEQZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:25:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934535Ab0EEQZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:25:12 -0400
Date: Wed, 5 May 2010 09:22:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nitin Gupta <ngupta@vflare.org>
cc: Greg KH <greg@kroah.com>, Minchan Kim <minchan.kim@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data in compressed
 memory
In-Reply-To: <4BE1973D.5040206@vflare.org>
Message-ID: <alpine.LFD.2.00.1005050912310.5478@i5.linux-foundation.org>
References: <1273067156-2574-1-git-send-email-ngupta@vflare.org> <alpine.LFD.2.00.1005050809490.5478@i5.linux-foundation.org> <4BE1973D.5040206@vflare.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 May 2010, Nitin Gupta wrote:
> 
> I think such 'swap_operations' structure will be have to be part of
> block_device_operations, so we may access it from swap_entry_free()
> where a swap slot is freed. This will also get rid of all this notifier
> stuff.

Yes, I think adding it to block_device_operations would be fine. That 
sounds like a sane layering, and would make it easy for a block device 
driver to say "I want to know about swap events".

In fact, for regular block devices, a swap block free might well translate 
into a TRIM command some day (where "some day" means when the SSD's 
actually get their stuff together and there is real upside and not just 
"most cases will be very slow and the upside is debatable").

> The patch you nacked did something similar: it add 'swap_slot_free_callback'
> directly to block_device_operations. Without such change, I could not think
> of any way to do away with notifiers.

Umm. No. IIRC, the patch I NAK'ed aded it to the 'swap_info_struct', which 
I said was the wrong level. The block device driver level would seem to be 
the _right_ level, since that's what ramzswap is. No?

Also, the patch I NAK'ed also used those nasty notifier chains, making it 
even uglier.

				Linus
