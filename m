Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab1DDUHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:07:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43128 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab1DDUHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wuTqUU+6Lg8hhCx9gIQ3SI/9VK073eQ0FLtN6/t8+YiPxK7gmWP1qW/7NJNKYnC/u4
         4+5qD/cogyH/ffNSKsAaCIHIXN0IAtAC8YoxcnktCs7z6YSQNXBL2rrsNZpr80K9KVDL
         /mam3ZrR/AC5JOxk+Xzw9vR7kp/G73qVnSfYU=
Subject: Re: X86_32: Got a kernel panic when poweroff
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "wanlong.gao" <wanlong.gao@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <201104050339475463862@gmail.com>
References: <201104050339475463862@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 22:07:15 +0200
Message-ID: <1301947635.3021.20.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 05 avril 2011 à 03:39 +0800, wanlong.gao a écrit :
> Hi , all
> When I did poweroff or reboot .
> It got a kernel panic .
> I just have several pictures about these panic .
> I tried to fix it , but I can't do .
> 
> Here are the pictures .
> http://images.cnblogs.com/cnblogs_com/linuxkernel/291984/r_1.jpg
> http://images.cnblogs.com/cnblogs_com/linuxkernel/291984/r_2.png
> http://images.cnblogs.com/cnblogs_com/linuxkernel/291984/r_3.png
> http://images.cnblogs.com/cnblogs_com/linuxkernel/291984/r_4.png
> http://images.cnblogs.com/cnblogs_com/linuxkernel/291984/r_5.png
> 
> Thanks ,goot night .
> 

A module called register_syscore_ops(), and was unloaded without calling
unregister_syscore_ops()

Hmm... maybe arch/x86/kernel/microcode_core.c ?

Try reverting f3c6ea1b06c71b43f751b36bd9



