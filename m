Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab2FUWOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:14:14 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:42013 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756930Ab2FUWOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:14:02 -0400
X-Greylist: delayed 1328 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2012 18:14:01 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=Fj9ijFOvV4Lyn5LWhptQtqDkMrXqVIH9xgJ7hyBI/adUeuaW7xkcaTQO6yGV7YUaL2xcWvWpPz/dtcYwe4xQQSEbGzLHXeX/Oe2NGIF+Q2TyTNguCDC18CigVkW/7CY6v5j9ZgS6l699LNitztEe+YlRL9j9YPm4rStYLIiVOjQ=;
Date: Fri, 22 Jun 2012 01:50:56 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Josh Hunt <johunt@akamai.com>, "davem@davemloft.net" <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        Debabrata Banerjee <dbavatar@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "pekkas@netcore.fi" <pekkas@netcore.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bug in net/ipv6/ip6_fib.c:fib6_dump_table()
Message-ID: <20120621215056.GA24908@ms2.inr.ac.ru>
References: <CAATkVEzTxT6d5nzt_qwCuFWM-WcN8hdhjGxFRPXJ4=L35wKbGw@mail.gmail.com> <4FE37783.9000409@akamai.com> <1340310469.4604.6702.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340310469.4604.6702.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 10:27:49PM +0200, Eric Dumazet wrote:
> Looking at this code, it lacks proper synchronization
> between tree updaters and tree walkers.
> 
> fib6_walker_lock rwlock is not enough to prevent races.

Hmm. As author of this weird code, I must say I honestly believed it was correct.
At least I tried. :-)


What's about 2bec5a336.., it does not look reasonable.
The idea was that when you change tree, you fixup sleeping walkers, moving
their location in tree to correct point. So, walkers must not have any stale pointers
at any times (except when you under table write lock) and no skips/counts are required.
I remember how damn difficult was it to make this right (well, sorry, if it is not yet :-)),
so that understand that if some update is forgotten or done incorrectly, it is not so easy to find,
but it is definitely worth of efforts.

Alexey
