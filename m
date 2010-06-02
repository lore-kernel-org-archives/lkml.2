Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab0FBMhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:37:23 -0400
Received: from crca.org.au ([74.207.252.120]:51555 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab0FBMhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:37:21 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C065079.1020208@crca.org.au>
Date: Wed, 02 Jun 2010 22:37:13 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [linux-pm] [PATCH 1/9] PM / Hibernate: swap,	switch to hibernate_io_handle
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 02/06/10 18:52, Jiri Slaby wrote:
> Hi,
>
> I addressed the comments I got on the previous RFC. I left the handles
> in place, the functions in hibernate_io_ops now works on them. Further
> I got rid of the memory barriers and minimized global variables as much
> as possible. Comments welcome.
>
> --
>
> Some code, which will be moved out of swap.c, will know nothing about
> swap. There will be also other than swap writers later, so that it
> won't make sense at all.
>
> So introduce a new structure called hibernate_io_handle which
> currently contains only a pointer to private data, but is independent
> on I/O reader/writer actually used. Private data are swap_map_handle
> for now.
>
> This structure is allocated in _start and freed in _finish. This will
> correspond to the later introduction of hibernate_io_ops where users
> will do handle=start->repeat{read/write(handle)}->finish(handle).
> I.e. they will operate on handle instead of global variables.

I'm starting on appending your patch series to mine (yes, I've given you 
no time to object :> I'm too keen!)

Since, in my tree, swap_map pages are history, I'll skip this patch.

Nigel
