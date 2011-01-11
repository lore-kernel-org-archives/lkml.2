Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1AKApa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:45:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36619 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1AKAp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:45:28 -0500
Message-ID: <4D2BA81E.50600@kernel.org>
Date: Mon, 10 Jan 2011 16:45:18 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: David Brown <davidb@codeaurora.org>, sedat.dilek@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        ftpadmin@kernel.org, webmaster@kernel.org
Subject: Re: patchwork.kernel.org down
References: <AANLkTik4ktaeyDG3ihh-YRB+WVLxA46wSLOgWy6iY_68@mail.gmail.com>	<20101220204936.GA21290@huya.qualcomm.com>	<4D0FFC4B.9050301@kernel.org> <ada62u3dkv2.fsf@cisco.com>	<adaei8k8ubh.fsf@cisco.com> <4D2B664F.7050106@kernel.org> <ada1v4k8pnw.fsf@cisco.com>
In-Reply-To: <ada1v4k8pnw.fsf@cisco.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Mon, 10 Jan 2011 16:45:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 12:33 PM, Roland Dreier wrote:
>  > Not yet, I'm adding it in this afternoon.  I did the upgrade to Fedora
>  > 14 (and thus 2.6.35.10) and seem to be getting, if not the same bug, a
>  > darned similar one:
>  > 
>  > http://pastebin.osuosl.org/36644
> 
> Actually that looks pretty different; the trace is
> 
>  put_ldisc+0x8d/0xb4
>  tty_ldisc_reinit+0x43/0x5c
>  tty_ldisc_hangup+0x10d/0x19d
>  do_tty_hangup+0x108/0x343
>  ? __raw_local_irq_save+0x1d/0x23
>  tty_vhangup_self+0x27/0x34
>  sys_vhangup+0x22/0x29
>  system_call_fastpath+0x16/0x1b
> 
> which doesn't involve any /proc/net file being closed at all.
> 
> Hmm...

My thoughts on why it was possibly similar is that it happens

[  793.932076] kernel BUG at mm/slub.c:2834!

where as 20702 is

kernel BUG at mm/slub.c:2835!

the rest didn't line up, and like I said I haven't specifically dug into it.

As a note I did end up with a full panic in the last hour, but nothing
got recorded (sadly).  I'm working on getting the kernel compiled up
with everything now so hopefully I'll start getting some additional data
to share.

- John 'Warthog9' Hawley
