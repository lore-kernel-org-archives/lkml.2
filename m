Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab2HMJId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 05:08:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59651 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750923Ab2HMJIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 05:08:32 -0400
Message-ID: <1344848911.5849.10.camel@joe2Laptop>
Subject: Re: [flame^Wreview] net: netprio_cgroup: rework update socket logic
From: Joe Perches <joe@perches.com>
To: John Fastabend <john.r.fastabend@intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Date: Mon, 13 Aug 2012 02:08:31 -0700
In-Reply-To: <502896C5.7080303@intel.com>
References: <20120813015348.GZ23464@ZenIV.linux.org.uk>
	 <502896C5.7080303@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-12 at 22:55 -0700, John Fastabend wrote:
> On 8/12/2012 6:53 PM, Al Viro wrote:
> > 	Ladies and gentlemen, who the devil had reviewed that little gem?
> >
> > commit 406a3c638ce8b17d9704052c07955490f732c2b8
> > Author: John Fastabend <john.r.fastabend@intel.com>
> > Date:   Fri Jul 20 10:39:25 2012 +0000
[]
> OK clearly I screwed it up thanks for reviewing Al. How about this.
> 
>                  fdt = files_fdtable(files);
>                  for (fd = 0; fd < fdt->max_fds; fd++) {
>                          struct socket *sock;
>                          int err = 0;

Don't need to initialize err if you're not using it.

>                          sock = sockfd_lookup(fd, &err);
>                          if (!sock) {

Of course you mean
			if (sock)

>                                  lock_sock(sock->sk);
>                                  sock_update_netprioidx(sock->sk, p);
>                                  release_sock(sock->sk);
>                                  sockfd_put(sock);
>                          }
>                  }


