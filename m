Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab2KBBJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 21:09:23 -0400
Received: from lirone.symas.net ([64.71.152.235]:33489 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab2KBBJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 21:09:21 -0400
X-Greylist: delayed 1823 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2012 21:09:21 EDT
Message-ID: <50931601.4060102@symas.com>
Date: Thu, 01 Nov 2012 17:38:25 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/19.0 Firefox/19.0 SeaMonkey/2.16a1
MIME-Version: 1.0
To: General Discussion of SQLite Database <sqlite-users@sqlite.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Vladislav Bolkhovitin <vst@vlnb.net>,
        "Theodore Ts'o" <tytso@mit.edu>, drh@hwaci.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org> <508B3EED.2080003@vlnb.net> <20121027044456.GA2764@thunk.org> <5090532D.4050902@vlnb.net> <20121031095404.0ac18a4b@pyramind.ukuu.org.uk> <5092D90F.7020105@vlnb.net> <20121101212418.140e3a82@pyramind.ukuu.org.uk>
In-Reply-To: <20121101212418.140e3a82@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> How about that recently preliminary infrastructure to send ORDERED commands
>> instead of queue draining was deleted from the kernel, because "there's no
>> difference where to drain the queue, on the kernel or the storage side"?
>
> Send patches.

Isn't any type of kernel-side ordering an exercise in futility, since
   a) the kernel has no knowledge of the disk's actual geometry
   b) most drives will internally re-order requests anyway
   c) cheap drives won't support barriers

Even assuming the drives honored all your requests without lying, how would 
you really want this behavior exposed? From the userland perspective, there 
are very few apps that care. Probably only transactional databases, really.

As a DB author, I'm not sure I'd be keen on this as an open() or fcntl() 
option. Databases that really care would be on dedicated filesystems and/or 
devices, so per-file control would be tedious. You would most likely want to 
say "all writes to this string of devices should be order-preserving" and 
forget about it. With that guarantee, a careful writer can have perfectly 
intact data structures all the time, without ever slowing down for a fsync.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
