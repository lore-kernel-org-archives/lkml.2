Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab1EXCHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 22:07:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59777 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab1EXCHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 22:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dvgIxuY1ON38Pwih8fVsUXdbyNr606sMecp8YbIuyPPwz66/CHtpaBzrieCJoYtfl2
         Q5o8H53OzxfUWmzX6823NrpfpVzEzrtQfyy0Fq2YeZVt6v9k2UsdyO5rHdj9oYmhB3uH
         Egbqs0rSoE5C4nCJ13bi6FGMj5hkPjyflsi68=
MIME-Version: 1.0
In-Reply-To: <20110520161816.dda6f1fd.sfr@canb.auug.org.au>
References: <20110520161816.dda6f1fd.sfr@canb.auug.org.au>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 23 May 2011 22:06:40 -0400
Message-ID: <BANLkTimjzzqTS1fELmpb0UivqseLsYOfPw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 02:18, Stephen Rothwell wrote:
> Caused by commit e66eed651fd1 ("list: remove prefetching from regular list
> iterators").
>
> I added the following patch for today:

probably should get added to whatever tree that commit is coming from
so we dont have bisect hell ?

more failures:
drivers/usb/host/isp1362-hcd.c: In function 'isp1362_write_ptd':
drivers/usb/host/isp1362-hcd.c:355: error: implicit declaration of
function 'prefetch'
drivers/usb/host/isp1362-hcd.c: In function 'isp1362_read_ptd':
drivers/usb/host/isp1362-hcd.c:377: error: implicit declaration of
function 'prefetchw'
make[3]: *** [drivers/usb/host/isp1362-hcd.o] Error 1

drivers/usb/musb/musb_core.c: In function 'musb_write_fifo':
drivers/usb/musb/musb_core.c:219: error: implicit declaration of
function 'prefetch'
make[3]: *** [drivers/usb/musb/musb_core.o] Error 1

although it seems like it should be fairly trivial to look at the
funcs in linux/prefetch.h, grep the tree, and find a pretty good list
of the files that are missing the include
-mike
