Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab2KRSa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 13:30:28 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2353 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab2KRSa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 13:30:27 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <50A92935.5070802@broadcom.com>
Date: Sun, 18 Nov 2012 19:30:13 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028
 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Mark Ellis" <m@rkellis.com>
cc: linux-kernel@vger.kernel.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Piotr Haber" <phaber@broadcom.com>
Subject: Re: PROBLEM: REGRESSION in drivers/platform/x86/dell-laptop.c
References: <50A8BCA6.7080102@rkellis.com>
In-Reply-To: <50A8BCA6.7080102@rkellis.com>
X-WSS-ID: 7CB7F7133R04751422-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2012 11:47 AM, Mark Ellis wrote:
> 1. rfkill code removal causes hang
>
> 2. the rfkill code was removed from this driver in commit
> 53039f222c548bfc119eea6df4dca2b57550e271 this results in my computer
> hanging (dell n5050) if booting with the wireless (hardware) disabled.
> downgrading this module to the version prior to this commit fixes the
> issue.

The commit you mention does not touch dell-laptop.c. The commit before 
that one doe, but it is only adding code. Digging the tree I found this 
one between kernel v3.4 and v3.5-rc1:

commit a6c2390cd6d2083d27a2359658e08f2d3df375ac
Author: Matthew Garrett <mjg@redhat.com>
Date:   Fri Jun 1 12:46:56 2012 -0400

     dell-laptop: Remove rfkill code

     The interface just doesn't work on some machines, and Dell haven't been
     able to tell us either which machines those are or what we should be
     doing instead. This would be fine, except it results in userspace 
ending
     up confused and general sadness. So let's just rip it out for now.

     Signed-off-by: Matthew Garrett <mjg@redhat.com>

Actually, the behavior you describe and given you have a BCM4313 running 
with brcmsmac I may point out that this driver has an issue coming up 
with wireless disabled. This has been fixed in 3.7 kernel so you may 
want to try:

commit 82d8eba358badb466a4e988ecabf0668a8d92e9c
Author: Piotr Haber <phaber@broadcom.com>
Date:   Wed Sep 19 22:21:15 2012 +0200

     brcmsmac: don't start device when RfKill is engaged

     This patch fixes a bug when device is being started
     while RfKill switch is engaged, leading to hang
     due to partial initialization of hardware.

     Tested-by: <dragonn@op.pl>
     Reviewed-by: Arend van Spriel <arend@broadcom.com>
     Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
     Signed-off-by: Piotr Haber <phaber@broadcom.com>
     Signed-off-by: Arend van Spriel <arend@broadcom.com>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>

Maybe I should resubmit it to stable. Now there is an idea.

Gr. AvS

