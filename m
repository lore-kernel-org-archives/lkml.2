Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2EAMW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 08:22:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab2EAMW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 08:22:58 -0400
Date: Tue, 1 May 2012 14:22:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: deadlock in vt_kbd_con_stop
In-Reply-To: <4F9FBDD0.7050504@ladisch.de>
Message-ID: <alpine.LRH.2.00.1205011421570.10244@twin.jikos.cz>
References: <4F9FBDD0.7050504@ladisch.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012, Clemens Ladisch wrote:

> Pressing the Scroll Lock key in the console stops scrolling rather permanently.
> (Ctrl+S/Q works fine.)
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.4.0-rc5+ #354 Not tainted
> ---------------------------------------------
> swapper/5/0 is trying to acquire lock:
>  (kbd_event_lock){-.....}, at: [<ffffffff8127802c>] vt_kbd_con_stop+0x1a/0x57
> 
> but task is already holding lock:
>  (kbd_event_lock){-.....}, at: [<ffffffff81277a84>] kbd_event+0x29/0x5b7
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(kbd_event_lock);
>   lock(kbd_event_lock);
> 
>  *** DEADLOCK ***

Seems like I have actually hit this yesterday for real, so it's not just a 
theoretical scenario, see

	https://lkml.org/lkml/2012/4/30/90

-- 
Jiri Kosina
SUSE Labs

