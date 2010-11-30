Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0K3AhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:37:03 -0500
Received: from eastrmmtai108.cox.net ([68.230.240.27]:56845 "EHLO
	eastrmmtai108.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab0K3AhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:37:01 -0500
X-Greylist: delayed 1194 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Nov 2010 19:37:01 EST
X-VR-Score: -10.00
X-Authority-Analysis: v=1.1 cv=PkQKpMSOrKoV9KYRrKr2f7XLnN0m7+zjYAinWDuNKA4=
 c=1 sm=1 a=kj9zAlcOel0A:10 a=PNuEMszh5xg2EB3JV8u8OQ==:17 a=iE-e0aDHAAAA:8
 a=98XX_LaI_pQ-Supxp_wA:9 a=zqx-uMMKJFWY9zPCyG8A:7
 a=-jRPxNlQp7BRu4c35Rk0kyvPRPYA:4 a=CjuIK1q_8ugA:10
 a=PNuEMszh5xg2EB3JV8u8OQ==:117
X-CM-Score: 0.00
Authentication-Results: cox.net; none
Date: Mon, 29 Nov 2010 19:17:05 -0500
From: Mike Blumenkrantz <mike@zentific.com>
To: linux-kernel@vger.kernel.org
Subject: 2 epoll questions
Message-ID: <20101129191705.094f5c4d@darc.ath.cx>
Organization: Zentific
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am not subscribed to the list yet, and I would appreciate it if all replies
could be CCed to me :).

I have two questions regarding epoll.  The epoll code that I am using can all
be found in the file here for those interested:
https://svn.enlightenment.org/svn/e/trunk/ecore/src/lib/ecore/ecore_main.c

1) Is there any known reason why adding fds to an epoll fd would begin to slow
down dramatically after ~6000 fds are added?  It is entirely possible that the
problem is not epoll at all, but I wanted to ask and see if there was some O(n)
code somewhere that was known.

2) If a select on an epoll fd (not one inside the epoll, the actual epoll fd
itself) returns EBADF, is there a way to determine which fd is causing the
error and then remove it?  I am occasionally running into this issue, and it
seems to be caused by code which I do not necessarily control closing a fd that
is part of my epoll fd without my knowledge (meaning that the closed fd is
still in epoll).

Thanks!

-- 
Mike Blumenkrantz
Zentific: Our boolean values are huge.
