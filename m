Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0KHTnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:43:55 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53717 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0KHTnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:43:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=diR7nlHQC7zoLVUfY6666ldZH+pIapqErPTCqOvA5G71yTNAvPI4fueSFW3vRZ7S4T
         MB3gZOjXHbH/Ya8+5M7vTRo3gsnv+ZTXAO69j8BvfRt2A54QICNC9qXS9y5raa2cdgvK
         672LNEx45EnTv6t4pgu8f02ydmGUug5xjxIK8=
From: Francis Moreau <francis.moro@gmail.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Victor Jimenez <victor.javier@bsc.es>,
        Reid Kleckner <reid.kleckner@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
References: <fa.SSgtQesEhEQa5DUYUwBV3fWtoV4@ifi.uio.no>
	<fa.dD5ur5Phqa1TLmYBE2NVKCQMjTw@ifi.uio.no>
	<fa.Xj1lA7n6nIJYL40CeRDpQzSKlfc@ifi.uio.no>
	<fa.xcyA+VzIXesq6qsPU6ADM4xdCKY@ifi.uio.no>
	<fa.MOg61Pcfdp2SJnwM2GFdOxP+xt0@ifi.uio.no>
	<fa.4sHfhlc/fMhpYgKda4IfUHZ7jMY@ifi.uio.no> <m2wros3pzf.fsf@gmail.com>
	<alpine.DEB.2.00.1011051000310.26020@cl320.eecs.utk.edu>
	<m262wao6k7.fsf@gmail.com>
	<alpine.DEB.2.00.1011061642020.29635@cl320.eecs.utk.edu>
Date: Mon, 08 Nov 2010 20:43:48 +0100
In-Reply-To: <alpine.DEB.2.00.1011061642020.29635@cl320.eecs.utk.edu> (Vince
	Weaver's message of "Sat, 6 Nov 2010 16:50:35 -0400 (EDT)")
Message-ID: <m24obr1tzf.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince Weaver <vweaver1@eecs.utk.edu> writes:

> This is rapidly getting of topic, especially for linux-kernel

Don't think so but feel free to remove LKML from Cc.

[...]

> Most events are poorly documented, if at all.  And the Linux kernel 
> predefined event list is loosely based upon the intel architectural
> events, which not every processor has and I've heard from insiders saying 
> that you should be very careful for the results from those events.

I agree, that's why I try to clarify some events.

Perf tools are cool stuffs, IMHO, but it's pretty hard for me to
interpret results. I tried to compare some numbers in my previous posts
but I got some 'random' figures for now.

Another example is given below where I'm trying to bench a 2 functions
which do the same thing but differently.

   $ perf stat -e cache-misses:u,l1d-loads-misses:u,cycles:u -p $(pgrep test)
     C-c C-c
    Performance counter stats for process id '30263':
   
                406532  cache-misses            
               4986030  L1-dcache-load-misses   
             120247366  cycles                  
   
           2.482196928  seconds time elapsed
   
   
   $ perf stat -e cache-misses:u,l1d-loads-misses:u,cycles:u -p $(pgrep test)
     C-c C-c
    Performance counter stats for process id '30271':
   
                459683  cache-misses            
               2513338  L1-dcache-load-misses   
             159968076  cycles                  
   
           2.129021265  seconds time elapsed

Which numbers are important here ? cache-misses ? L1-dcache-load-misses
?

I just can say that the first run looks faster.

-- 
Francis
