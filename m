Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab0KLR6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:58:38 -0500
Received: from minus.inr.ac.ru ([194.67.69.97]:43617 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752182Ab0KLR6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:58:37 -0500
X-Greylist: delayed 716 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2010 12:58:36 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=fIUeY5XT7B7ZclU4TUj4ea8XyPLsH2MPm6rLmyESmtkXKfyTVqcqE9HqP5M5MMIoXHKBq1auYS66KAyD8dH2n4ZOaRPK3uvqfsXzJrEW9TlXB3txXXmglyJtSwUOqYKAT5KblpE0mHwOXJUhZvJuff7UXLHFrEloUouwVXP50vo=;
Date: Fri, 12 Nov 2010 20:57:15 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Patrick McHardy <kaber@trash.net>
Cc: David Lamparter <equinox@diac24.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Eric Paris <eparis@redhat.com>,
        Hua Zhong <hzhong@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, paul.moore@hp.com
Subject: a problem tcp_v4_err()
Message-ID: <20101112175715.GB16544@ms2.inr.ac.ru>
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com> <00c201cb81eb$84e18160$8ea48420$@com> <1289578108.3083.95.camel@localhost.localdomain> <1289578532.3185.265.camel@edumazet-laptop> <20101112163543.GB122902@jupiter.n2.diac24.net> <4CDD7145.8070606@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDD7145.8070606@trash.net>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I looked at tcp_v4_err() and found something strange. Quite non-trivial operations
are performed on unlocked sockets. It looks like at least this BUG_ON():

                skb = tcp_write_queue_head(sk);
                BUG_ON(!skb);

can be easily triggered.

Do I miss something?

Alexey
