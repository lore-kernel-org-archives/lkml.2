Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab0HQV05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:26:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35820 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab0HQV0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Z+hm5ClebyTKcmpV7ahFGw4Wp+nQDVhlekT9IMi+tUikx2kNlnfS/wL4dSGVTHsjHk
         HbYqPuWGOdiam+cPMytnR/Hl341sUuFmpQ1H2qeJTeOJ1y3JWcqBK7e7VVnKdS8ggEZl
         suOa8+Ud8W65nzoIkCg9Vhhp5mDlq/RyL6LrQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTik9qUf_F0NDoW2SBjWGHk2=ZdvkLrCORu3gGa2o@mail.gmail.com>
References: <20100816.211218.189709876.davem@davemloft.net>
	<AANLkTikDXoRMRL0y_Y_7qVS=9LOw_yLS9MuUgq2dTCZf@mail.gmail.com>
	<AANLkTi=ZdrtWSYE0BEXJ-YDoxjta3h7RMR7Y8Z6Hu-Hc@mail.gmail.com>
	<AANLkTinO5yip7agVO3Lq3YLjDYmkB9MP14xjt3TusMfW@mail.gmail.com>
	<AANLkTik9qUf_F0NDoW2SBjWGHk2=ZdvkLrCORu3gGa2o@mail.gmail.com>
Date: Tue, 17 Aug 2010 14:26:49 -0700
X-Google-Sender-Auth: w5mg0tCMxJKKVBG1B5QNhzXcGY8
Message-ID: <AANLkTikhhHroKtC32UxSjFxGhisvjUu9qUygs0FZt9No@mail.gmail.com>
Subject: Re: tasks getting stuck on mmap_sem?
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Michel Lespinasse <walken@google.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 2:08 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>   git repack -adf

$ /usr/bin/time git repack -adf
Counting objects: 125946, done.
Delta compression using up to 32 threads.
Compressing objects: 100% (124132/124132), done.
Writing objects: 100% (125946/125946), done.
Total 125946 (delta 92181), reused 0 (delta 0)
75.80user 5.83system 0:28.59elapsed 285%CPU (0avgtext+0avgdata
12414976maxresident)k
0inputs+0outputs (9major+17615minor)pagefaults 0swaps

Some threading, some page faults, no processes stuck on rwsem things.

Left that command in a while loop ... 10 repeats so far.

-Tony
