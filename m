Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab1JMPuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:50:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61760 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab1JMPuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:50:07 -0400
Date: Thu, 13 Oct 2011 19:50:02 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?w4lyaWM=?= Brunet <Eric.Brunet@lps.ens.fr>,
        linux-kernel@vger.kernel.org, tiwai@suse.de, linux-pm@vger.kernel.org
Subject: Re: Fw: List corruption and crash with kernel 3.1
Message-ID: <20111013155002.GA10632@oksana.dev.rtsoft.ru>
References: <20111011162500.db7cd65f.akpm@linux-foundation.org>
 <1318410972.23801.143.camel@ted>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1318410972.23801.143.camel@ted>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend, add proper Cc's.

On Wed, Oct 12, 2011 at 10:16:08AM +0100, Richard Purdie wrote:
> On Tue, 2011-10-11 at 16:25 -0700, Andrew Morton wrote:
> > erk, help, who do I blame for this?
> 
> [...]
> 
> > WARNING: at lib/list_debug.c:47 __list_del_entry+0x8d/0x98()
> > Hardware name: Latitude E4200
> > list_del corruption, ffff880075e147b0->next is LIST_POISON1 (dead000000100100)
> [...]
> >  [<ffffffff81243861>] __list_del_entry+0x8d/0x98
> >  [<ffffffff8124387a>] list_del+0xe/0x2d
> >  [<ffffffff813a7e55>] led_trigger_unregister+0x29/0x9c
> >  [<ffffffff813a7ee1>] led_trigger_unregister_simple+0x19/0x26
> >  [<ffffffff813828e2>] power_supply_remove_triggers+0x21/0x8f
> >  [<ffffffff81381d42>] power_supply_unregister+0x1f/0x2c
> >  [<ffffffff812a7d1f>] sysfs_remove_battery+0x3c/0x54
> >  [<ffffffff812a8c4d>] acpi_battery_notify+0x46/0xaa
> 
> As far as I know (and can see from the changelogs), the LED trigger
> registration code hasn't changed in a long time.
> led_trigger_unregister_simple() and led_trigger_unregister() are
> relatively simple functions and looking at the latter, the list_del
> causing this is fairly clear.
> 
> What puzzles me is that led_trigger_unregister_simple() wouldn't call
> led_trigger_unregister() twice for the same trigger as it frees the
> memory.
> 
> However, if that function were called multiple times in parallel with
> the same trigger, I can imagine it racing.
> 
> My thought is therefore is something in the power_supply* code calling
> this function multiple times and a race?

I wonder if that patch helps:

https://lkml.org/lkml/2011/7/12/242

The traces are pretty similar.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
