Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0K3HEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 02:04:10 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36037 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab0K3HEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 02:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vOILczti25In7DH3zVF5LHLzwuA+rCilQwCA/yelBUlFlqRygB1tRha5j75SLwX7OP
         PIDXIWYfhTQcie0PEHxdvpopAihbA+/wW3o7Na4heuBzDNpuxPrQtEtYZiGvvCvBLsl4
         2DsqlFTAC3wvqarIT3knlJwKkQHj1/TehIwTs=
Subject: Re: 2 epoll questions
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mike Blumenkrantz <mike@zentific.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20101129191705.094f5c4d@darc.ath.cx>
References: <20101129191705.094f5c4d@darc.ath.cx>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 08:03:51 +0100
Message-ID: <1291100631.2725.39.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 novembre 2010 à 19:17 -0500, Mike Blumenkrantz a écrit :
> Hi,
> 
> I am not subscribed to the list yet, and I would appreciate it if all replies
> could be CCed to me :).
> 
> I have two questions regarding epoll.  The epoll code that I am using can all
> be found in the file here for those interested:
> https://svn.enlightenment.org/svn/e/trunk/ecore/src/lib/ecore/ecore_main.c
> 
> 1) Is there any known reason why adding fds to an epoll fd would begin to slow
> down dramatically after ~6000 fds are added?  It is entirely possible that the
> problem is not epoll at all, but I wanted to ask and see if there was some O(n)
> code somewhere that was known.
> 

No particular slowdown, I once used more than 1.5 million fds in epoll
fd.

Of course, if you only add/remove fds as fast as possible, its going to
be slower, since epoll fds are stored in a tree, and the time of
insert/delete of one item depends on the tree depth. Maybe this is your
case and your working set is larger than your cpu caches after ~6000
fds ?


> 2) If a select on an epoll fd (not one inside the epoll, the actual epoll fd
> itself) returns EBADF, is there a way to determine which fd is causing the
> error and then remove it?  I am occasionally running into this issue, and it
> seems to be caused by code which I do not necessarily control closing a fd that
> is part of my epoll fd without my knowledge (meaning that the closed fd is
> still in epoll).

Strange, I never got this EBADF error. On epoll_ctl() or epoll_wait() ?
(I dont understand your "select on epoll fd"). epoll is meant to replace
select()...

When you close a file descriptor, its automatically removed from epoll
as well.



