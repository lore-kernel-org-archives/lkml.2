Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab0CPM6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 08:58:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:58690 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528Ab0CPM6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 08:58:16 -0400
Date: Tue, 16 Mar 2010 13:58:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: avoid '\0' in hid debugfs events file
In-Reply-To: <20100315190027.752c82ea@neptune.home>
Message-ID: <alpine.LNX.2.00.1003161354380.18642@pobox.suse.cz>
References: <20100315190027.752c82ea@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010, Bruno Prémont wrote:

> When dumping /sys/kernel/debug/hid/$device/events '\0' characters show up
> (invisible if cat to console but shown by less or while looking at a dump
> file).
> These are due to hid_debug_event() adding strlen()+1 bytes to the ring
> buffer (e.g. including the trailing '\0').
> Any roll-over causes a '\0' as well as hid_debug_event() handles the ring
> buffers with HID_DEBUG_BUFSIZE-1 size while hid_debug_events_read() handles
> it with full HID_DEBUG_BUFSIZE size.

Applied, thanks.

> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> ---
> Note:
> The ring buffer overflow case (when tail crosses head) seems to be
> suboptimal at best.
> Would there be a good way to mark those cases so reader can know where
> data got lost. (though this might not be easy keeping the lockless
> design)

I agree that there might be better implementation. The circular buffer is 
merely the same to what we use in other userspace interfaces already (see 
original hiddev, for example). Plus this is only debugging interface, and 
with SIZE being 512, it's very unlikely that events will get lost.

But I don't think the lockless design is that important here, so if you 
are motivated to rewrite it to something better, I wouldn't object.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
