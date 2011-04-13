Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab1DMBXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:23:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33291 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab1DMBXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Ej2G9zkNTIuZ4U/9Zv21n+rQ08zafhQEVdG5loy7T8q0VRhv1QXJe42GS+aENx4/ZJ
         ot1mpucuHcNSsz3gvaS92/vPWeFQrVtNxhHuLYRIYvlCp8na8B+20A8FD4aWyUBSrIGE
         VDvTdrZ1C961BxsGOxem/tmW+5iKE+jmPxuPo=
MIME-Version: 1.0
In-Reply-To: <20110412154906.70829d60.akpm@linux-foundation.org>
References: <20110315132527.130FB80018F1@mail1005.cent> <20110317001519.GB18911@kroah.com>
 <20110407120112.E08DCA03@pobox.sk> <4D9D8FAA.9080405@suse.cz>
 <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com> <1302177428.3357.25.camel@edumazet-laptop>
 <1302178426.3357.34.camel@edumazet-laptop> <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
 <1302190586.3357.45.camel@edumazet-laptop> <20110412154906.70829d60.akpm@linux-foundation.org>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 13 Apr 2011 09:23:11 +0800
Message-ID: <BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>
Subject: Re: Regression from 2.6.36
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 6:49 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> It's somewhat unclear (to me) what caused this regression.
>
> Is it because the kernel is now doing large kmalloc()s for the fdtable,
> and this makes the page allocator go nuts trying to satisfy high-order
> page allocation requests?
>
> Is it because the kernel now will usually free the fdtable
> synchronously within the rcu callback, rather than deferring this to a
> workqueue?
>
> The latter seems unlikely, so I'm thinking this was a case of
> high-order-allocations-considered-harmful?
>

Maybe, but I am not sure. Maybe my patch causes too many inner
fragments. For example, when asking for 5 pages, get 8 pages, and 3
pages are wasted, then memory thrash happens finally.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
