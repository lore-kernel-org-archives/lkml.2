Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab0EVTSa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 15:18:30 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:53974 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab0EVTS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 15:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JQRg/R0dO0i59S7yazxBqQqe0NG5IJxghXNIOA+tvKX0HslLVl0EXaRaHH5sppVAAI
         ZBG6daNAI7ldR5k1S7YMNQuFthNNA9cFX+uIh0si2oPBv3qYqNcDHXcvszj1zhn8Yd0q
         WEVn+eiE/DkMjeWz8ojC2wYiJka2dAjRejHGE=
MIME-Version: 1.0
In-Reply-To: <20100514133723.GA10351@basil.fritz.box>
References: <20100514133723.GA10351@basil.fritz.box>
Date: Sat, 22 May 2010 16:18:27 -0300
Message-ID: <AANLkTilzIEPxROksx_WHjs3LlCChVk6mm1stBeLMOFku@mail.gmail.com>
Subject: Re: RTL8185 mlme.c:341 warning and failure still in 2.6.34rc7
From: Rogerio Luz Coelho <rogluz.news@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/14 Andi Kleen <andi@firstfloor.org>:
>
> [ccing Rafael because this seems to be a regression. Please add it to your list.]
>
> When I boot my system with a RTL8185 the wireless doesn't come up at boot,
> only when I manually restart it. Instead i get
>
> I reported this a few rc*s back, but haven't heard anything back and the
> problem is still there.
>
> For me it's a serious problem when the wireless does not come up.
>
> This didn't happen in .33.
>
> -Andi
>
> wlan0: authenticate with 00:1f:3f:1d:54:46 (try 1)
> wlan0: authenticated
> wlan0: associate with 00:1f:3f:1d:54:46 (try 1)
> wlan0: associate with 00:1f:3f:1d:54:46 (try 2)
> wlan0: associate with 00:1f:3f:1d:54:46 (try 3)
> wlan0: association with 00:1f:3f:1d:54:46 timed out
> ------------[ cut here ]------------
> WARNING: at /home/lsrc/linux-2.6.34-rc7/net/wireless/mlme.c:341 cfg80211_send_assoc_timeout+0xff/0x117 [cfg80211]()
> Hardware name: ...
> Modules linked in:  ...
> Pid: 3344, comm: phy0 Not tainted 2.6.34-rc7 #7
> Call Trace:
>  [<ffffffffa0072124>] ? cfg80211_send_assoc_timeout+0xff/0x117 [cfg80211]
>  [<ffffffff8103a4f0>] warn_slowpath_common+0x7c/0xa9
>  [<ffffffff8103a531>] warn_slowpath_null+0x14/0x16
>  [<ffffffffa0072124>] cfg80211_send_assoc_timeout+0xff/0x117 [cfg80211]
>  [<ffffffffa00e6393>] ieee80211_assoc_done+0x74/0xa9 [mac80211]
>  [<ffffffffa00e85f0>] ieee80211_work_work+0xe4c/0xe8d [mac80211]
>  [<ffffffff81033cbe>] ? finish_task_switch+0x42/0xab
>  [<ffffffff810535d7>] ? prepare_to_wait+0x6e/0x7a
>  [<ffffffff8104f832>] worker_thread+0x192/0x227
>  [<ffffffffa00e77a4>] ? ieee80211_work_work+0x0/0xe8d [mac80211]
>  [<ffffffff81053342>] ? autoremove_wake_function+0x0/0x3d
>  [<ffffffff8104f6a0>] ? worker_thread+0x0/0x227
>  [<ffffffff81052efc>] kthread+0x82/0x8a
>  [<ffffffff81003954>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81052e7a>] ? kthread+0x0/0x8a
>  [<ffffffff81003950>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace 4e3067114aa2fd06 ]---
> wlan0: deauthenticating from 00:1f:3f:1d:54:46 by local choice (reason=3)

This is what my rtl8187b says also ... no luck finding the cure, just
look at the thread posted here in the last few months:

http://thread.gmane.org/gmane.linux.kernel.wireless.general/48877/focus=50042

Rogerio
