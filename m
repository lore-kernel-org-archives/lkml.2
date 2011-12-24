Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1LXPP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 10:15:58 -0500
Received: from mail.tpi.com ([70.99.223.143]:2282 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab1LXPP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 10:15:57 -0500
Message-ID: <4EF5ECA2.1040305@canonical.com>
Date: Sat, 24 Dec 2011 08:15:46 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Joseph Salisbury <joseph.salisbury@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Possible issue with commit: "clockevents: Set noop handler in
 clockevents_exchange_device()"
References: <4EF528E7.4040000@canonical.com>
In-Reply-To: <4EF528E7.4040000@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2011 06:20 PM, Joseph Salisbury wrote:
> Hi Thomas,
>
> We have been working on a bug[1] that affects suspend/resume. After
> running some tests, it appears the regression has to do with a commit
> you submitted:
>
>
> commit b01b383bbd04e9dcf7d9fe6ca3751b77ccdc533c
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri Dec 2 16:02:45 2011 +0100
>
> clockevents: Set noop handler in clockevents_exchange_device()
>
> commit de28f25e8244c7353abed8de0c7792f5f883588c upstream.
>
> If a device is shutdown, then there might be a pending interrupt,
> which will be processed after we reenable interrupts, which causes the
> original handler to be run. If the old handler is the (broadcast)
> periodic handler the shutdown state might hang the kernel completely.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
>
> We tested with this commit reverted in the 3.0.13 kernel and the
> suspend/resume bug went away. We also tested the 3.2-rc6 kernel with
> this commit reverted and the bug went away there as well.
>
> I wanted to let you know about this issue and see if there is any
> additional details you might need from me.
>
> Thanks,
>
> Joe
>
>
>
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/904569
>

To be clear, this regression appears to exist in the 3.2-rc6: 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/904569/comments/24

Cc'ing LKML

rtg
-- 
Tim Gardner tim.gardner@canonical.com
