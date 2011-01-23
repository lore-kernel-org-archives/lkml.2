Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab1AWQPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 11:15:09 -0500
Received: from ns.km10614-05.keymachine.de ([87.118.102.170]:55327 "EHLO
	km10614-05.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750981Ab1AWQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 11:15:08 -0500
Date: Sun, 23 Jan 2011 17:15:00 +0100
From: Harald Braumann <harry@unheit.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Deadlock on concurrent remount-ro and mdadm --stop (2.6.37)
Message-ID: <20110123161500.GB4108@nn.nn>
Mail-Followup-To: Harald Braumann <harry@unheit.net>,
	linux-kernel@vger.kernel.org
References: <20110121124754.GA5233@nn.nn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121124754.GA5233@nn.nn>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 01:47:54PM +0100, Harald Braumann wrote:
> On shutdown `umountroot' and `mdadm-raid'  are executed concurrently. The 
> actual commands are:
> mount -o remount,ro /
> mdadm --stop --scan
> 
> This seems to trigger a deadlock in the kernel. Dumping blocked tasks (sysrq-W)
> gives:
> 
> md126_raid5: call trace:
>   md_super_wait
>   autoremove_wake_function
>   bitmap_unplug
>   ...
> 
> mount: call trace:
>   sync_page
>   io_schedule
>   sync_page

I've now disable parallel boot in my system, so umountroot and mdadm
shouldn't be called cuncurrently anymore. But I still get lock-ups on
mdadm --stop. Umountroot is called before mdadm --stop, and all other
filesystems are unmounted before that, so I guess
there should be no `sync_page' in progress anymore. But I also have
swap on the raid, so maybe there's a problem?

As not even the magic SysRQ keys work, I can't provide any more
details. Any suggestions how I could debug this problem?

Cheers,
harry
