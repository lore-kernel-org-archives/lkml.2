Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab0LMM0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:26:23 -0500
Received: from mx1.sophos.com ([195.166.81.52]:56459 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab0LMM0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:26:22 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: Polling(2) /proc/mounts is broken?
Date: Mon, 13 Dec 2010 12:26:18 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5; KDE/4.4.4; x86_64; ; )
CC: Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <d8aa5094-8042-4172-8e1d-7d2c7f2299a7@us-col-exch1.green.sophos>
In-Reply-To: <d8aa5094-8042-4172-8e1d-7d2c7f2299a7@us-col-exch1.green.sophos>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <201012131226.19265.tvrtko.ursulin@sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 Dec 2010 15:32:48 Tvrtko Ursulin wrote:
> Hi all,
>
> So since we cannot get fanotify global mode we were told to poll(2) on
> /proc/mounts and set up new mount marks dynamically.
>
> Is the attached C program roughly how it should work?
>
> Because on 2.6.37-rc5 it busy loops for me (POLLIN always reported), even
> though if I remove the seek it gets EOF immediately after POLLIN.
>
> Under 2.6.32 (Ubuntu flavour) I see the same behaviour.
>
> Going further back to 2.6.24 (again Ubuntu flavour) and there it works, but
> it set POLLERR instead of POLLIN in revents.
>
> So I guess it regressed somewhere in between. I'll look to provide a fix
> unless someone more familiar with this area beats me to it.

It hasn't regressed but was fixed in 2.6.30. :)

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=31b07093c44a7a442394d44423e21d783f5523b8

So it is incorrect to poll for POLLIN. In case of /proc/mounts POLLPRI should
be used and will be returned together with POLLERR.

Tvrtko

Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 991 2418 08.
