Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0EGIUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:20:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40855 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab0EGIUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:20:07 -0400
Message-ID: <4BE3CC6B.2080008@vflare.org>
Date: Fri, 07 May 2010 13:46:43 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: jassi brar <jassisinghbrar@gmail.com>
CC: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/3] Add flag to identify block swap devices
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org>	 <1273217107-2023-2-git-send-email-ngupta@vflare.org> <y2m1b68c6791005070103q8cabf3afx22af4a28c6ecf747@mail.gmail.com>
In-Reply-To: <y2m1b68c6791005070103q8cabf3afx22af4a28c6ecf747@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 01:33 PM, jassi brar wrote:
> On Fri, May 7, 2010 at 4:25 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>> Added SWP_BLKDEV flag to distinguish block and regular file backed
>> swap devices. We could also check if a swap is entire block device,
>> rather than a file, by:
>> S_ISBLK(swap_info_struct->swap_file->f_mapping->host->i_mode)
>> but, I think, simply checking this flag is more convenient.
> This might make it convenient for now but is likely to increase complexity and
> redundancy. Why not define a macro/inline to figure that out?
> 

Accessing such long pointer chain is maybe not good thing to do for
every swap_entry_free() call? Simple checking a flag is perhaps slightly
faster? I also can't see how this flag can later increase complexity
compared to creating new macro for this check.

Thanks,
Nitin
