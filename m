Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1AJUd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:33:28 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:30562 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab1AJUd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:33:26 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMz7Kk2rR7H+/2dsb2JhbACkS3OiephIhUwEhGeGIw
From: Roland Dreier <rdreier@cisco.com>
To: "J.H." <warthog9@kernel.org>
Cc: David Brown <davidb@codeaurora.org>, sedat.dilek@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        ftpadmin@kernel.org, webmaster@kernel.org
Subject: Re: patchwork.kernel.org down
References: <AANLkTik4ktaeyDG3ihh-YRB+WVLxA46wSLOgWy6iY_68@mail.gmail.com>
	<20101220204936.GA21290@huya.qualcomm.com>
	<4D0FFC4B.9050301@kernel.org> <ada62u3dkv2.fsf@cisco.com>
	<adaei8k8ubh.fsf@cisco.com> <4D2B664F.7050106@kernel.org>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 10 Jan 2011 12:33:23 -0800
In-Reply-To: <4D2B664F.7050106@kernel.org> (J. H.'s message of "Mon, 10 Jan
	2011 12:04:31 -0800")
Message-ID: <ada1v4k8pnw.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Not yet, I'm adding it in this afternoon.  I did the upgrade to Fedora
 > 14 (and thus 2.6.35.10) and seem to be getting, if not the same bug, a
 > darned similar one:
 > 
 > http://pastebin.osuosl.org/36644

Actually that looks pretty different; the trace is

 put_ldisc+0x8d/0xb4
 tty_ldisc_reinit+0x43/0x5c
 tty_ldisc_hangup+0x10d/0x19d
 do_tty_hangup+0x108/0x343
 ? __raw_local_irq_save+0x1d/0x23
 tty_vhangup_self+0x27/0x34
 sys_vhangup+0x22/0x29
 system_call_fastpath+0x16/0x1b

which doesn't involve any /proc/net file being closed at all.

Hmm...
