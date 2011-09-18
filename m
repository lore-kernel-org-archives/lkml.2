Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1IRI6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 04:58:39 -0400
Received: from mail-wy0-f170.google.com ([74.125.82.170]:64876 "EHLO
	mail-wy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab1IRI6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 04:58:38 -0400
Subject: Re: [PATCH 1/3] sys_poll: Fix negative timeout values for x86
 userland on x86_64 kernels v2
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
In-Reply-To: <1316333042.5814.23.camel@localhost.localdomain>
References: <1316333042.5814.23.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Sep 2011 10:58:26 +0200
Message-ID: <1316336306.31335.8.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 18 septembre 2011 à 10:04 +0200, Thomas Meyer a écrit :
> size of int and long differs on x86 and x86_64. the ia32 emulation calls
> directly into the sys_poll function. when the timeout is set to -1
> the test for sign will fail in sys_poll as the 64bit register is tested.
> the timeout timer will be set to 0xffffffff milliseconds, but the timer
> shouldn't get set at all in this situation.
> 

As I said, you should CC stable@kernel.org team on this patch.
All previous linux versions had this bug : A program might misbehave
because of a spurious poll(..., timeout < 0) wakeup.

Could you please refine this Changelog again ?

On 32bit user program, all negative timeout values should not set a
timout at all, not only 0xffffffff (-1)

man poll states :

The timeout argument specifies an upper limit on the time for which
poll() will block, in milliseconds.  Specifying a negative value in
timeout means an infinite timeout.



