Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0F0ONB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 10:13:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35384 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab0F0OM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 10:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type
         :content-transfer-encoding;
        b=CjdEpspMggaj8qptw2PKGEmQA3ZIozZIOrV3IpkXXgalzrVWyX/KmA60MD2NmkcDNY
         cZxU0eUoaP0yQRrZknyOe4wcT2pDDtCcKxU7uN4AB0VkZ7Wje4BT/1L7tZpXLHhFNH7B
         v9vLn6FsXWyWBqP2n625GZI+Z+ymqrQ3Rxc0Y=
Date: Sun, 27 Jun 2010 07:12:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [regression, bisected] SysRq commands trigger without holding
 sysrq.
In-Reply-To: <20100614145659.GA2594@elliptictech.com>
Message-ID: <alpine.LFD.2.00.1006270710210.7802@i5.linux-foundation.org>
References: <20100614145659.GA2594@elliptictech.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jun 2010, Nick Bowler wrote:
>
> It appears that the new SysRq handling stuff totally ignores key
> releases: I don't have to hold down any of the keys to trigger sysrq
> commands.  For example, if I press and release left-alt, then press and
> release print screen, then press b, the system reboots.  The order in
> which I press the keys matters, but I can press other keys between them
> and still trigger sysrq commands (e.g. I can press and release alt, type
> a bunch, press print screen, then start triggering commands by pressing
> letters).
> 
> The result is that it is very easy to accidentally trigger sysrq
> commands, to the detriment of a system's usefulness.  It also renders
> the printscreen key completely useless after either alt key has been
> pressed once since system bootup (printscreen works fine until alt is
> pressed).
> 
> Bisection reveals the following, and reverting the implicated commit
> (resolving a trivial conflict) solves the issue.
> 
> 97f5f0cd8cd0a05449cbb77d1e6f02e026875802 is the first bad commit

Dmitry? I didn't see any follow-ups on this issue, should I just do the 
revert, or is there some better fix?

There's another report about this from Éric Piel.

		Linus
